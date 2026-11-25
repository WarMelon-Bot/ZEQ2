/*
 * Minimal SDL_opengl.h compatibility header for the Android GLES 1 build.
 *
 * The renderer was written against desktop OpenGL 1.x.  GLES 1 is close enough
 * to run it once the naming differences and the handful of desktop-only calls
 * are bridged.  Immediate-mode commands are implemented in android_glimp.c so
 * both the engine debug drawing and the touch overlay keep working.
 */
#ifndef __SDL_OPENGL_COMPAT_H__
#define __SDL_OPENGL_COMPAT_H__

#include <GLES/gl.h>
#include <GLES/glext.h>

#ifndef APIENTRY
#define APIENTRY GL_APIENTRY
#endif
#ifndef APIENTRYP
#define APIENTRYP GL_APIENTRYP
#endif

typedef unsigned int GLhandleARB;
typedef char GLcharARB;
typedef double GLdouble;
typedef double GLclampd;

/* Desktop tokens used by the renderer that GLES 1 does not name directly. */
#define GL_TEXTURE0_ARB                 0x84C0
#define GL_TEXTURE1_ARB                 0x84C1
#define GL_MAX_TEXTURE_UNITS_ARB        0x84E2
#define GL_OBJECT_COMPILE_STATUS_ARB    0x8B81
#define GL_OBJECT_LINK_STATUS_ARB       0x8B82
#define GL_OBJECT_INFO_LOG_LENGTH_ARB   0x8B84
#define GL_VERTEX_SHADER_ARB            0x8B31
#define GL_FRAGMENT_SHADER_ARB          0x8B30

#define GL_BACK_LEFT                    0x0402
#define GL_BACK_RIGHT                   0x0403
#define GL_CLAMP                        GL_CLAMP_TO_EDGE
#define GL_LINE                         0x1B01
#define GL_FILL                         0x1B02
#define GL_POLYGON                      0x0002
#define GL_QUADS                        0x0007
#define GL_INDEX_TYPE                   GL_UNSIGNED_INT
#define GL_STENCIL_INDEX                0x1901
#define GL_DEPTH_COMPONENT              0x1902
#define GL_TEXTURE_BORDER_COLOR         0x1004
#define GL_COMPRESSED_RGBA_S3TC_DXT1_EXT 0x83F1
#define GL_RGB4_S3TC                    0x83A1

/* GLES 1 accepts unsized internal formats. */
#define GL_RGB5                         GL_RGB
#define GL_RGB8                         GL_RGB
#define GL_RGBA4                        GL_RGBA
#define GL_RGBA8                        GL_RGBA
#define GL_LUMINANCE8                   GL_LUMINANCE
#define GL_LUMINANCE16                  GL_LUMINANCE
#define GL_LUMINANCE8_ALPHA8            GL_LUMINANCE_ALPHA
#define GL_LUMINANCE16_ALPHA16          GL_LUMINANCE_ALPHA

/* Desktop names that GES spells with an 'f' suffix. */
#define glOrtho                         glOrthof
#define glFrustum                       glFrustumf
#define glClearDepth                    glClearDepthf
#define glDepthRange                    glDepthRangef
#define glLoadMatrixd                   glLoadMatrixf
#define glMultMatrixd                   glMultMatrixf
#define glRotated                       glRotatef
#define glScaled                        glScalef
#define glTranslated                    glTranslatef
#define glGetDoublev                    glGetFloatv

/* Array pointer and immediate-mode shims implemented by android_glimp.c. */
void Android_glClientActiveTexture( GLenum texture );
void Android_glColorPointer( GLint size, GLenum type, GLsizei stride,
	const GLvoid *pointer );
void Android_glTexCoordPointer( GLint size, GLenum type, GLsizei stride,
	const GLvoid *pointer );
void Android_glVertexPointer( GLint size, GLenum type, GLsizei stride,
	const GLvoid *pointer );
void Android_glBegin( GLenum mode );
void Android_glEnd( void );
void Android_glColor3f( GLfloat r, GLfloat g, GLfloat b );
void Android_glColor4f( GLfloat r, GLfloat g, GLfloat b, GLfloat a );
void Android_glColor4ubv( const GLubyte *v );
void Android_glVertex2f( GLfloat x, GLfloat y );
void Android_glVertex2fv( const GLfloat *v );
void Android_glVertex3f( GLfloat x, GLfloat y, GLfloat z );
void Android_glVertex3fv( const GLfloat *v );
void Android_glTexCoord2f( GLfloat s, GLfloat t );
void Android_glTexCoord2fv( const GLfloat *v );
void Android_glArrayElement( GLint i );
void Android_glCallList( GLuint list );
void Android_glClipPlane( GLenum plane, const GLdouble *equation );
void Android_glDrawBuffer( GLenum mode );
void Android_glFogi( GLenum pname, GLint param );
void Android_glMultiTexCoord2fARB( GLenum target, GLfloat s, GLfloat t );
void Android_glPolygonMode( GLenum face, GLenum mode );

#define glClientActiveTexture           Android_glClientActiveTexture
#define glColorPointer                  Android_glColorPointer
#define glTexCoordPointer               Android_glTexCoordPointer
#define glVertexPointer                 Android_glVertexPointer
#define glBegin                         Android_glBegin
#define glEnd                           Android_glEnd
#define glColor3f                       Android_glColor3f
#define glColor4f                       Android_glColor4f
#define glColor4ubv                     Android_glColor4ubv
#define glVertex2f                      Android_glVertex2f
#define glVertex2fv                     Android_glVertex2fv
#define glVertex3f                      Android_glVertex3f
#define glVertex3fv                     Android_glVertex3fv
#define glTexCoord2f                    Android_glTexCoord2f
#define glTexCoord2fv                   Android_glTexCoord2fv
#define glArrayElement                  Android_glArrayElement
#define glCallList                      Android_glCallList
#define glClipPlane                     Android_glClipPlane
#define glDrawBuffer                    Android_glDrawBuffer
#define glFogi                          Android_glFogi
#define glPolygonMode                   Android_glPolygonMode

#endif /* __SDL_OPENGL_COMPAT_H__ */
