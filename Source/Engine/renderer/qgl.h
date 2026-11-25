/*
===========================================================================
Copyright (C) 1999-2005 Id Software, Inc.

This file is part of Quake III Arena source code.

Quake III Arena source code is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation; either version 2 of the License,
or (at your option) any later version.

Quake III Arena source code is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Quake III Arena source code; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
===========================================================================
*/
/*
** QGL.H
*/

#ifndef __QGL_H__
#define __QGL_H__

#ifdef USE_LOCAL_HEADERS
#	include "SDL_opengl.h"
#else
#	include <SDL_opengl.h>
#endif

#include "qgl_dispatch.h"

extern void (APIENTRYP qglActiveTextureARB) (GLenum texture);
extern void (APIENTRYP qglClientActiveTextureARB) (GLenum texture);
extern void (APIENTRYP qglMultiTexCoord2fARB) (GLenum target, GLfloat s, GLfloat t);

extern void (APIENTRYP qglLockArraysEXT) (GLint first, GLsizei count);
extern void (APIENTRYP qglUnlockArraysEXT) (void);

// GL_ARB_shader_objects
extern GLvoid (APIENTRYP qglDeleteObjectARB) (GLhandleARB obj);
extern GLhandleARB (APIENTRYP qglGetHandleARB) (GLenum pname);
extern GLvoid (APIENTRYP qglDetachObjectARB) (GLhandleARB containerObj, GLhandleARB attachedObj);
extern GLhandleARB (APIENTRYP qglCreateShaderObjectARB) (GLenum shaderType);
extern GLvoid (APIENTRYP qglShaderSourceARB) (GLhandleARB shaderObj, GLsizei count, const GLcharARB **string,
					      const GLint *length);
