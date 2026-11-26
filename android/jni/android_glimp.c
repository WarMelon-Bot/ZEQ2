/*
 * Android EGL/GLES 1 GLimp implementation for ZEQ2-Lite.
 *
 * This replaces sdl_glimp.c and sdl_gamma.c in Android client builds.  It also
 * provides the tiny subset of desktop immediate mode used by the renderer and
 * the touch overlay.
 */

#include "../../Engine/renderer/tr_local.h"
#include "../../Shared/qcommon.h"
#include "android_local.h"

#include <EGL/egl.h>
#include <GLES/gl.h>
#include <GLES/glext.h>
#include <android/log.h>
#include <android/native_window.h>

/* qgl.h only declares these; this generated header allocates them. */
#include "qgl_defs.h"

#define ANDROID_GL_LOG_TAG "ZEQ2-GL"

/* Stop the compatibility macros from recursing inside their implementation. */
#undef glBegin
#undef glEnd
#undef glClientActiveTexture
#undef glColorPointer
#undef glTexCoordPointer
#undef glVertexPointer
#undef glColor3f
#undef glColor4f
#undef glColor4ubv
#undef glVertex2f
#undef glVertex2fv
#undef glVertex3f
#undef glVertex3fv
#undef glTexCoord2f
#undef glTexCoord2fv
#undef glArrayElement
#undef glCallList
#undef glClipPlane
#undef glDrawBuffer
#undef glFogi
#undef glPolygonMode

#define IMMEDIATE_MAX_VERTS 16384
#define ANDROID_MAX_TEXTURE_UNITS 8

typedef struct {
	const GLvoid *pointer;
	GLint size;
	GLenum type;
	GLsizei stride;
} arrayState_t;

typedef struct {
	GLenum mode;
	int count;

	GLfloat currentColor[4];
	GLfloat currentTexCoord[2];

	GLfloat vertices[IMMEDIATE_MAX_VERTS * 3];
	GLfloat colors[IMMEDIATE_MAX_VERTS * 4];
	GLfloat texCoords[IMMEDIATE_MAX_VERTS * 2];
	GLushort quadIndices[IMMEDIATE_MAX_VERTS / 4 * 6];
	qboolean quadIndicesReady;

	/* R_DrawStripElements() has no GLES glArrayElement, so collect its
	 * indexes and submit them with glDrawElements at glEnd. */
	GLushort indexes[IMMEDIATE_MAX_VERTS];
	int indexCount;
	qboolean useIndexes;
} immediateState_t;

static immediateState_t immediate;
static arrayState_t vertexArray;
static arrayState_t colorArray;
static arrayState_t texCoordArray[ ANDROID_MAX_TEXTURE_UNITS ];
static int currentTexCoordUnit = 0;
static EGLDisplay eglDisplay = EGL_NO_DISPLAY;
static EGLConfig eglConfig;
static EGLSurface eglSurface = EGL_NO_SURFACE;
static EGLContext eglContext = EGL_NO_CONTEXT;
static qboolean eglConfigured = qfalse;
static EGLint eglMajor = 0;
static EGLint eglMinor = 0;
static int androidGLWidth = 0;
static int androidGLHeight = 0;
static qboolean androidGLDispatchReady = qfalse;

/*
=================
GLimp_LogComment
=================
*/
void GLimp_LogComment( char *comment )
{
	if ( comment && *comment ) {
		__android_log_write( ANDROID_LOG_VERBOSE, ANDROID_GL_LOG_TAG, comment );
	}
}

/*
=================
Array pointer compatibility
=================
*/
static void Android_RecordArray( arrayState_t *state, GLint size, GLenum type,
	GLsizei stride, const GLvoid *pointer )
{
	state->size = size;
	state->type = type;
	state->stride = stride;
	state->pointer = pointer;
}

void Android_glClientActiveTexture( GLenum texture )
{
	int unit = (int)texture - (int)GL_TEXTURE0_ARB;

	if ( unit >= 0 && unit < ANDROID_MAX_TEXTURE_UNITS ) {
		currentTexCoordUnit = unit;
	}
	glClientActiveTexture( texture );
}

