/*
 * ZEQ2-Lite touch controls.
 *
 * Platform independent virtual buttons/sticks.  The Android front end feeds
 * normalized pointer coordinates in and the renderer draws the current layout
 * at the end of each frame.  Key presses are injected through Com_QueueEvent
 * so the normal Quake III input/binding path handles them unchanged.
 */

#ifndef TOUCH_H
#define TOUCH_H

#include "../../Shared/q_shared.h"

#define TOUCH_MAX_CONTROLS 24
#define TOUCH_MAX_KEYS 5
#define TOUCH_MAX_KEYNAME 32

typedef enum {
	TOUCH_BUTTON = 0,
	TOUCH_STICK
} touchControlType_t;

typedef struct {
	touchControlType_t type;

	/* Normalized 0..1 rectangle relative to the render surface. */
	float x, y, w, h;

	/* Button: keys[0].  Stick: up, down, left, right, extra ("LOOK"). */
	char keys[TOUCH_MAX_KEYS][TOUCH_MAX_KEYNAME];

	/* Runtime state. */
	int pointer;
	float stickX, stickY;
	int activeKey;
} touchControl_t;

typedef struct {
	touchControl_t controls[TOUCH_MAX_CONTROLS];
	int count;
	int selected;
	qboolean editor;
	qboolean resizeMode;
	qboolean bindMode;
} touchLayout_t;

/* Immutable copy handed to the renderer command buffer. */
typedef struct {
	touchLayout_t layout;
	float alpha;
} touchOverlay_t;

void Touch_Init( void );
void Touch_Shutdown( void );
void Touch_Frame( void );
void Touch_DefaultLayout( void );

qboolean Touch_PointerDown( int pointer, float x, float y, int time );
void Touch_PointerMove( int pointer, float x, float y );
void Touch_PointerUp( int pointer, float x, float y, int time );
void Touch_PointerCancelAll( void );

void Touch_DrawOverlay( void );
qboolean Touch_OverlayActive( void );
void Touch_SnapshotOverlay( touchOverlay_t *overlay );
void Touch_DrawOverlaySnapshot( const touchOverlay_t *overlay );
touchLayout_t *Touch_GetLayout( void );

#endif /* TOUCH_H */