extern GLvoid (APIENTRYP qglCompileShaderARB) (GLhandleARB shaderObj);
extern GLhandleARB (APIENTRYP qglCreateProgramObjectARB) (void);
extern GLvoid (APIENTRYP qglAttachObjectARB) (GLhandleARB containerObj, GLhandleARB obj);
extern GLvoid (APIENTRYP qglLinkProgramARB) (GLhandleARB programObj);
extern GLvoid (APIENTRYP qglUseProgramObjectARB) (GLhandleARB programObj);
extern GLvoid (APIENTRYP qglValidateProgramARB) (GLhandleARB programObj);
extern GLvoid (APIENTRYP qglUniform1fARB) (GLint location, GLfloat v0);
extern GLvoid (APIENTRYP qglUniform2fARB) (GLint location, GLfloat v0, GLfloat v1);
extern GLvoid (APIENTRYP qglUniform3fARB) (GLint location, GLfloat v0, GLfloat v1, GLfloat v2);
extern GLvoid (APIENTRYP qglUniform4fARB) (GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3);
extern GLvoid (APIENTRYP qglUniform1iARB) (GLint location, GLint v0);
extern GLvoid (APIENTRYP qglUniform2iARB) (GLint location, GLint v0, GLint v1);
extern GLvoid (APIENTRYP qglUniform3iARB) (GLint location, GLint v0, GLint v1, GLint v2);
extern GLvoid (APIENTRYP qglUniform4iARB) (GLint location, GLint v0, GLint v1, GLint v2, GLint v3);
extern GLvoid (APIENTRYP qglUniform1fvARB) (GLint location, GLsizei count, const GLfloat *value);
extern GLvoid (APIENTRYP qglUniform2fvARB) (GLint location, GLsizei count, const GLfloat *value);
extern GLvoid (APIENTRYP qglUniform3fvARB) (GLint location, GLsizei count, const GLfloat *value);
extern GLvoid (APIENTRYP qglUniform4fvARB) (GLint location, GLsizei count, const GLfloat *value);
extern GLvoid (APIENTRYP qglUniform1ivARB) (GLint location, GLsizei count, const GLint *value);
extern GLvoid (APIENTRYP qglUniform2ivARB) (GLint location, GLsizei count, const GLint *value);
extern GLvoid (APIENTRYP qglUniform3ivARB) (GLint location, GLsizei count, const GLint *value);
extern GLvoid (APIENTRYP qglUniform4ivARB) (GLint location, GLsizei count, const GLint *value);
extern GLvoid (APIENTRYP qglUniformMatrix2fvARB) (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
extern GLvoid (APIENTRYP qglUniformMatrix3fvARB) (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
extern GLvoid (APIENTRYP qglUniformMatrix4fvARB) (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
extern GLvoid (APIENTRYP qglGetObjectParameterfvARB) (GLhandleARB obj, GLenum pname, GLfloat *params);
extern GLvoid (APIENTRYP qglGetObjectParameterivARB) (GLhandleARB obj, GLenum pname, GLint *params);
extern GLvoid (APIENTRYP qglGetInfoLogARB) (GLhandleARB obj, GLsizei maxLength, GLsizei *length, GLcharARB *infoLog);
extern GLvoid (APIENTRYP qglGetAttachedObjectsARB) (GLhandleARB containerObj, GLsizei maxCount, GLsizei *count,
						    GLhandleARB *obj);
extern GLint (APIENTRYP qglGetUniformLocationARB) (GLhandleARB programObj, const GLcharARB *name);
extern GLvoid (APIENTRYP qglGetActiveUniformARB) (GLhandleARB programObj, GLuint index, GLsizei maxLength,
						  GLsizei *length, GLint *size, GLenum *type, GLcharARB *name);
extern GLvoid (APIENTRYP qglGetUniformfvARB) (GLhandleARB programObj, GLint location, GLfloat *params);
extern GLvoid (APIENTRYP qglGetUniformivARB) (GLhandleARB programObj, GLint location, GLint *params);
extern GLvoid (APIENTRYP qglGetShaderSourceARB) (GLhandleARB obj, GLsizei maxLength, GLsizei *length,
						 GLcharARB *source);
extern GLvoid (APIENTRYP qglVertexAttrib1fARB) (GLuint index, GLfloat v0);
extern GLvoid (APIENTRYP qglVertexAttrib1sARB) (GLuint index, GLshort v0);
extern GLvoid (APIENTRYP qglVertexAttrib1dARB) (GLuint index, GLdouble v0);
extern GLvoid (APIENTRYP qglVertexAttrib2fARB) (GLuint index, GLfloat v0, GLfloat v1);
extern GLvoid (APIENTRYP qglVertexAttrib2sARB) (GLuint index, GLshort v0, GLshort v1);
extern GLvoid (APIENTRYP qglVertexAttrib2dARB) (GLuint index, GLdouble v0, GLdouble v1);
extern GLvoid (APIENTRYP qglVertexAttrib3fARB) (GLuint index, GLfloat v0, GLfloat v1, GLfloat v2);
extern GLvoid (APIENTRYP qglVertexAttrib3sARB) (GLuint index, GLshort v0, GLshort v1, GLshort v2);
extern GLvoid (APIENTRYP qglVertexAttrib3dARB) (GLuint index, GLdouble v0, GLdouble v1, GLdouble v2);
extern GLvoid (APIENTRYP qglVertexAttrib4fARB) (GLuint index, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3);
extern GLvoid (APIENTRYP qglVertexAttrib4sARB) (GLuint index, GLshort v0, GLshort v1, GLshort v2, GLshort v3);
extern GLvoid (APIENTRYP qglVertexAttrib4dARB) (GLuint index, GLdouble v0, GLdouble v1, GLdouble v2, GLdouble v3);
extern GLvoid (APIENTRYP qglVertexAttrib4NubARB) (GLuint index, GLubyte x, GLubyte y, GLubyte z, GLubyte w);
extern GLvoid (APIENTRYP qglVertexAttrib1fvARB) (GLuint index, GLfloat *v);
extern GLvoid (APIENTRYP qglVertexAttrib1svARB) (GLuint index, GLshort *v);
extern GLvoid (APIENTRYP qglVertexAttrib1dvARB) (GLuint index, GLdouble *v);
extern GLvoid (APIENTRYP qglVertexAttrib2fvARB) (GLuint index, GLfloat *v);
extern GLvoid (APIENTRYP qglVertexAttrib2svARB) (GLuint index, GLshort *v);
extern GLvoid (APIENTRYP qglVertexAttrib2dvARB) (GLuint index, GLdouble *v);
extern GLvoid (APIENTRYP qglVertexAttrib3fvARB) (GLuint index, GLfloat *v);
extern GLvoid (APIENTRYP qglVertexAttrib3svARB) (GLuint index, GLshort *v);
extern GLvoid (APIENTRYP qglVertexAttrib3dvARB) (GLuint index, GLdouble *v);
extern GLvoid (APIENTRYP qglVertexAttrib4fvARB) (GLuint index, GLfloat *v);
extern GLvoid (APIENTRYP qglVertexAttrib4svARB) (GLuint index, GLshort *v);
extern GLvoid (APIENTRYP qglVertexAttrib4dvARB) (GLuint index, GLdouble *v);
extern GLvoid (APIENTRYP qglVertexAttrib4ivARB) (GLuint index, GLint *v);
extern GLvoid (APIENTRYP qglVertexAttrib4bvARB) (GLuint index, GLbyte *v);
extern GLvoid (APIENTRYP qglVertexAttrib4ubvARB) (GLuint index, GLubyte *v);
extern GLvoid (APIENTRYP qglVertexAttrib4usvARB) (GLuint index, GLushort *v);
extern GLvoid (APIENTRYP qglVertexAttrib4uivARB) (GLuint index, GLuint *v);
extern GLvoid (APIENTRYP qglVertexAttrib4NbvARB) (GLuint index, const GLbyte *v);
extern GLvoid (APIENTRYP qglVertexAttrib4NsvARB) (GLuint index, const GLshort *v);
extern GLvoid (APIENTRYP qglVertexAttrib4NivARB) (GLuint index, const GLint *v);
extern GLvoid (APIENTRYP qglVertexAttrib4NubvARB) (GLuint index, const GLubyte *v);
extern GLvoid (APIENTRYP qglVertexAttrib4NusvARB) (GLuint index, const GLushort *v);
extern GLvoid (APIENTRYP qglVertexAttrib4NuivARB) (GLuint index, const GLuint *v);
extern GLvoid (APIENTRYP qglVertexAttribPointerARB) (GLuint index, GLint size, GLenum type, GLboolean normalized,
						     GLsizei stride, const GLvoid *pointer);
extern GLvoid (APIENTRYP qglEnableVertexAttribArrayARB) (GLuint index);
extern GLvoid (APIENTRYP qglDisableVertexAttribArrayARB) (GLuint index);
extern GLvoid (APIENTRYP qglBindAttribLocationARB) (GLhandleARB programObj, GLuint index, const GLcharARB *name);
extern GLvoid (APIENTRYP qglGetActiveAttribARB) (GLhandleARB programObj, GLuint index, GLsizei maxLength,
						 GLsizei *length, GLint *size, GLenum *type, GLcharARB *name);
extern GLint (APIENTRYP qglGetAttribLocationARB) (GLhandleARB programObj, const GLcharARB *name);
extern GLvoid (APIENTRYP qglGetVertexAttribdvARB) (GLuint index, GLenum pname, GLdouble *params);
extern GLvoid (APIENTRYP qglGetVertexAttribfvARB) (GLuint index, GLenum pname, GLfloat *params);
extern GLvoid (APIENTRYP qglGetVertexAttribivARB) (GLuint index, GLenum pname, GLint *params);
extern GLvoid (APIENTRYP qglGetVertexAttribPointervARB) (GLuint index, GLenum pname, GLvoid **pointer);

//===========================================================================

#define qglAccum QGL_DISPATCH_FN(Accum)
#define qglAlphaFunc QGL_DISPATCH_FN(AlphaFunc)
#define qglAreTexturesResident QGL_DISPATCH_FN(AreTexturesResident)
#define qglArrayElement QGL_DISPATCH_FN(ArrayElement)
#define qglBegin QGL_DISPATCH_FN(Begin)
#define qglBindTexture QGL_DISPATCH_FN(BindTexture)
#define qglBitmap QGL_DISPATCH_FN(Bitmap)
#define qglBlendFunc QGL_DISPATCH_FN(BlendFunc)
#define qglCallList QGL_DISPATCH_FN(CallList)
#define qglCallLists QGL_DISPATCH_FN(CallLists)
#define qglClear QGL_DISPATCH_FN(Clear)
#define qglClearAccum QGL_DISPATCH_FN(ClearAccum)
#define qglClearColor QGL_DISPATCH_FN(ClearColor)
#define qglClearDepth QGL_DISPATCH_FN(ClearDepth)
#define qglClearIndex QGL_DISPATCH_FN(ClearIndex)
#define qglClearStencil QGL_DISPATCH_FN(ClearStencil)
#define qglClipPlane QGL_DISPATCH_FN(ClipPlane)
#define qglColor3b QGL_DISPATCH_FN(Color3b)
#define qglColor3bv QGL_DISPATCH_FN(Color3bv)
#define qglColor3d QGL_DISPATCH_FN(Color3d)
#define qglColor3dv QGL_DISPATCH_FN(Color3dv)
#define qglColor3f QGL_DISPATCH_FN(Color3f)
#define qglColor3fv QGL_DISPATCH_FN(Color3fv)
#define qglColor3i QGL_DISPATCH_FN(Color3i)
#define qglColor3iv QGL_DISPATCH_FN(Color3iv)
#define qglColor3s QGL_DISPATCH_FN(Color3s)
#define qglColor3sv QGL_DISPATCH_FN(Color3sv)
#define qglColor3ub QGL_DISPATCH_FN(Color3ub)
#define qglColor3ubv QGL_DISPATCH_FN(Color3ubv)
#define qglColor3ui QGL_DISPATCH_FN(Color3ui)
#define qglColor3uiv QGL_DISPATCH_FN(Color3uiv)
#define qglColor3us QGL_DISPATCH_FN(Color3us)
#define qglColor3usv QGL_DISPATCH_FN(Color3usv)
#define qglColor4b QGL_DISPATCH_FN(Color4b)
#define qglColor4bv QGL_DISPATCH_FN(Color4bv)
#define qglColor4d QGL_DISPATCH_FN(Color4d)
#define qglColor4dv QGL_DISPATCH_FN(Color4dv)
#define qglColor4f QGL_DISPATCH_FN(Color4f)
#define qglColor4fv QGL_DISPATCH_FN(Color4fv)
#define qglColor4i QGL_DISPATCH_FN(Color4i)
#define qglColor4iv QGL_DISPATCH_FN(Color4iv)
#define qglColor4s QGL_DISPATCH_FN(Color4s)
#define qglColor4sv QGL_DISPATCH_FN(Color4sv)
#define qglColor4ub QGL_DISPATCH_FN(Color4ub)
#define qglColor4ubv QGL_DISPATCH_FN(Color4ubv)
#define qglColor4ui QGL_DISPATCH_FN(Color4ui)
#define qglColor4uiv QGL_DISPATCH_FN(Color4uiv)
#define qglColor4us QGL_DISPATCH_FN(Color4us)
#define qglColor4usv QGL_DISPATCH_FN(Color4usv)
#define qglColorMask QGL_DISPATCH_FN(ColorMask)
#define qglColorMaterial QGL_DISPATCH_FN(ColorMaterial)
#define qglColorPointer QGL_DISPATCH_FN(ColorPointer)
#define qglCopyPixels QGL_DISPATCH_FN(CopyPixels)
#define qglCopyTexImage1D QGL_DISPATCH_FN(CopyTexImage1D)
#define qglCopyTexImage2D QGL_DISPATCH_FN(CopyTexImage2D)
#define qglCopyTexSubImage1D QGL_DISPATCH_FN(CopyTexSubImage1D)
#define qglCopyTexSubImage2D QGL_DISPATCH_FN(CopyTexSubImage2D)
#define qglCullFace QGL_DISPATCH_FN(CullFace)
#define qglDeleteLists QGL_DISPATCH_FN(DeleteLists)
#define qglDeleteTextures QGL_DISPATCH_FN(DeleteTextures)
#define qglDepthFunc QGL_DISPATCH_FN(DepthFunc)
#define qglDepthMask QGL_DISPATCH_FN(DepthMask)
#define qglDepthRange QGL_DISPATCH_FN(DepthRange)
#define qglDisable QGL_DISPATCH_FN(Disable)
#define qglDisableClientState QGL_DISPATCH_FN(DisableClientState)
#define qglDrawArrays QGL_DISPATCH_FN(DrawArrays)
#define qglDrawBuffer QGL_DISPATCH_FN(DrawBuffer)
#define qglDrawElements QGL_DISPATCH_FN(DrawElements)
#define qglDrawPixels QGL_DISPATCH_FN(DrawPixels)
#define qglEdgeFlag QGL_DISPATCH_FN(EdgeFlag)
#define qglEdgeFlagPointer QGL_DISPATCH_FN(EdgeFlagPointer)
#define qglEdgeFlagv QGL_DISPATCH_FN(EdgeFlagv)
#define qglEnable QGL_DISPATCH_FN(Enable)
#define qglEnableClientState QGL_DISPATCH_FN(EnableClientState)
#define qglEnd QGL_DISPATCH_FN(End)
#define qglEndList QGL_DISPATCH_FN(EndList)
#define qglEvalCoord1d QGL_DISPATCH_FN(EvalCoord1d)
#define qglEvalCoord1dv QGL_DISPATCH_FN(EvalCoord1dv)
#define qglEvalCoord1f QGL_DISPATCH_FN(EvalCoord1f)
#define qglEvalCoord1fv QGL_DISPATCH_FN(EvalCoord1fv)
#define qglEvalCoord2d QGL_DISPATCH_FN(EvalCoord2d)
#define qglEvalCoord2dv QGL_DISPATCH_FN(EvalCoord2dv)
#define qglEvalCoord2f QGL_DISPATCH_FN(EvalCoord2f)
#define qglEvalCoord2fv QGL_DISPATCH_FN(EvalCoord2fv)
#define qglEvalMesh1 QGL_DISPATCH_FN(EvalMesh1)
#define qglEvalMesh2 QGL_DISPATCH_FN(EvalMesh2)
#define qglEvalPoint1 QGL_DISPATCH_FN(EvalPoint1)
#define qglEvalPoint2 QGL_DISPATCH_FN(EvalPoint2)
#define qglFeedbackBuffer QGL_DISPATCH_FN(FeedbackBuffer)
#define qglFinish QGL_DISPATCH_FN(Finish)
#define qglFlush QGL_DISPATCH_FN(Flush)
#define qglFogf QGL_DISPATCH_FN(Fogf)
#define qglFogfv QGL_DISPATCH_FN(Fogfv)
#define qglFogi QGL_DISPATCH_FN(Fogi)
#define qglFogiv QGL_DISPATCH_FN(Fogiv)
#define qglFrontFace QGL_DISPATCH_FN(FrontFace)
#define qglFrustum QGL_DISPATCH_FN(Frustum)
#define qglGenLists QGL_DISPATCH_FN(GenLists)
#define qglGenTextures QGL_DISPATCH_FN(GenTextures)
#define qglGetBooleanv QGL_DISPATCH_FN(GetBooleanv)
#define qglGetClipPlane QGL_DISPATCH_FN(GetClipPlane)
#define qglGetDoublev QGL_DISPATCH_FN(GetDoublev)
#define qglGetError QGL_DISPATCH_FN(GetError)
#define qglGetFloatv QGL_DISPATCH_FN(GetFloatv)
#define qglGetIntegerv QGL_DISPATCH_FN(GetIntegerv)
#define qglGetLightfv QGL_DISPATCH_FN(GetLightfv)
#define qglGetLightiv QGL_DISPATCH_FN(GetLightiv)
#define qglGetMapdv QGL_DISPATCH_FN(GetMapdv)
#define qglGetMapfv QGL_DISPATCH_FN(GetMapfv)
#define qglGetMapiv QGL_DISPATCH_FN(GetMapiv)
#define qglGetMaterialfv QGL_DISPATCH_FN(GetMaterialfv)
#define qglGetMaterialiv QGL_DISPATCH_FN(GetMaterialiv)
#define qglGetPixelMapfv QGL_DISPATCH_FN(GetPixelMapfv)
#define qglGetPixelMapuiv QGL_DISPATCH_FN(GetPixelMapuiv)
#define qglGetPixelMapusv QGL_DISPATCH_FN(GetPixelMapusv)
#define qglGetPointerv QGL_DISPATCH_FN(GetPointerv)
#define qglGetPolygonStipple QGL_DISPATCH_FN(GetPolygonStipple)
#define qglGetString QGL_DISPATCH_FN(GetString)
#define qglGetTexGendv QGL_DISPATCH_FN(GetTexGendv)
#define qglGetTexGenfv QGL_DISPATCH_FN(GetTexGenfv)
#define qglGetTexGeniv QGL_DISPATCH_FN(GetTexGeniv)
#define qglGetTexImage QGL_DISPATCH_FN(GetTexImage)
#define qglGetTexLevelParameterfv QGL_DISPATCH_FN(GetTexLevelParameterfv)
#define qglGetTexLevelParameteriv QGL_DISPATCH_FN(GetTexLevelParameteriv)
#define qglGetTexParameterfv QGL_DISPATCH_FN(GetTexParameterfv)
#define qglGetTexParameteriv QGL_DISPATCH_FN(GetTexParameteriv)
#define qglHint QGL_DISPATCH_FN(Hint)
#define qglIndexMask QGL_DISPATCH_FN(IndexMask)
#define qglIndexPointer QGL_DISPATCH_FN(IndexPointer)
#define qglIndexd QGL_DISPATCH_FN(Indexd)
#define qglIndexdv QGL_DISPATCH_FN(Indexdv)
#define qglIndexf QGL_DISPATCH_FN(Indexf)
#define qglIndexfv QGL_DISPATCH_FN(Indexfv)
#define qglIndexi QGL_DISPATCH_FN(Indexi)
#define qglIndexiv QGL_DISPATCH_FN(Indexiv)
#define qglIndexs QGL_DISPATCH_FN(Indexs)
#define qglIndexsv QGL_DISPATCH_FN(Indexsv)
#define qglIndexub QGL_DISPATCH_FN(Indexub)
#define qglIndexubv QGL_DISPATCH_FN(Indexubv)
#define qglInitNames QGL_DISPATCH_FN(InitNames)
#define qglInterleavedArrays QGL_DISPATCH_FN(InterleavedArrays)
#define qglIsEnabled QGL_DISPATCH_FN(IsEnabled)
#define qglIsList QGL_DISPATCH_FN(IsList)
#define qglIsTexture QGL_DISPATCH_FN(IsTexture)
#define qglLightModelf QGL_DISPATCH_FN(LightModelf)
#define qglLightModelfv QGL_DISPATCH_FN(LightModelfv)
#define qglLightModeli QGL_DISPATCH_FN(LightModeli)
#define qglLightModeliv QGL_DISPATCH_FN(LightModeliv)
#define qglLightf QGL_DISPATCH_FN(Lightf)
#define qglLightfv QGL_DISPATCH_FN(Lightfv)
#define qglLighti QGL_DISPATCH_FN(Lighti)
#define qglLightiv QGL_DISPATCH_FN(Lightiv)
#define qglLineStipple QGL_DISPATCH_FN(LineStipple)
#define qglLineWidth QGL_DISPATCH_FN(LineWidth)
#define qglListBase QGL_DISPATCH_FN(ListBase)
#define qglLoadIdentity QGL_DISPATCH_FN(LoadIdentity)
#define qglLoadMatrixd QGL_DISPATCH_FN(LoadMatrixd)
#define qglLoadMatrixf QGL_DISPATCH_FN(LoadMatrixf)
#define qglLoadName QGL_DISPATCH_FN(LoadName)
#define qglLogicOp QGL_DISPATCH_FN(LogicOp)
#define qglMap1d QGL_DISPATCH_FN(Map1d)
#define qglMap1f QGL_DISPATCH_FN(Map1f)
#define qglMap2d QGL_DISPATCH_FN(Map2d)
#define qglMap2f QGL_DISPATCH_FN(Map2f)
#define qglMapGrid1d QGL_DISPATCH_FN(MapGrid1d)
#define qglMapGrid1f QGL_DISPATCH_FN(MapGrid1f)
#define qglMapGrid2d QGL_DISPATCH_FN(MapGrid2d)
#define qglMapGrid2f QGL_DISPATCH_FN(MapGrid2f)
#define qglMaterialf QGL_DISPATCH_FN(Materialf)
#define qglMaterialfv QGL_DISPATCH_FN(Materialfv)
#define qglMateriali QGL_DISPATCH_FN(Materiali)
#define qglMaterialiv QGL_DISPATCH_FN(Materialiv)
#define qglMatrixMode QGL_DISPATCH_FN(MatrixMode)
#define qglMultMatrixd QGL_DISPATCH_FN(MultMatrixd)
#define qglMultMatrixf QGL_DISPATCH_FN(MultMatrixf)
#define qglNewList QGL_DISPATCH_FN(NewList)
#define qglNormal3b QGL_DISPATCH_FN(Normal3b)
#define qglNormal3bv QGL_DISPATCH_FN(Normal3bv)
#define qglNormal3d QGL_DISPATCH_FN(Normal3d)
#define qglNormal3dv QGL_DISPATCH_FN(Normal3dv)
#define qglNormal3f QGL_DISPATCH_FN(Normal3f)
#define qglNormal3fv QGL_DISPATCH_FN(Normal3fv)
#define qglNormal3i QGL_DISPATCH_FN(Normal3i)
#define qglNormal3iv QGL_DISPATCH_FN(Normal3iv)
#define qglNormal3s QGL_DISPATCH_FN(Normal3s)
#define qglNormal3sv QGL_DISPATCH_FN(Normal3sv)
#define qglNormalPointer QGL_DISPATCH_FN(NormalPointer)
#define qglOrtho QGL_DISPATCH_FN(Ortho)
#define qglPassThrough QGL_DISPATCH_FN(PassThrough)
#define qglPixelMapfv QGL_DISPATCH_FN(PixelMapfv)
#define qglPixelMapuiv QGL_DISPATCH_FN(PixelMapuiv)
#define qglPixelMapusv QGL_DISPATCH_FN(PixelMapusv)
#define qglPixelStoref QGL_DISPATCH_FN(PixelStoref)
#define qglPixelStorei QGL_DISPATCH_FN(PixelStorei)
#define qglPixelTransferf QGL_DISPATCH_FN(PixelTransferf)
#define qglPixelTransferi QGL_DISPATCH_FN(PixelTransferi)
#define qglPixelZoom QGL_DISPATCH_FN(PixelZoom)
#define qglPointSize QGL_DISPATCH_FN(PointSize)
#define qglPolygonMode QGL_DISPATCH_FN(PolygonMode)
#define qglPolygonOffset QGL_DISPATCH_FN(PolygonOffset)
#define qglPolygonStipple QGL_DISPATCH_FN(PolygonStipple)
#define qglPopAttrib QGL_DISPATCH_FN(PopAttrib)
#define qglPopClientAttrib QGL_DISPATCH_FN(PopClientAttrib)
#define qglPopMatrix QGL_DISPATCH_FN(PopMatrix)
#define qglPopName QGL_DISPATCH_FN(PopName)
#define qglPrioritizeTextures QGL_DISPATCH_FN(PrioritizeTextures)
#define qglPushAttrib QGL_DISPATCH_FN(PushAttrib)
#define qglPushClientAttrib QGL_DISPATCH_FN(PushClientAttrib)
#define qglPushMatrix QGL_DISPATCH_FN(PushMatrix)
#define qglPushName QGL_DISPATCH_FN(PushName)
#define qglRasterPos2d QGL_DISPATCH_FN(RasterPos2d)
#define qglRasterPos2dv QGL_DISPATCH_FN(RasterPos2dv)
#define qglRasterPos2f QGL_DISPATCH_FN(RasterPos2f)
#define qglRasterPos2fv QGL_DISPATCH_FN(RasterPos2fv)
#define qglRasterPos2i QGL_DISPATCH_FN(RasterPos2i)
#define qglRasterPos2iv QGL_DISPATCH_FN(RasterPos2iv)
#define qglRasterPos2s QGL_DISPATCH_FN(RasterPos2s)
#define qglRasterPos2sv QGL_DISPATCH_FN(RasterPos2sv)
#define qglRasterPos3d QGL_DISPATCH_FN(RasterPos3d)
#define qglRasterPos3dv QGL_DISPATCH_FN(RasterPos3dv)
#define qglRasterPos3f QGL_DISPATCH_FN(RasterPos3f)
#define qglRasterPos3fv QGL_DISPATCH_FN(RasterPos3fv)
#define qglRasterPos3i QGL_DISPATCH_FN(RasterPos3i)
#define qglRasterPos3iv QGL_DISPATCH_FN(RasterPos3iv)
#define qglRasterPos3s QGL_DISPATCH_FN(RasterPos3s)
#define qglRasterPos3sv QGL_DISPATCH_FN(RasterPos3sv)
#define qglRasterPos4d QGL_DISPATCH_FN(RasterPos4d)
#define qglRasterPos4dv QGL_DISPATCH_FN(RasterPos4dv)
#define qglRasterPos4f QGL_DISPATCH_FN(RasterPos4f)
#define qglRasterPos4fv QGL_DISPATCH_FN(RasterPos4fv)
#define qglRasterPos4i QGL_DISPATCH_FN(RasterPos4i)
#define qglRasterPos4iv QGL_DISPATCH_FN(RasterPos4iv)
#define qglRasterPos4s QGL_DISPATCH_FN(RasterPos4s)
#define qglRasterPos4sv QGL_DISPATCH_FN(RasterPos4sv)
#define qglReadBuffer QGL_DISPATCH_FN(ReadBuffer)
#define qglReadPixels QGL_DISPATCH_FN(ReadPixels)
#define qglRectd QGL_DISPATCH_FN(Rectd)
#define qglRectdv QGL_DISPATCH_FN(Rectdv)
#define qglRectf QGL_DISPATCH_FN(Rectf)
#define qglRectfv QGL_DISPATCH_FN(Rectfv)
#define qglRecti QGL_DISPATCH_FN(Recti)
#define qglRectiv QGL_DISPATCH_FN(Rectiv)
#define qglRects QGL_DISPATCH_FN(Rects)
#define qglRectsv QGL_DISPATCH_FN(Rectsv)
#define qglRenderMode QGL_DISPATCH_FN(RenderMode)
#define qglRotated QGL_DISPATCH_FN(Rotated)
#define qglRotatef QGL_DISPATCH_FN(Rotatef)
#define qglScaled QGL_DISPATCH_FN(Scaled)
#define qglScalef QGL_DISPATCH_FN(Scalef)
#define qglScissor QGL_DISPATCH_FN(Scissor)
#define qglSelectBuffer QGL_DISPATCH_FN(SelectBuffer)
#define qglShadeModel QGL_DISPATCH_FN(ShadeModel)
#define qglStencilFunc QGL_DISPATCH_FN(StencilFunc)
#define qglStencilMask QGL_DISPATCH_FN(StencilMask)
#define qglStencilOp QGL_DISPATCH_FN(StencilOp)
#define qglTexCoord1d QGL_DISPATCH_FN(TexCoord1d)
#define qglTexCoord1dv QGL_DISPATCH_FN(TexCoord1dv)
#define qglTexCoord1f QGL_DISPATCH_FN(TexCoord1f)
#define qglTexCoord1fv QGL_DISPATCH_FN(TexCoord1fv)
#define qglTexCoord1i QGL_DISPATCH_FN(TexCoord1i)
#define qglTexCoord1iv QGL_DISPATCH_FN(TexCoord1iv)
#define qglTexCoord1s QGL_DISPATCH_FN(TexCoord1s)
#define qglTexCoord1sv QGL_DISPATCH_FN(TexCoord1sv)
#define qglTexCoord2d QGL_DISPATCH_FN(TexCoord2d)
#define qglTexCoord2dv QGL_DISPATCH_FN(TexCoord2dv)
#define qglTexCoord2f QGL_DISPATCH_FN(TexCoord2f)
#define qglTexCoord2fv QGL_DISPATCH_FN(TexCoord2fv)
#define qglTexCoord2i QGL_DISPATCH_FN(TexCoord2i)
#define qglTexCoord2iv QGL_DISPATCH_FN(TexCoord2iv)
#define qglTexCoord2s QGL_DISPATCH_FN(TexCoord2s)
#define qglTexCoord2sv QGL_DISPATCH_FN(TexCoord2sv)
#define qglTexCoord3d QGL_DISPATCH_FN(TexCoord3d)
#define qglTexCoord3dv QGL_DISPATCH_FN(TexCoord3dv)
#define qglTexCoord3f QGL_DISPATCH_FN(TexCoord3f)
#define qglTexCoord3fv QGL_DISPATCH_FN(TexCoord3fv)
#define qglTexCoord3i QGL_DISPATCH_FN(TexCoord3i)
#define qglTexCoord3iv QGL_DISPATCH_FN(TexCoord3iv)
#define qglTexCoord3s QGL_DISPATCH_FN(TexCoord3s)
#define qglTexCoord3sv QGL_DISPATCH_FN(TexCoord3sv)
#define qglTexCoord4d QGL_DISPATCH_FN(TexCoord4d)
#define qglTexCoord4dv QGL_DISPATCH_FN(TexCoord4dv)
#define qglTexCoord4f QGL_DISPATCH_FN(TexCoord4f)
#define qglTexCoord4fv QGL_DISPATCH_FN(TexCoord4fv)
#define qglTexCoord4i QGL_DISPATCH_FN(TexCoord4i)
#define qglTexCoord4iv QGL_DISPATCH_FN(TexCoord4iv)
#define qglTexCoord4s QGL_DISPATCH_FN(TexCoord4s)
#define qglTexCoord4sv QGL_DISPATCH_FN(TexCoord4sv)
#define qglTexCoordPointer QGL_DISPATCH_FN(TexCoordPointer)
#define qglTexEnvf QGL_DISPATCH_FN(TexEnvf)
#define qglTexEnvfv QGL_DISPATCH_FN(TexEnvfv)
#define qglTexEnvi QGL_DISPATCH_FN(TexEnvi)
#define qglTexEnviv QGL_DISPATCH_FN(TexEnviv)
#define qglTexGend QGL_DISPATCH_FN(TexGend)
#define qglTexGendv QGL_DISPATCH_FN(TexGendv)
#define qglTexGenf QGL_DISPATCH_FN(TexGenf)
#define qglTexGenfv QGL_DISPATCH_FN(TexGenfv)
#define qglTexGeni QGL_DISPATCH_FN(TexGeni)
#define qglTexGeniv QGL_DISPATCH_FN(TexGeniv)
#define qglTexImage1D QGL_DISPATCH_FN(TexImage1D)
#define qglTexImage2D QGL_DISPATCH_FN(TexImage2D)
#define qglTexParameterf QGL_DISPATCH_FN(TexParameterf)
#define qglTexParameterfv QGL_DISPATCH_FN(TexParameterfv)
#define qglTexParameteri QGL_DISPATCH_FN(TexParameteri)
#define qglTexParameteriv QGL_DISPATCH_FN(TexParameteriv)
#define qglTexSubImage1D QGL_DISPATCH_FN(TexSubImage1D)
#define qglTexSubImage2D QGL_DISPATCH_FN(TexSubImage2D)
#define qglTranslated QGL_DISPATCH_FN(Translated)
#define qglTranslatef QGL_DISPATCH_FN(Translatef)
#define qglVertex2d QGL_DISPATCH_FN(Vertex2d)
#define qglVertex2dv QGL_DISPATCH_FN(Vertex2dv)
#define qglVertex2f QGL_DISPATCH_FN(Vertex2f)
#define qglVertex2fv QGL_DISPATCH_FN(Vertex2fv)
#define qglVertex2i QGL_DISPATCH_FN(Vertex2i)
#define qglVertex2iv QGL_DISPATCH_FN(Vertex2iv)
#define qglVertex2s QGL_DISPATCH_FN(Vertex2s)
#define qglVertex2sv QGL_DISPATCH_FN(Vertex2sv)
#define qglVertex3d QGL_DISPATCH_FN(Vertex3d)
#define qglVertex3dv QGL_DISPATCH_FN(Vertex3dv)
#define qglVertex3f QGL_DISPATCH_FN(Vertex3f)
#define qglVertex3fv QGL_DISPATCH_FN(Vertex3fv)
#define qglVertex3i QGL_DISPATCH_FN(Vertex3i)
#define qglVertex3iv QGL_DISPATCH_FN(Vertex3iv)
#define qglVertex3s QGL_DISPATCH_FN(Vertex3s)
#define qglVertex3sv QGL_DISPATCH_FN(Vertex3sv)
#define qglVertex4d QGL_DISPATCH_FN(Vertex4d)
#define qglVertex4dv QGL_DISPATCH_FN(Vertex4dv)
#define qglVertex4f QGL_DISPATCH_FN(Vertex4f)
#define qglVertex4fv QGL_DISPATCH_FN(Vertex4fv)
#define qglVertex4i QGL_DISPATCH_FN(Vertex4i)
#define qglVertex4iv QGL_DISPATCH_FN(Vertex4iv)
#define qglVertex4s QGL_DISPATCH_FN(Vertex4s)
#define qglVertex4sv QGL_DISPATCH_FN(Vertex4sv)
#define qglVertexPointer QGL_DISPATCH_FN(VertexPointer)
#define qglViewport QGL_DISPATCH_FN(Viewport)
#endif