void Android_glColorPointer( GLint size, GLenum type, GLsizei stride,
	const GLvoid *pointer )
{
	Android_RecordArray( &colorArray, size, type, stride, pointer );
	glColorPointer( size, type, stride, pointer );
}

void Android_glTexCoordPointer( GLint size, GLenum type, GLsizei stride,
	const GLvoid *pointer )
{
	if ( currentTexCoordUnit >= 0 && currentTexCoordUnit < ANDROID_MAX_TEXTURE_UNITS ) {
		Android_RecordArray( &texCoordArray[ currentTexCoordUnit ], size, type,
			stride, pointer );
	}
	glTexCoordPointer( size, type, stride, pointer );
}

void Android_glVertexPointer( GLint size, GLenum type, GLsizei stride,
	const GLvoid *pointer )
{
	Android_RecordArray( &vertexArray, size, type, stride, pointer );
	glVertexPointer( size, type, stride, pointer );
}

/*
=================
Immediate-mode compatibility
=================
*/
void Android_glBegin( GLenum mode )
{
	immediate.mode = mode;
	immediate.count = 0;
	immediate.indexCount = 0;
	immediate.useIndexes = qfalse;
}

static void Android_AddVertex( GLfloat x, GLfloat y, GLfloat z )
{
	int i;

	if ( immediate.count >= IMMEDIATE_MAX_VERTS ) {
		return;
	}

	i = immediate.count * 3;
	immediate.vertices[i] = x;
	immediate.vertices[i + 1] = y;
	immediate.vertices[i + 2] = z;

	i = immediate.count * 4;
	immediate.colors[i] = immediate.currentColor[0];
	immediate.colors[i + 1] = immediate.currentColor[1];
	immediate.colors[i + 2] = immediate.currentColor[2];
	immediate.colors[i + 3] = immediate.currentColor[3];

	i = immediate.count * 2;
	immediate.texCoords[i] = immediate.currentTexCoord[0];
	immediate.texCoords[i + 1] = immediate.currentTexCoord[1];

	immediate.count++;
}

void Android_glColor3f( GLfloat r, GLfloat g, GLfloat b )
{
	immediate.currentColor[0] = r;
	immediate.currentColor[1] = g;
	immediate.currentColor[2] = b;
	immediate.currentColor[3] = 1.0f;
	glColor4f( r, g, b, 1.0f );
}

void Android_glColor4f( GLfloat r, GLfloat g, GLfloat b, GLfloat a )
{
	immediate.currentColor[0] = r;
	immediate.currentColor[1] = g;
	immediate.currentColor[2] = b;
	immediate.currentColor[3] = a;
	glColor4f( r, g, b, a );
}

void Android_glColor4ubv( const GLubyte *v )
{
	if ( !v ) {
		return;
	}
	Android_glColor4f( v[0] / 255.0f, v[1] / 255.0f,
		v[2] / 255.0f, v[3] / 255.0f );
}

void Android_glVertex2f( GLfloat x, GLfloat y )
{
	Android_AddVertex( x, y, 0.0f );
}

void Android_glVertex2fv( const GLfloat *v )
{
	if ( v ) {
		Android_AddVertex( v[0], v[1], 0.0f );
	}
}

void Android_glVertex3f( GLfloat x, GLfloat y, GLfloat z )
{
	Android_AddVertex( x, y, z );
}

void Android_glVertex3fv( const GLfloat *v )
{
	if ( v ) {
		Android_AddVertex( v[0], v[1], v[2] );
	}
}

void Android_glTexCoord2f( GLfloat s, GLfloat t )
{
	/* GLES 1 has no immediate texcoord call; Android_glEnd submits arrays. */
	immediate.currentTexCoord[0] = s;
	immediate.currentTexCoord[1] = t;
}

void Android_glTexCoord2fv( const GLfloat *v )
{
	if ( v ) {
		Android_glTexCoord2f( v[0], v[1] );
	}
}

void Android_glArrayElement( GLint i )
{
	if ( i < 0 || i > 0xffff || immediate.indexCount >= IMMEDIATE_MAX_VERTS ) {
		return;
	}
	immediate.indexes[ immediate.indexCount++ ] = (GLushort)i;
	immediate.useIndexes = qtrue;
}

