/*
 * Android NativeActivity input for ZEQ2-Lite.
 *
 * Touch pointers feed the shared virtual controls.  Hardware keyboards and
 * mice feed the normal engine key/mouse event queue.
 */

#include "../../Engine/renderer/tr_local.h"
#include "../../Engine/client/client.h"
#include "../../Engine/client/keycodes.h"
#include "../../Engine/client/touch.h"
#include "../../Engine/sys/sys_local.h"
#include "android_local.h"

#include <android/input.h>
#include <android/keycodes.h>
#include <android/log.h>
#include <android/native_activity.h>
#include <android/native_window.h>

#define ANDROID_INPUT_LOG_TAG "ZEQ2-IN"
#define MAX_ANDROID_POINTERS 10

struct android_app *sys_androidApp = NULL;

static qboolean androidDestroyed = qfalse;
static qboolean androidInputReady = qfalse;
static qboolean softInputVisible = qfalse;
static int pointerIds[ MAX_ANDROID_POINTERS ];
static float pointerLastX[ MAX_ANDROID_POINTERS ];
static float pointerLastY[ MAX_ANDROID_POINTERS ];

static qboolean mouseValid = qfalse;
static float mouseLastX = 0.0f;
static float mouseLastY = 0.0f;

static void Android_Keyboard_f( void )
{
	if ( !sys_androidApp || !sys_androidApp->activity ) {
		return;
	}
	if ( softInputVisible ) {
		ANativeActivity_hideSoftInput( sys_androidApp->activity, 0 );
		softInputVisible = qfalse;
	} else {
		ANativeActivity_showSoftInput( sys_androidApp->activity,
			ANATIVEACTIVITY_SHOW_SOFT_INPUT_IMPLICIT );
		softInputVisible = qtrue;
	}
}

qboolean Android_IsDestroyed( void )
{
	return androidDestroyed;
}

void Android_RequestExit( void )
{
	androidDestroyed = qtrue;
	if ( sys_androidApp && sys_androidApp->activity ) {
		ANativeActivity_finish( sys_androidApp->activity );
	}
}

void Android_ExitEngine( void )
{
	Android_RequestExit();
	Cbuf_ExecuteText( EXEC_NOW, "quit\n" );
}

void Android_PumpEvents( void )
{
	int events;
	int fd;
	void *data;

	if ( !sys_androidApp || !sys_androidApp->looper ) {
		return;
	}

	/* native_app_glue dispatches onAppCmd/onInputEvent from the looper. */
	while ( ALooper_pollOnce( 0, &fd, &events, &data ) >= 0 ) {
		if ( androidDestroyed ) {
			break;
		}
	}
}

static void Android_OnAppCmd( struct android_app *app, int32_t cmd )
{
	(void)app;

	switch ( cmd ) {
	case APP_CMD_INIT_WINDOW:
		/* Looper events are pumped during startup, before the engine's
		 * console exists, so log directly instead of using Com_Printf. */
		__android_log_print( ANDROID_LOG_INFO, ANDROID_INPUT_LOG_TAG,
			"Android window created" );
		break;
	case APP_CMD_TERM_WINDOW:
		__android_log_print( ANDROID_LOG_INFO, ANDROID_INPUT_LOG_TAG,
			"Android window destroyed" );
		Touch_PointerCancelAll();
		break;
	case APP_CMD_PAUSE:
		Touch_PointerCancelAll();
		break;
	case APP_CMD_DESTROY:
		androidDestroyed = qtrue;
		break;
	case APP_CMD_LOST_FOCUS:
		Touch_PointerCancelAll();
		break;
	default:
		break;
	}
}

