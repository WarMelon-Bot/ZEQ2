/*
 * qgl_dispatch.c -- runtime selection of the renderer's graphics entry points.
 *
 * The original renderer used compile-time qgl-to-gl macros.  Dispatching at
 * runtime lets the exact same scene/model/shader front end drive either the
 * OpenGL backend or the Vulkan translation backend after a vid_restart.
 */

#include "../../Shared/q_shared.h"
#include "qgl.h"

qglFunctionPointer qgl_dispatch_table[QGLFN_COUNT];

static qboolean qgl_using_vulkan = qfalse;

/*
 * Backend detection is used by glimp to know whether it should create a GL
 * context or a Vulkan swapchain, and by the console to report the active API.
 */
qboolean QGL_UsingVulkan( void )
{
	return qgl_using_vulkan;
}

const char *QGL_BackendName( void )
{
	return qgl_using_vulkan ? "Vulkan" : "OpenGL";
}

/*
 * Calls that are not meaningful for the target API are ignored instead of
 * crashing.  The Vulkan backend implements the subset the renderer actually
 * uses; anything else is a legacy fixed-function call.
 */
static void QGL_UnsupportedCall( void )
{
}

#define QGL_INIT_STUB(name) qgl_dispatch_table[QGLFN_##name].object = (void *)QGL_UnsupportedCall;
#define QGL_CLEAR_ARB(name) name = NULL;

#ifdef ANDROID
/*
 * The Android renderer targets GLES 1, whose header declares only a subset of
 * the desktop entry points in QGL_DISPATCH_FUNCS.  Looking the functions up by
 * name avoids referencing symbols that do not exist in that API.  Names the
 * renderer needs but GLES spells differently are supplied by the compatibility
 * shims in android/jni/SDL_opengl.h.
 */
#include <EGL/egl.h>

typedef struct {
	const char *name;
	void *function;
} qglAndroidShim_t;

#define QGL_ANDROID_SHIM(name) { #name, (void *)gl##name }
static const qglAndroidShim_t qglAndroidShims[] = {
	QGL_ANDROID_SHIM( Ortho ),
	QGL_ANDROID_SHIM( Frustum ),
	QGL_ANDROID_SHIM( ClearDepth ),
	QGL_ANDROID_SHIM( DepthRange ),
	QGL_ANDROID_SHIM( LoadMatrixd ),
	QGL_ANDROID_SHIM( MultMatrixd ),
	QGL_ANDROID_SHIM( Rotated ),
	QGL_ANDROID_SHIM( Scaled ),
	QGL_ANDROID_SHIM( Translated ),
	QGL_ANDROID_SHIM( GetDoublev ),
	QGL_ANDROID_SHIM( ClientActiveTexture ),
	QGL_ANDROID_SHIM( ColorPointer ),
	QGL_ANDROID_SHIM( TexCoordPointer ),
	QGL_ANDROID_SHIM( VertexPointer ),
	QGL_ANDROID_SHIM( Begin ),
	QGL_ANDROID_SHIM( End ),
	QGL_ANDROID_SHIM( Color3f ),
	QGL_ANDROID_SHIM( Color4f ),
	QGL_ANDROID_SHIM( Color4ubv ),
	QGL_ANDROID_SHIM( Vertex2f ),
	QGL_ANDROID_SHIM( Vertex2fv ),
	QGL_ANDROID_SHIM( Vertex3f ),
	QGL_ANDROID_SHIM( Vertex3fv ),
	QGL_ANDROID_SHIM( TexCoord2f ),
	QGL_ANDROID_SHIM( TexCoord2fv ),
	QGL_ANDROID_SHIM( ArrayElement ),
	QGL_ANDROID_SHIM( CallList ),
	QGL_ANDROID_SHIM( ClipPlane ),
	QGL_ANDROID_SHIM( DrawBuffer ),
	QGL_ANDROID_SHIM( Fogi ),
	QGL_ANDROID_SHIM( PolygonMode )
};
#undef QGL_ANDROID_SHIM

static void *QGL_AndroidResolveGL( const char *name ) {
	size_t i;
	void *function;

	for ( i = 0; i < ARRAY_LEN( qglAndroidShims ); i++ ) {
		if ( !strcmp( qglAndroidShims[i].name, name ) ) {
			return qglAndroidShims[i].function;
		}
	}

	function = (void *)eglGetProcAddress( name );
	return function ? function : (void *)QGL_UnsupportedCall;
}

#define QGL_INIT_GL(name) \
	qgl_dispatch_table[QGLFN_##name].object = QGL_AndroidResolveGL( "gl" #name );
#else
#define QGL_INIT_GL(name) qgl_dispatch_table[QGLFN_##name].object = (void *)(gl##name);
#endif

void QGL_ClearARBDispatch( void )
{
	QGL_ARB_FUNCS(QGL_CLEAR_ARB);
}

void QGL_SelectBackend( qboolean vulkan )
{
	qgl_using_vulkan = vulkan;
}

void QGL_InitGLDispatch( void )
{
	QGL_DISPATCH_FUNCS(QGL_INIT_GL);
	QGL_ClearARBDispatch();
}

void QGL_InitVulkanDispatch( void )
{
	QGL_DISPATCH_FUNCS(QGL_INIT_STUB);
	QGL_ClearARBDispatch();

#ifdef HAVE_VULKAN
	Vkqgl_InstallDispatch(qgl_dispatch_table);
#endif
}

#undef QGL_CLEAR_ARB
#undef QGL_INIT_STUB
#undef QGL_INIT_GL