void Android_glCallList( GLuint list )
{
	(void)list;
}

void Android_glClipPlane( GLenum plane, const GLdouble *equation )
{
	(void)plane;
	(void)equation;
}

void Android_glDrawBuffer( GLenum mode )
{
	(void)mode;
}

void Android_glFogi( GLenum pname, GLint param )
{
	glFogf( pname, (GLfloat)param );
}

void Android_glPolygonMode( GLenum face, GLenum mode )
{
	(void)face;
	(void)mode;
}

void Android_glMultiTexCoord2fARB( GLenum target, GLfloat s, GLfloat t )
{
	if ( target == GL_TEXTURE0_ARB ) {
		Android_glTexCoord2f( s, t );
	}
}

static void Android_BindArrayPointers( void )
{
	int unit;

	if ( glIsEnabled( GL_VERTEX_ARRAY ) && vertexArray.pointer ) {
		glVertexPointer( vertexArray.size, vertexArray.type, vertexArray.stride,
			vertexArray.pointer );
	}
	if ( glIsEnabled( GL_COLOR_ARRAY ) && colorArray.pointer ) {
		glColorPointer( colorArray.size, colorArray.type, colorArray.stride,
			colorArray.pointer );
	}

	for ( unit = 0; unit < glConfig.numTextureUnits && unit < ANDROID_MAX_TEXTURE_UNITS; unit++ ) {
		glClientActiveTexture( GL_TEXTURE0_ARB + unit );
		if ( glIsEnabled( GL_TEXTURE_COORD_ARRAY ) && texCoordArray[ unit ].pointer ) {
			glTexCoordPointer( texCoordArray[ unit ].size, texCoordArray[ unit ].type,
				texCoordArray[ unit ].stride, texCoordArray[ unit ].pointer );
		}
	}
	glClientActiveTexture( GL_TEXTURE0_ARB + currentTexCoordUnit );
}

void Android_glEnd( void )
{
	GLboolean vertexArray;
	GLboolean colorArray;
	GLboolean texCoordArray;
	int i;

	if ( immediate.useIndexes ) {
		if ( immediate.indexCount >= 3 ) {
			/* The renderer's vertex/color/texcoord pointers are already bound.
			 * Rebind them in case another texture unit was made current. */
			Android_BindArrayPointers();
			glDrawElements( immediate.mode, immediate.indexCount,
				GL_UNSIGNED_SHORT, immediate.indexes );
		}
		immediate.indexCount = 0;
		immediate.useIndexes = qfalse;
		immediate.count = 0;
		return;
	}

	if ( immediate.count < 3 ) {
		immediate.count = 0;
		return;
	}

	vertexArray = glIsEnabled( GL_VERTEX_ARRAY );
	colorArray = glIsEnabled( GL_COLOR_ARRAY );
	texCoordArray = glIsEnabled( GL_TEXTURE_COORD_ARRAY );

	glEnableClientState( GL_VERTEX_ARRAY );
	glEnableClientState( GL_COLOR_ARRAY );
	glEnableClientState( GL_TEXTURE_COORD_ARRAY );
	glVertexPointer( 3, GL_FLOAT, 0, immediate.vertices );
	glColorPointer( 4, GL_FLOAT, 0, immediate.colors );
	glTexCoordPointer( 2, GL_FLOAT, 0, immediate.texCoords );

	if ( immediate.mode == GL_QUADS ) {
		if ( !immediate.quadIndicesReady ) {
			for ( i = 0; i < IMMEDIATE_MAX_VERTS / 4; i++ ) {
				int base = i * 4;
				int out = i * 6;
				immediate.quadIndices[out] = base;
				immediate.quadIndices[out + 1] = base + 1;
				immediate.quadIndices[out + 2] = base + 2;
				immediate.quadIndices[out + 3] = base;
				immediate.quadIndices[out + 4] = base + 2;
				immediate.quadIndices[out + 5] = base + 3;
			}
			immediate.quadIndicesReady = qtrue;
		}
		glDrawElements( GL_TRIANGLES, ( immediate.count / 4 ) * 6,
			GL_UNSIGNED_SHORT, immediate.quadIndices );
	} else {
		glDrawArrays( immediate.mode, 0, immediate.count );
	}

	if ( !vertexArray ) {
		glDisableClientState( GL_VERTEX_ARRAY );
	}
	if ( !colorArray ) {
		glDisableClientState( GL_COLOR_ARRAY );
	}
	if ( !texCoordArray ) {
		glDisableClientState( GL_TEXTURE_COORD_ARRAY );
	}

	immediate.count = 0;
}