/*
=================
Android_KeyForAndroidCode
=================
*/
static int Android_KeyForAndroidCode( int32_t code )
{
	if ( code >= AKEYCODE_A && code <= AKEYCODE_Z ) {
		return 'a' + ( code - AKEYCODE_A );
	}
	if ( code >= AKEYCODE_0 && code <= AKEYCODE_9 ) {
		return '0' + ( code - AKEYCODE_0 );
	}

	switch ( code ) {
	case AKEYCODE_BACK: return K_ESCAPE;
	case AKEYCODE_MENU: return K_F1;
	case AKEYCODE_HOME: return K_HOME;
	case AKEYCODE_SOFT_LEFT: return K_F2;
	case AKEYCODE_SOFT_RIGHT: return K_F3;
	case AKEYCODE_CALL: return K_F4;
	case AKEYCODE_ENDCALL: return K_F5;
	case AKEYCODE_DPAD_UP: return K_UPARROW;
	case AKEYCODE_DPAD_DOWN: return K_DOWNARROW;
	case AKEYCODE_DPAD_LEFT: return K_LEFTARROW;
	case AKEYCODE_DPAD_RIGHT: return K_RIGHTARROW;
	case AKEYCODE_DPAD_CENTER: return K_ENTER;
	case AKEYCODE_VOLUME_UP: return '+';
	case AKEYCODE_VOLUME_DOWN: return '-';
	case AKEYCODE_POWER: return K_POWER;
	case AKEYCODE_CAMERA: return K_F6;
	case AKEYCODE_CLEAR: return K_DEL;
	case AKEYCODE_COMMA: return ',';
	case AKEYCODE_PERIOD: return '.';
	case AKEYCODE_TAB: return K_TAB;
	case AKEYCODE_SPACE: return K_SPACE;
	case AKEYCODE_ENTER: return K_ENTER;
	case AKEYCODE_DEL: return K_BACKSPACE;
	case AKEYCODE_GRAVE: return '`';
	case AKEYCODE_MINUS: return '-';
	case AKEYCODE_EQUALS: return '=';
	case AKEYCODE_LEFT_BRACKET: return '[';
	case AKEYCODE_RIGHT_BRACKET: return ']';
	case AKEYCODE_BACKSLASH: return '\\';
	case AKEYCODE_SEMICOLON: return ';';
	case AKEYCODE_APOSTROPHE: return '\'';
	case AKEYCODE_SLASH: return '/';
	case AKEYCODE_AT: return '@';
	case AKEYCODE_PLUS: return '+';
	case AKEYCODE_CTRL_LEFT:
	case AKEYCODE_CTRL_RIGHT: return K_CTRL;
	case AKEYCODE_SHIFT_LEFT:
	case AKEYCODE_SHIFT_RIGHT: return K_SHIFT;
	case AKEYCODE_ALT_LEFT:
	case AKEYCODE_ALT_RIGHT: return K_ALT;
	case AKEYCODE_F1: return K_F1;
	case AKEYCODE_F2: return K_F2;
	case AKEYCODE_F3: return K_F3;
	case AKEYCODE_F4: return K_F4;
	case AKEYCODE_F5: return K_F5;
	case AKEYCODE_F6: return K_F6;
	case AKEYCODE_F7: return K_F7;
	case AKEYCODE_F8: return K_F8;
	case AKEYCODE_F9: return K_F9;
	case AKEYCODE_F10: return K_F10;
	case AKEYCODE_F11: return K_F11;
	case AKEYCODE_F12: return K_F12;
	case AKEYCODE_ESCAPE: return K_ESCAPE;
	case AKEYCODE_INSERT: return K_INS;
	case AKEYCODE_MOVE_END: return K_END;
	case AKEYCODE_MOVE_HOME: return K_HOME;
	case AKEYCODE_PAGE_UP: return K_PGUP;
	case AKEYCODE_PAGE_DOWN: return K_PGDN;
	case AKEYCODE_FORWARD_DEL: return K_DEL;
	default: return -1;
	}
}

