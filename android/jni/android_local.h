#ifndef ZEQ2_ANDROID_LOCAL_H
#define ZEQ2_ANDROID_LOCAL_H

#include <android_native_app_glue.h>

/* Set by android_main before the engine starts. */
extern struct android_app *sys_androidApp;

/* Install NativeActivity callbacks and pump its looper from the engine loop. */
void Android_InstallCallbacks( void );
void Android_PumpEvents( void );
void Android_RequestExit( void );
void Android_ExitEngine( void );
qboolean Android_IsDestroyed( void );

#endif /* ZEQ2_ANDROID_LOCAL_H */