/*
=================
GLimp_InitExtensions
=================
*/
static qboolean GLimp_HaveExtension( const char *ext )
{
	const char *ptr = Q_stristr( glConfig.extensions_string, ext );

	if ( !ptr ) {
		return qfalse;
	}
	ptr += strlen( ext );
	return ( *ptr == ' ' || *ptr == '\0' ) ? qtrue : qfalse;
}

static void GLimp_InitExtensions( void )
{
	int maxUnits = 1;

	if ( !r_allowExtensions || !r_allowExtensions->integer ) {
		ri.Printf( PRINT_ALL, "* IGNORING OPENGL EXTENSIONS *\n" );
		return;
	}

	glConfig.textureCompression = TC_NONE;
	glConfig.textureEnvAddAvailable = qfalse;
	textureFilterAnisotropic = qfalse;
	vertexShaders = qfalse;
	maxAnisotropy = 0;

	/* GLES 1 has core multitexture support on essentially every device. */
	qglActiveTextureARB = glActiveTexture;
	qglClientActiveTextureARB = glClientActiveTexture;
	qglMultiTexCoord2fARB = Android_glMultiTexCoord2fARB;
	glGetIntegerv( GL_MAX_TEXTURE_UNITS_ARB, &maxUnits );
	if ( maxUnits < 1 ) {
		maxUnits = 1;
	}
	glConfig.numTextureUnits = maxUnits;
	if ( maxUnits > 1 ) {
		ri.Printf( PRINT_ALL, "...using multitexture (%d units)\n", maxUnits );
	} else {
		qglActiveTextureARB = NULL;
		qglClientActiveTextureARB = NULL;
		qglMultiTexCoord2fARB = NULL;
		ri.Printf( PRINT_ALL, "...only one texture unit available\n" );
	}

	/* The compiled-vertex-array and shader extensions are desktop-only. */
	qglLockArraysEXT = NULL;
	qglUnlockArraysEXT = NULL;

	if ( GLimp_HaveExtension( "EXT_texture_env_add" ) &&
		r_ext_texture_env_add && r_ext_texture_env_add->integer ) {
		glConfig.textureEnvAddAvailable = qtrue;
		ri.Printf( PRINT_ALL, "...using GL_EXT_texture_env_add\n" );
	}
}

