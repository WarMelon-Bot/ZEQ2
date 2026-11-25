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

#define QGL_INIT_GL(name) qgl_dispatch_table[QGLFN_##name].object = (void *)(gl##name);
#define QGL_INIT_STUB(name) qgl_dispatch_table[QGLFN_##name].object = (void *)QGL_UnsupportedCall;
#define QGL_CLEAR_ARB(name) name = NULL;

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