static int32_t Android_OnKeyEvent( AInputEvent *event )
{
	int32_t action = AKeyEvent_getAction( event );
	int32_t code = AKeyEvent_getKeyCode( event );
	int key;
	int time = Sys_Milliseconds();

	key = Android_KeyForAndroidCode( code );
	if ( key < 0 ) {
		return 0;
	}

	if ( action == AKEY_EVENT_ACTION_DOWN ) {
		if ( AKeyEvent_getRepeatCount( event ) == 0 ) {
			Com_QueueEvent( time, SE_KEY, key, 1, 0, NULL );
			if ( key >= 'a' && key <= 'z' ) {
				Com_QueueEvent( time, SE_CHAR, key, 0, 0, NULL );
			}
		}
		return 1;
	}
	if ( action == AKEY_EVENT_ACTION_UP ) {
		Com_QueueEvent( time, SE_KEY, key, 0, 0, NULL );
		return 1;
	}

	return 0;
}

static int Android_PointerSlot( int32_t id, qboolean create )
{
	int i;

	for ( i = 0; i < MAX_ANDROID_POINTERS; i++ ) {
		if ( pointerIds[i] == id ) {
			return i;
		}
	}
	if ( !create ) {
		return -1;
	}
	for ( i = 0; i < MAX_ANDROID_POINTERS; i++ ) {
		if ( pointerIds[i] < 0 ) {
			pointerIds[i] = id;
			return i;
		}
	}
	return -1;
}

static void Android_Normalize( struct android_app *app, float x, float y,
	float *nx, float *ny )
{
	int width = glConfig.vidWidth;
	int height = glConfig.vidHeight;

	if ( width < 1 && app && app->window ) {
		width = ANativeWindow_getWidth( app->window );
	}
	if ( height < 1 && app && app->window ) {
		height = ANativeWindow_getHeight( app->window );
	}
	if ( width < 1 ) width = 1;
	if ( height < 1 ) height = 1;

	*nx = x / (float)width;
	*ny = y / (float)height;
}

static int32_t Android_OnMotionEvent( struct android_app *app, AInputEvent *event )
{
	int32_t action = AMotionEvent_getAction( event ) & AMOTION_EVENT_ACTION_MASK;
	int32_t actionIndex = ( AMotionEvent_getAction( event ) & AMOTION_EVENT_ACTION_POINTER_INDEX_MASK )
		>> AMOTION_EVENT_ACTION_POINTER_INDEX_SHIFT;
	int32_t source = AInputEvent_getSource( event );
	size_t count = AMotionEvent_getPointerCount( event );
	size_t i;
	int time = Sys_Milliseconds();
	qboolean isMouse = source & AINPUT_SOURCE_MOUSE;

	if ( isMouse ) {
		float x = AMotionEvent_getX( event, 0 );
		float y = AMotionEvent_getY( event, 0 );
		int buttons = AMotionEvent_getButtonState( event );

		if ( mouseValid ) {
			int dx = (int)( x - mouseLastX );
			int dy = (int)( y - mouseLastY );
			if ( dx || dy ) {
				Com_QueueEvent( time, SE_MOUSE, dx, dy, 0, NULL );
			}
		}
		mouseValid = qtrue;
		mouseLastX = x;
		mouseLastY = y;

		if ( action == AMOTION_EVENT_ACTION_DOWN ||
			action == AMOTION_EVENT_ACTION_UP ) {
			int key = -1;
			if ( buttons & AMOTION_EVENT_BUTTON_PRIMARY ) key = K_MOUSE1;
			else if ( buttons & AMOTION_EVENT_BUTTON_SECONDARY ) key = K_MOUSE2;
			else if ( buttons & AMOTION_EVENT_BUTTON_TERTIARY ) key = K_MOUSE3;
			if ( key >= 0 ) {
				Com_QueueEvent( time, SE_KEY, key,
					action == AMOTION_EVENT_ACTION_DOWN ? 1 : 0, 0, NULL );
			}
		}
		return 1;
	}

	if ( action == AMOTION_EVENT_ACTION_DOWN ||
		action == AMOTION_EVENT_ACTION_POINTER_DOWN ) {
		int32_t id = AMotionEvent_getPointerId( event, actionIndex );
		int slot = Android_PointerSlot( id, qtrue );
		float nx, ny;

		if ( slot >= 0 ) {
			Android_Normalize( app, AMotionEvent_getX( event, actionIndex ),
				AMotionEvent_getY( event, actionIndex ), &nx, &ny );
			pointerLastX[slot] = nx;
			pointerLastY[slot] = ny;
			Touch_PointerDown( slot, nx, ny, time );
		}
		return 1;
	}

	if ( action == AMOTION_EVENT_ACTION_MOVE ) {
		for ( i = 0; i < count; i++ ) {
			int32_t id = AMotionEvent_getPointerId( event, i );
			int slot = Android_PointerSlot( id, qfalse );
			float nx, ny;

			if ( slot < 0 ) {
				continue;
			}
			Android_Normalize( app, AMotionEvent_getX( event, i ),
				AMotionEvent_getY( event, i ), &nx, &ny );
			pointerLastX[slot] = nx;
			pointerLastY[slot] = ny;
			Touch_PointerMove( slot, nx, ny );
		}
		return 1;
	}

	if ( action == AMOTION_EVENT_ACTION_UP ||
		action == AMOTION_EVENT_ACTION_POINTER_UP ) {
		int32_t id = AMotionEvent_getPointerId( event, actionIndex );
		int slot = Android_PointerSlot( id, qfalse );
		float nx = pointerLastX[slot >= 0 ? slot : 0];
		float ny = pointerLastY[slot >= 0 ? slot : 0];

		if ( slot >= 0 ) {
			Android_Normalize( app, AMotionEvent_getX( event, actionIndex ),
				AMotionEvent_getY( event, actionIndex ), &nx, &ny );
			Touch_PointerUp( slot, nx, ny, time );
			pointerIds[slot] = -1;
		}
		return 1;
	}

	if ( action == AMOTION_EVENT_ACTION_CANCEL ) {
		int slot;
		Touch_PointerCancelAll();
		for ( slot = 0; slot < MAX_ANDROID_POINTERS; slot++ ) {
			pointerIds[slot] = -1;
		}
		return 1;
	}

	return 0;
}