/*
=================
GLimp_SetMode
=================
*/
static qboolean GLimp_SetMode( void )
{
	EGLint configAttribs[] = {
		EGL_SURFACE_TYPE, EGL_WINDOW_BIT,
		EGL_RENDERABLE_TYPE, EGL_OPENGL_ES_BIT,
		EGL_RED_SIZE, 5,
		EGL_GREEN_SIZE, 6,
		EGL_BLUE_SIZE, 5,
		EGL_DEPTH_SIZE, 16,
		EGL_NONE
	};
	EGLint contextAttribs[] = {
		EGL_CONTEXT_CLIENT_VERSION, 1,
		EGL_NONE
	};
	EGLint format = 0;
	EGLint numConfigs = 0;

	if ( !sys_androidApp || !sys_androidApp->window ) {
		return qfalse;
	}

	eglDisplay = eglGetDisplay( EGL_DEFAULT_DISPLAY );
	if ( eglDisplay == EGL_NO_DISPLAY || !eglInitialize( eglDisplay, &eglMajor, &eglMinor ) ) {
		__android_log_print( ANDROID_LOG_ERROR, ANDROID_GL_LOG_TAG,
			"eglInitialize failed" );
		return qfalse;
	}

	if ( !eglChooseConfig( eglDisplay, configAttribs, &eglConfig, 1, &numConfigs ) || numConfigs < 1 ) {
		__android_log_print( ANDROID_LOG_ERROR, ANDROID_GL_LOG_TAG,
			"eglChooseConfig failed" );
		return qfalse;
	}

	if ( !eglGetConfigAttrib( eglDisplay, eglConfig, EGL_NATIVE_VISUAL_ID, &format ) ) {
		format = 0;
	}
	ANativeWindow_setBuffersGeometry( sys_androidApp->window, 0, 0, format );

	eglSurface = eglCreateWindowSurface( eglDisplay, eglConfig,
		sys_androidApp->window, NULL );
	if ( eglSurface == EGL_NO_SURFACE ) {
		__android_log_print( ANDROID_LOG_ERROR, ANDROID_GL_LOG_TAG,
			"eglCreateWindowSurface failed (0x%x)", eglGetError() );
		return qfalse;
	}

	eglContext = eglCreateContext( eglDisplay, eglConfig, EGL_NO_CONTEXT, contextAttribs );
	if ( eglContext == EGL_NO_CONTEXT ) {
		__android_log_print( ANDROID_LOG_ERROR, ANDROID_GL_LOG_TAG,
			"eglCreateContext failed (0x%x)", eglGetError() );
		return qfalse;
	}

	if ( !eglMakeCurrent( eglDisplay, eglSurface, eglSurface, eglContext ) ) {
		__android_log_print( ANDROID_LOG_ERROR, ANDROID_GL_LOG_TAG,
			"eglMakeCurrent failed (0x%x)", eglGetError() );
		return qfalse;
	}

	eglConfigured = qtrue;
	eglQuerySurface( eglDisplay, eglSurface, EGL_WIDTH, &androidGLWidth );
	eglQuerySurface( eglDisplay, eglSurface, EGL_HEIGHT, &androidGLHeight );
	if ( androidGLWidth < 1 ) androidGLWidth = 1;
	if ( androidGLHeight < 1 ) androidGLHeight = 1;

	Com_Memset( &immediate, 0, sizeof( immediate ) );
	immediate.currentColor[0] = 1.0f;
	immediate.currentColor[1] = 1.0f;
	immediate.currentColor[2] = 1.0f;
	immediate.currentColor[3] = 1.0f;
	immediate.currentTexCoord[0] = 0.0f;
	immediate.currentTexCoord[1] = 0.0f;

	return qtrue;
}

/*
=================
GLimp_Init
=================
*/
void GLimp_Init( void )
{
	const char *renderer;
	const char *vendor;
	const char *version;
	const char *extensions;
	EGLint red = 5, green = 6, blue = 5, depth = 0;

	/* NativeActivity delivers the surface after the process starts. */
	while ( !eglConfigured && !Android_IsDestroyed() ) {
		Android_PumpEvents();
		if ( GLimp_SetMode() ) {
			break;
		}
		Sys_Sleep( 16 );
	}

	if ( !eglConfigured ) {
		ri.Error( ERR_FATAL, "GLimp_Init() - no Android window or EGL context" );
		return;
	}

	/*
	 * The renderer calls everything through qgl_dispatch_table.  On desktop
	 * builds SDL's GLimp_Init fills that table; this port replaces GLimp_Init,
	 * so it has to do it too.  Until this runs every qgl* call dereferences a
	 * NULL function pointer, which is what made the app die right after the
	 * first EGL frame.  Do it after eglMakeCurrent (eglGetProcAddress needs a
	 * live display) and before GLimp_InitExtensions installs ARB wrappers,
	 * because QGL_InitGLDispatch clears those pointers.
	 */
	if ( !androidGLDispatchReady ) {
		QGL_InitGLDispatch();
		androidGLDispatchReady = qtrue;
	}
	QGL_SelectBackend( qfalse );	/* No Vulkan backend in the GLES 1 port. */

	renderer = (const char *)glGetString( GL_RENDERER );
	vendor = (const char *)glGetString( GL_VENDOR );
	version = (const char *)glGetString( GL_VERSION );
	extensions = (const char *)glGetString( GL_EXTENSIONS );

	Q_strncpyz( glConfig.renderer_string, renderer ? renderer : "GLES", sizeof( glConfig.renderer_string ) );
	Q_strncpyz( glConfig.vendor_string, vendor ? vendor : "unknown", sizeof( glConfig.vendor_string ) );
	Q_strncpyz( glConfig.version_string, version ? version : "GLES 1.0", sizeof( glConfig.version_string ) );
	Q_strncpyz( glConfig.extensions_string, extensions ? extensions : "", sizeof( glConfig.extensions_string ) );

	eglGetConfigAttrib( eglDisplay, eglConfig, EGL_RED_SIZE, &red );
	eglGetConfigAttrib( eglDisplay, eglConfig, EGL_GREEN_SIZE, &green );
	eglGetConfigAttrib( eglDisplay, eglConfig, EGL_BLUE_SIZE, &blue );
	eglGetConfigAttrib( eglDisplay, eglConfig, EGL_DEPTH_SIZE, &depth );

	glConfig.maxTextureSize = 2048;
	glGetIntegerv( GL_MAX_TEXTURE_SIZE, &glConfig.maxTextureSize );
	glConfig.numTextureUnits = 1;
	glConfig.colorBits = red + green + blue;
	glConfig.depthBits = depth;
	glConfig.stencilBits = 0;
	glConfig.driverType = GLDRV_ICD;
	glConfig.hardwareType = GLHW_GENERIC;
	glConfig.deviceSupportsGamma = qfalse;
	glConfig.vidWidth = androidGLWidth;
	glConfig.vidHeight = androidGLHeight;
	glConfig.windowAspect = (float)androidGLWidth / (float)androidGLHeight;
	glConfig.displayFrequency = 60;
	glConfig.isFullscreen = qtrue;
	glConfig.stereoEnabled = qfalse;
	glConfig.smpActive = qfalse;

	__android_log_print( ANDROID_LOG_INFO, ANDROID_GL_LOG_TAG,
		"EGL %d.%d, %dx%d, renderer: %s", eglMajor, eglMinor,
		glConfig.vidWidth, glConfig.vidHeight, glConfig.renderer_string );

	GLimp_InitExtensions();
}

/*
=================
GLimp_Shutdown
=================
*/
void GLimp_Shutdown( void )
{
	if ( eglDisplay == EGL_NO_DISPLAY ) {
		return;
	}

	eglMakeCurrent( eglDisplay, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT );
	if ( eglContext != EGL_NO_CONTEXT ) {
		eglDestroyContext( eglDisplay, eglContext );
	}
	if ( eglSurface != EGL_NO_SURFACE ) {
		eglDestroySurface( eglDisplay, eglSurface );
	}
	eglTerminate( eglDisplay );

	eglDisplay = EGL_NO_DISPLAY;
	eglConfig = 0;
	eglSurface = EGL_NO_SURFACE;
	eglContext = EGL_NO_CONTEXT;
	eglConfigured = qfalse;
}

/*
=================
GLimp_EndFrame
=================
*/
void GLimp_EndFrame( void )
{
	Android_PumpEvents();

	if ( Android_IsDestroyed() ) {
		Android_ExitEngine();
	}

	if ( !eglConfigured || !sys_androidApp || !sys_androidApp->window ) {
		/* Surface was destroyed for a pause; rebuild it from the new window. */
		GLimp_Shutdown();
		GLimp_SetMode();
		return;
	}

	eglSwapBuffers( eglDisplay, eglSurface );
}

/*
=================
Render thread stubs: GLES contexts stay on the NativeActivity thread.
=================
*/
qboolean GLimp_SpawnRenderThread( void (*function)( void ) )
{
	(void)function;
	return qfalse;
}

void GLimp_ShutdownRenderThread( void )
{
}

void *GLimp_RendererSleep( void )
{
	return NULL;
}

void GLimp_FrontEndSleep( void )
{
}

void GLimp_WakeRenderer( void *data )
{
	(void)data;
}

void GLimp_SetGamma( unsigned char red[256], unsigned char green[256], unsigned char blue[256] )
{
	(void)red;
	(void)green;
	(void)blue;
}