static int32_t Android_OnInputEvent( struct android_app *app, AInputEvent *event )
{
	/* Startup pumps looper events while assets are extracted and while the
	 * EGL surface is being created.  The engine's event queue and touch layer
	 * do not exist yet, so drop input until IN_Init has run. */
	if ( !event || !androidInputReady ) {
		return 0;
	}

	switch ( AInputEvent_getType( event ) ) {
	case AINPUT_EVENT_TYPE_KEY:
		return Android_OnKeyEvent( event );
	case AINPUT_EVENT_TYPE_MOTION:
		return Android_OnMotionEvent( app, event );
	default:
		return 0;
	}
}

void Android_InstallCallbacks( void )
{
	int i;

	for ( i = 0; i < MAX_ANDROID_POINTERS; i++ ) {
		pointerIds[i] = -1;
	}

	if ( sys_androidApp ) {
		sys_androidApp->onAppCmd = Android_OnAppCmd;
		sys_androidApp->onInputEvent = Android_OnInputEvent;
	}
}

/*
=================
Input subsystem entry points used by sys_main.c
=================
*/
void IN_Init( void )
{
	androidInputReady = qtrue;
	Cmd_AddCommand( "android_keyboard", Android_Keyboard_f );
}

void IN_Frame( void )
{
	Android_PumpEvents();
	if ( androidDestroyed ) {
		Android_ExitEngine();
	}
}

void IN_Shutdown( void )
{
	androidInputReady = qfalse;
	Touch_PointerCancelAll();
	if ( softInputVisible && sys_androidApp && sys_androidApp->activity ) {
		ANativeActivity_hideSoftInput( sys_androidApp->activity, 0 );
		softInputVisible = qfalse;
	}
}

void IN_Restart( void )
{
}

void Sys_SendKeyEvents( void )
{
	Android_PumpEvents();
}
