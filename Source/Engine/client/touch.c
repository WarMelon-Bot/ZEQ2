/*
===========================================================================
ZEQ2-Lite virtual touch controls and layout editor.

The controls are deliberately kept in the engine (not in a game VM) so that
they work in every game directory, including the main menu and the cgame.
===========================================================================
*/

#include "client.h"
#include "../renderer/tr_local.h"
#include "touch.h"

#include <ctype.h>
#include <math.h>

#define TOUCH_LAYOUT_FILE "touch_layout.cfg"

static float Touch_ClampFloat( float value, float min, float max )
{
	if ( value < min ) return min;
	if ( value > max ) return max;
	return value;
}

static float Touch_MaxFloat( float a, float b ) { return a > b ? a : b; }
static float Touch_MinFloat( float a, float b ) { return a < b ? a : b; }

/* A tiny 5x7 bitmap font used by the in-game layout editor. */
static const unsigned char touchFont[ ][7] = {
	/* A */ { 0x0e, 0x11, 0x11, 0x1f, 0x11, 0x11, 0x11 },
	/* B */ { 0x1e, 0x11, 0x11, 0x1e, 0x11, 0x11, 0x1e },
	/* C */ { 0x0e, 0x11, 0x10, 0x10, 0x10, 0x11, 0x0e },
	/* D */ { 0x1e, 0x11, 0x11, 0x11, 0x11, 0x11, 0x1e },
	/* E */ { 0x1f, 0x10, 0x10, 0x1e, 0x10, 0x10, 0x1f },
	/* F */ { 0x1f, 0x10, 0x10, 0x1e, 0x10, 0x10, 0x10 },
	/* G */ { 0x0e, 0x11, 0x10, 0x17, 0x11, 0x11, 0x0e },
	/* H */ { 0x11, 0x11, 0x11, 0x1f, 0x11, 0x11, 0x11 },
	/* I */ { 0x0e, 0x04, 0x04, 0x04, 0x04, 0x04, 0x0e },
	/* J */ { 0x07, 0x02, 0x02, 0x02, 0x12, 0x12, 0x0c },
	/* K */ { 0x11, 0x12, 0x14, 0x18, 0x14, 0x12, 0x11 },
	/* L */ { 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x1f },
	/* M */ { 0x11, 0x1b, 0x15, 0x15, 0x11, 0x11, 0x11 },
	/* N */ { 0x11, 0x19, 0x15, 0x13, 0x11, 0x11, 0x11 },
	/* O */ { 0x0e, 0x11, 0x11, 0x11, 0x11, 0x11, 0x0e },
	/* P */ { 0x1e, 0x11, 0x11, 0x1e, 0x10, 0x10, 0x10 },
	/* Q */ { 0x0e, 0x11, 0x11, 0x11, 0x15, 0x12, 0x0d },
	/* R */ { 0x1e, 0x11, 0x11, 0x1e, 0x14, 0x12, 0x11 },
	/* S */ { 0x0f, 0x10, 0x10, 0x0e, 0x01, 0x01, 0x1e },
	/* T */ { 0x1f, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04 },
	/* U */ { 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x0e },
	/* V */ { 0x11, 0x11, 0x11, 0x11, 0x11, 0x0a, 0x04 },
	/* W */ { 0x11, 0x11, 0x11, 0x15, 0x15, 0x1b, 0x11 },
	/* X */ { 0x11, 0x11, 0x0a, 0x04, 0x0a, 0x11, 0x11 },
	/* Y */ { 0x11, 0x11, 0x0a, 0x04, 0x04, 0x04, 0x04 },
	/* Z */ { 0x1f, 0x01, 0x02, 0x04, 0x08, 0x10, 0x1f },
	/* 0 */ { 0x0e, 0x11, 0x13, 0x15, 0x19, 0x11, 0x0e },
	/* 1 */ { 0x04, 0x0c, 0x04, 0x04, 0x04, 0x04, 0x0e },
	/* 2 */ { 0x0e, 0x11, 0x01, 0x02, 0x04, 0x08, 0x1f },
	/* 3 */ { 0x1e, 0x01, 0x01, 0x0e, 0x01, 0x01, 0x1e },
	/* 4 */ { 0x02, 0x06, 0x0a, 0x12, 0x1f, 0x02, 0x02 },
	/* 5 */ { 0x1f, 0x10, 0x10, 0x1e, 0x01, 0x01, 0x1e },
	/* 6 */ { 0x0e, 0x10, 0x10, 0x1e, 0x11, 0x11, 0x0e },
	/* 7 */ { 0x1f, 0x01, 0x02, 0x04, 0x08, 0x08, 0x08 },
	/* 8 */ { 0x0e, 0x11, 0x11, 0x0e, 0x11, 0x11, 0x0e },
	/* 9 */ { 0x0e, 0x11, 0x11, 0x0f, 0x01, 0x01, 0x0e },
	/* space */ { 0, 0, 0, 0, 0, 0, 0 },
	/* - */ { 0x00, 0x00, 0x00, 0x1f, 0x00, 0x00, 0x00 },
	/* + */ { 0x00, 0x04, 0x04, 0x1f, 0x04, 0x04, 0x00 },
	/* > */ { 0x10, 0x08, 0x04, 0x02, 0x04, 0x08, 0x10 },
	/* : */ { 0x00, 0x04, 0x04, 0x00, 0x04, 0x04, 0x00 },
	/* . */ { 0x00, 0x00, 0x00, 0x00, 0x00, 0x0c, 0x0c }
};

static const int touchFontCount = sizeof( touchFont ) / sizeof( touchFont[0] );
static const char touchFontChars[] =
	"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -+>:.";

static touchLayout_t touchLayout;
static qboolean touchInitialized = qfalse;
static cvar_t *touch_enable;
static cvar_t *touch_opacity;
static cvar_t *touch_lookSensitivity;
static cvar_t *touch_editorResize;

typedef struct {
	int toolbarAction;
	int control;
	float startX, startY;
	float lastX, lastY;
} touchDrag_t;

static touchDrag_t touchDrag[ 10 ];

static void Touch_DrawRect( float x, float y, float w, float h,
							float r, float g, float b, float a )
{
	qglColor4f( r, g, b, a );
	qglBegin( GL_QUADS );
	qglVertex2f( x, y );
	qglVertex2f( x + w, y );
	qglVertex2f( x + w, y + h );
	qglVertex2f( x, y + h );
	qglEnd();
}

static void Touch_DrawRing( float cx, float cy, float radius,
							float r, float g, float b, float a )
{
	static const int segments = 12;
	int i;

	qglColor4f( r, g, b, a );
	qglBegin( GL_QUADS );
	for ( i = 0; i < segments; i++ ) {
		float a1 = (float)i * ( 2.0f * M_PI ) / segments;
		float a2 = (float)( i + 1 ) * ( 2.0f * M_PI ) / segments;
		float x1 = cx + cosf( a1 ) * radius;
		float y1 = cy + sinf( a1 ) * radius;
		float x2 = cx + cosf( a2 ) * radius;
		float y2 = cy + sinf( a2 ) * radius;
		qglVertex2f( x1, y1 );
		qglVertex2f( x2, y2 );
		qglVertex2f( x2, y2 + 2.0f );
		qglVertex2f( x1, y1 + 2.0f );
	}
	qglEnd();
}

static void Touch_DrawText( const char *text, float x, float y, float size,
							float r, float g, float b, float a )
{
	const unsigned char *glyph;
	int i, j, k;

	if ( !text || !*text ) {
		return;
	}

	qglColor4f( r, g, b, a );
	qglBegin( GL_QUADS );
	while ( *text ) {
		int index = 0;
		char c = (char)toupper( (unsigned char)*text );

		for ( i = 0; i < touchFontCount; i++ ) {
			if ( touchFontChars[ i ] == c ) {
				index = i;
				break;
			}
		}
		glyph = touchFont[ index ];

		for ( j = 0; j < 7; j++ ) {
			for ( k = 0; k < 5; k++ ) {
				if ( glyph[ j ] & ( 1 << ( 4 - k ) ) ) {
					float px = x + ( k * size );
					float py = y + ( j * size );
					qglVertex2f( px, py );
					qglVertex2f( px + size, py );
					qglVertex2f( px + size, py + size );
					qglVertex2f( px, py + size );
				}
			}
		}

		x += size * 6;
		text++;
	}
	qglEnd();
}

static int Touch_FontIndex( char c )
{
	int i;
	c = (char)toupper( (unsigned char)c );
	for ( i = 0; i < touchFontCount; i++ ) {
		if ( touchFontChars[ i ] == c ) {
			return i;
		}
	}
	return touchFontCount - 1; /* space */
}

/*
=================
Touch_DefaultLayout
=================
*/
void Touch_DefaultLayout( void )
{
	int i;

	Com_Memset( &touchLayout, 0, sizeof( touchLayout ) );

	/* Left thumb movement stick.  These match the game's default controls
	 * (arrows for forward/back and comma/period for strafing). */
	i = touchLayout.count++;
	Q_strncpyz( touchLayout.controls[i].keys[0], "UPARROW", TOUCH_MAX_KEYNAME );
	Q_strncpyz( touchLayout.controls[i].keys[1], "DOWNARROW", TOUCH_MAX_KEYNAME );
	Q_strncpyz( touchLayout.controls[i].keys[2], ",", TOUCH_MAX_KEYNAME );
	Q_strncpyz( touchLayout.controls[i].keys[3], ".", TOUCH_MAX_KEYNAME );
	touchLayout.controls[i].type = TOUCH_STICK;
	touchLayout.controls[i].x = 0.035f;
	touchLayout.controls[i].y = 0.50f;
	touchLayout.controls[i].w = 0.34f;
	touchLayout.controls[i].h = 0.44f;

	/* Right thumb look stick. */
	i = touchLayout.count++;
	Q_strncpyz( touchLayout.controls[i].keys[0], "LOOK", TOUCH_MAX_KEYNAME );
	touchLayout.controls[i].type = TOUCH_STICK;
	touchLayout.controls[i].x = 0.625f;
	touchLayout.controls[i].y = 0.50f;
	touchLayout.controls[i].w = 0.34f;
	touchLayout.controls[i].h = 0.44f;

	/* Attack. */
	i = touchLayout.count++;
	Q_strncpyz( touchLayout.controls[i].keys[0], "MOUSE1", TOUCH_MAX_KEYNAME );
	touchLayout.controls[i].type = TOUCH_BUTTON;
	touchLayout.controls[i].x = 0.79f;
	touchLayout.controls[i].y = 0.78f;
	touchLayout.controls[i].w = 0.17f;
	touchLayout.controls[i].h = 0.17f;

	/* Jump. */
	i = touchLayout.count++;
	Q_strncpyz( touchLayout.controls[i].keys[0], "SPACE", TOUCH_MAX_KEYNAME );
	touchLayout.controls[i].type = TOUCH_BUTTON;
	touchLayout.controls[i].x = 0.60f;
	touchLayout.controls[i].y = 0.82f;
	touchLayout.controls[i].w = 0.15f;
	touchLayout.controls[i].h = 0.15f;

	/* Alternate attack. */
	i = touchLayout.count++;
	Q_strncpyz( touchLayout.controls[i].keys[0], "MOUSE2", TOUCH_MAX_KEYNAME );
	touchLayout.controls[i].type = TOUCH_BUTTON;
	touchLayout.controls[i].x = 0.83f;
	touchLayout.controls[i].y = 0.59f;
	touchLayout.controls[i].w = 0.14f;
	touchLayout.controls[i].h = 0.14f;

	/* Sprint / usable action. */
	i = touchLayout.count++;
	Q_strncpyz( touchLayout.controls[i].keys[0], "SHIFT", TOUCH_MAX_KEYNAME );
	touchLayout.controls[i].type = TOUCH_BUTTON;
	touchLayout.controls[i].x = 0.64f;
	touchLayout.controls[i].y = 0.65f;
	touchLayout.controls[i].w = 0.13f;
	touchLayout.controls[i].h = 0.13f;
}

/*
=================
Touch_SaveLayout_f / Touch_LoadLayout_f
=================
*/
static void Touch_SaveLayout( void )
{
	fileHandle_t f;
	char buffer[ 4096 ];
	int len = 0;
	int i, j;
	const char *p;

	f = FS_FOpenFileWrite( TOUCH_LAYOUT_FILE );
	if ( !f ) {
		Com_Printf( S_COLOR_YELLOW "Could not write %s\n", TOUCH_LAYOUT_FILE );
		return;
	}

	len = Q_snprintf( buffer, sizeof( buffer ), "version 1\n" );
	for ( i = 0; i < touchLayout.count; i++ ) {
		touchControl_t *c = &touchLayout.controls[i];
		len += Q_snprintf( buffer + len, sizeof( buffer ) - len,
			"%s %.5f %.5f %.5f %.5f",
			c->type == TOUCH_STICK ? "stick" : "button",
			c->x, c->y, c->w, c->h );
		for ( j = 0; j < TOUCH_MAX_KEYS; j++ ) {
			if ( !c->keys[j][0] ) {
				len += Q_snprintf( buffer + len, sizeof( buffer ) - len, " -" );
			} else {
				len += Q_snprintf( buffer + len, sizeof( buffer ) - len, " %s", c->keys[j] );
			}
		}
		len += Q_snprintf( buffer + len, sizeof( buffer ) - len, "\n" );
		if ( len >= (int)sizeof( buffer ) - 64 ) {
			break;
		}
	}

	for ( p = buffer; *p; p++ ) {
		if ( *p == '\n' ) {
			/* Normalize newlines for all platforms. */
			*(char *)p = '\n';
		}
	}

	FS_Write( buffer, len, f );
	FS_FCloseFile( f );
	Com_Printf( "Saved %s (%d controls)\n", TOUCH_LAYOUT_FILE, touchLayout.count );
}

static void Touch_LoadLayout( void )
{
	fileHandle_t f;
	char buffer[ 8192 ];
	int length;
	char *cursor, *line;
	int count = 0;

	length = FS_FOpenFileRead( TOUCH_LAYOUT_FILE, &f, qfalse );
	if ( length <= 0 || !f ) {
		if ( f ) {
			FS_FCloseFile( f );
		}
		Com_Printf( "No %s found; using the default layout.\n", TOUCH_LAYOUT_FILE );
		Touch_DefaultLayout();
		return;
	}

	if ( length >= (int)sizeof( buffer ) ) {
		length = sizeof( buffer ) - 1;
	}
	Com_Memset( buffer, 0, sizeof( buffer ) );
	FS_Read( buffer, length, f );
	FS_FCloseFile( f );

	Com_Memset( &touchLayout, 0, sizeof( touchLayout ) );
	cursor = buffer;
	while ( (line = strsep( &cursor, "\r\n" )) != NULL && count < TOUCH_MAX_CONTROLS ) {
		char type[ 16 ], keys[ TOUCH_MAX_KEYS ][ TOUCH_MAX_KEYNAME ];
		float x, y, w, h;
		int j;
		int n;

		if ( !*line || line[0] == '/' || line[0] == '#' ) {
			continue;
		}

		Com_Memset( keys, 0, sizeof( keys ) );
		n = sscanf( line, "%15s %f %f %f %f %31s %31s %31s %31s %31s",
			type, &x, &y, &w, &h,
			keys[0], keys[1], keys[2], keys[3], keys[4] );
		if ( n < 5 ) {
			continue;
		}

		if ( !Q_stricmp( type, "version" ) ) {
			continue;
		}

		touchControl_t *c = &touchLayout.controls[count];
		if ( !Q_stricmp( type, "stick" ) ) {
			c->type = TOUCH_STICK;
		} else if ( !Q_stricmp( type, "button" ) ) {
			c->type = TOUCH_BUTTON;
		} else {
			continue;
		}

		c->x = x; c->y = y; c->w = w; c->h = h;
		for ( j = 0; j < TOUCH_MAX_KEYS; j++ ) {
			if ( n > 5 + j ) {
				if ( Q_stricmp( keys[j], "-" ) ) {
					Q_strncpyz( c->keys[j], keys[j], TOUCH_MAX_KEYNAME );
				}
			}
		}
		count++;
	}

	if ( count == 0 ) {
		Touch_DefaultLayout();
	} else {
		touchLayout.count = count;
	}
	Com_Printf( "Loaded %s (%d controls)\n", TOUCH_LAYOUT_FILE, touchLayout.count );
}

static void Touch_Save_f( void ) { Touch_SaveLayout(); }
static void Touch_Load_f( void ) { Touch_LoadLayout(); }
static void Touch_Reset_f( void )
{
	Touch_DefaultLayout();
	Com_Printf( "Touch layout reset to defaults. Use 'touch_layout_save' to keep it.\n" );
}
static void Touch_Edit_f( void )
{
	if ( touchLayout.editor ) {
		touchLayout.editor = qfalse;
		Touch_SaveLayout();
		Com_Printf( "Touch layout editor closed.\n" );
	} else {
		touchLayout.editor = qtrue;
		Com_Printf( "Touch layout editor: drag controls to move, use SIZE to resize, DONE to save.\n" );
	}
}
static void Touch_Add_f( void )
{
	touchControl_t *c;
	const char *type = Cmd_Argv( 1 );
	int i;

	if ( touchLayout.count >= TOUCH_MAX_CONTROLS ) {
		Com_Printf( "Maximum of %d touch controls reached.\n", TOUCH_MAX_CONTROLS );
		return;
	}

	i = touchLayout.count++;
	c = &touchLayout.controls[i];
	Com_Memset( c, 0, sizeof( *c ) );
	c->x = 0.42f; c->y = 0.42f; c->w = 0.14f; c->h = 0.14f;
	if ( !Q_stricmp( type, "stick" ) ) {
		c->type = TOUCH_STICK;
		Q_strncpyz( c->keys[0], "W", TOUCH_MAX_KEYNAME );
		Q_strncpyz( c->keys[1], "S", TOUCH_MAX_KEYNAME );
		Q_strncpyz( c->keys[2], "A", TOUCH_MAX_KEYNAME );
		Q_strncpyz( c->keys[3], "D", TOUCH_MAX_KEYNAME );
	} else {
		c->type = TOUCH_BUTTON;
		if ( Cmd_Argc() > 2 ) {
			Q_strncpyz( c->keys[0], Cmd_Argv( 2 ), TOUCH_MAX_KEYNAME );
		} else {
			Q_strncpyz( c->keys[0], "MOUSE1", TOUCH_MAX_KEYNAME );
		}
	}
	touchLayout.selected = i;
	Com_Printf( "Added %s control %d (%s).\n",
		c->type == TOUCH_STICK ? "stick" : "button", i, c->keys[0] );
}

static void Touch_Bind_f( void )
{
	int index;
	touchControl_t *c;
	int slot = 0;

	if ( Cmd_Argc() < 3 ) {
		Com_Printf( "usage: touch_bind <index> <key> [slot]\n" );
		return;
	}
	index = atoi( Cmd_Argv( 1 ) );
	if ( index < 0 || index >= touchLayout.count ) {
		Com_Printf( "Invalid control index %d.\n", index );
		return;
	}
	if ( Cmd_Argc() > 3 ) {
		slot = atoi( Cmd_Argv( 3 ) );
	}
	if ( slot < 0 || slot >= TOUCH_MAX_KEYS ) {
		slot = 0;
	}
	c = &touchLayout.controls[index];
	Q_strncpyz( c->keys[slot], Cmd_Argv( 2 ), TOUCH_MAX_KEYNAME );
	Com_Printf( "Control %d slot %d bound to %s.\n", index, slot, c->keys[slot] );
}

static void Touch_List_f( void )
{
	int i, j;
	for ( i = 0; i < touchLayout.count; i++ ) {
		touchControl_t *c = &touchLayout.controls[i];
		Com_Printf( "%2d %-6s %5.3f %5.3f %5.3f %5.3f", i,
			c->type == TOUCH_STICK ? "stick" : "button",
			c->x, c->y, c->w, c->h );
		for ( j = 0; j < TOUCH_MAX_KEYS; j++ ) {
			if ( c->keys[j][0] ) {
				Com_Printf( " %s", c->keys[j] );
			}
		}
		Com_Printf( "\n" );
	}
}

/*
=================
Touch_Init / Touch_Shutdown
=================
*/
void Touch_Init( void )
{
	if ( touchInitialized ) {
		return;
	}
	touchInitialized = qtrue;

#ifdef ANDROID
	touch_enable = Cvar_Get( "touch_enable", "1", CVAR_ARCHIVE );
#else
	touch_enable = Cvar_Get( "touch_enable", "0", CVAR_ARCHIVE );
#endif
	touch_opacity = Cvar_Get( "touch_opacity", "0.55", CVAR_ARCHIVE );
	touch_lookSensitivity = Cvar_Get( "touch_lookSensitivity", "0.22", CVAR_ARCHIVE );
	touch_editorResize = Cvar_Get( "touch_editorResize", "0", 0 );

	Cmd_AddCommand( "touch_layout_edit", Touch_Edit_f );
	Cmd_AddCommand( "touch_layout_save", Touch_Save_f );
	Cmd_AddCommand( "touch_layout_load", Touch_Load_f );
	Cmd_AddCommand( "touch_layout_reset", Touch_Reset_f );
	Cmd_AddCommand( "touch_layout_add", Touch_Add_f );
	Cmd_AddCommand( "touch_layout_list", Touch_List_f );
	Cmd_AddCommand( "touch_bind", Touch_Bind_f );

	Touch_LoadLayout();
}

void Touch_Shutdown( void )
{
	if ( !touchInitialized ) {
		return;
	}
	Touch_PointerCancelAll();
	if ( touchLayout.editor ) {
		Touch_SaveLayout();
	}
	touchInitialized = qfalse;
}

void Touch_Frame( void )
{
	if ( !touchInitialized ) {
		return;
	}
	if ( touch_editorResize ) {
		touchLayout.resizeMode = touch_editorResize->integer ? qtrue : qfalse;
	}
}

touchLayout_t *Touch_GetLayout( void )
{
	return &touchLayout;
}

/*
=================
Touch_Key helpers
=================
*/
static void Touch_KeyEvent( const char *name, qboolean down, int time )
{
	int key;

	if ( !name || !*name || !Q_stricmp( name, "-" ) ) {
		return;
	}
	if ( !Q_stricmp( name, "LOOK" ) ) {
		return;
	}
	key = Key_StringToKeynum( (char *)name );
	if ( key < 0 ) {
		return;
	}
	Com_QueueEvent( time, SE_KEY, key, down ? 1 : 0, 0, NULL );
}

static void Touch_SetStickKeys( touchControl_t *c, int dir, qboolean down, int time )
{
	static const int dirKeys[4] = { 0, 1, 2, 3 }; /* up, down, left, right */
	int i;

	for ( i = 0; i < 4; i++ ) {
		qboolean want = down ? ( ( dir & ( 1 << i ) ) != 0 ) : qfalse;
		if ( want != ( ( c->activeKey & ( 1 << i ) ) != 0 ) ) {
			if ( c->activeKey & ( 1 << i ) ) {
				Touch_KeyEvent( c->keys[ dirKeys[i] ], qfalse, time );
			} else {
				Touch_KeyEvent( c->keys[ dirKeys[i] ], qtrue, time );
			}
			if ( want ) {
				c->activeKey |= ( 1 << i );
			} else {
				c->activeKey &= ~( 1 << i );
			}
		}
	}
}

static qboolean Touch_Inside( touchControl_t *c, float x, float y )
{
	return x >= c->x && x <= c->x + c->w && y >= c->y && y <= c->y + c->h;
}

static int Touch_Find( float x, float y )
{
	int i;
	for ( i = touchLayout.count - 1; i >= 0; i-- ) {
		if ( Touch_Inside( &touchLayout.controls[i], x, y ) ) {
			return i;
		}
	}
	return -1;
}

/*
=================
Editor toolbar
=================
*/
#define TOUCH_TOOLBAR_COUNT 8
#define TOUCH_TOOLBAR_Y 0.012f
#define TOUCH_TOOLBAR_H 0.062f

static void Touch_ToolbarRect( int index, float *x, float *y, float *w, float *h )
{
	float gap = 0.008f;
	*x = 0.02f + index * ( ( 0.96f / TOUCH_TOOLBAR_COUNT ) + gap );
	*y = TOUCH_TOOLBAR_Y;
	*w = 0.96f / TOUCH_TOOLBAR_COUNT - gap;
	*h = TOUCH_TOOLBAR_H;
}

static const char *Touch_ToolbarLabel( int index )
{
	static const char *labels[ TOUCH_TOOLBAR_COUNT ] = {
		"ADD B", "ADD S", "MOVE", "SIZE", "BIND", "DEL", "SAVE", "DONE"
	};
	return labels[ index ];
}

/* Keys that can be selected entirely on a touchscreen in BIND mode. */
static const char *touchBindCycle[] = {
	"MOUSE1", "MOUSE2", "SPACE", "SHIFT", "CTRL", "UPARROW", "DOWNARROW",
	",", ".", "F1", "F2", "F3", "ENTER", "TAB", "R", "Q", "E", "1", "2", "3"
};

static void Touch_CycleBinding( touchControl_t *c )
{
	int i;

	for ( i = 0; i < (int)( sizeof( touchBindCycle ) / sizeof( touchBindCycle[0] ) ); i++ ) {
		if ( !Q_stricmp( c->keys[0], touchBindCycle[i] ) ) {
			i++;
			break;
		}
	}
	if ( i >= (int)( sizeof( touchBindCycle ) / sizeof( touchBindCycle[0] ) ) ) {
		i = 0;
	}
	Q_strncpyz( c->keys[0], touchBindCycle[i], TOUCH_MAX_KEYNAME );
	Com_Printf( "Control bound to %s.\\n", c->keys[0] );
}

static void Touch_ToolbarAction( int action )
{
	switch ( action ) {
	case 0: Touch_Add_f(); break;
	case 1:
		/* Add a stick via the console command so argument parsing stays in one place. */
		Cbuf_ExecuteText( EXEC_NOW, "touch_layout_add stick\n" );
		break;
	case 2:
		touchLayout.resizeMode = qfalse;
		touchLayout.bindMode = qfalse;
		Cvar_Set( "touch_editorResize", "0" );
		break;
	case 3:
		touchLayout.resizeMode = qtrue;
		touchLayout.bindMode = qfalse;
		Cvar_Set( "touch_editorResize", "1" );
		break;
	case 4:
		touchLayout.bindMode = touchLayout.bindMode ? qfalse : qtrue;
		touchLayout.resizeMode = qfalse;
		Cvar_Set( "touch_editorResize", "0" );
		Com_Printf( "BIND mode %s: tap a control to cycle its primary key.\n",
			touchLayout.bindMode ? "on" : "off" );
		break;
	case 5: {
		int i = touchLayout.selected;
		if ( i >= 0 && i < touchLayout.count ) {
			int j;
			for ( j = i; j + 1 < touchLayout.count; j++ ) {
				touchLayout.controls[j] = touchLayout.controls[j + 1];
			}
			touchLayout.count--;
			touchLayout.selected = -1;
			Com_Printf( "Deleted control %d.\n", i );
		}
		break;
	}
	case 6: Touch_SaveLayout(); break;
	case 7:
		touchLayout.editor = qfalse;
		Cvar_Set( "touch_editorResize", "0" );
		Touch_SaveLayout();
		Com_Printf( "Touch layout editor closed and layout saved.\n" );
		break;
	default: break;
	}
}

static int Touch_ToolbarHit( float x, float y )
{
	int i;
	for ( i = 0; i < TOUCH_TOOLBAR_COUNT; i++ ) {
		float tx, ty, tw, th;
		Touch_ToolbarRect( i, &tx, &ty, &tw, &th );
		if ( x >= tx && x <= tx + tw && y >= ty && y <= ty + th ) {
			return i;
		}
	}
	return -1;
}

/*
=================
Touch_PointerDown / Move / Up
=================
*/
qboolean Touch_PointerDown( int pointer, float x, float y, int time )
{
	touchControl_t *c;
	int i, slot;

	if ( !touchInitialized || !touch_enable || !touch_enable->integer ) {
		return qfalse;
	}

	slot = pointer;
	if ( slot < 0 || slot >= (int)( sizeof( touchDrag ) / sizeof( touchDrag[0] ) ) ) {
		slot = 0;
	}
	Com_Memset( &touchDrag[slot], 0, sizeof( touchDrag[slot] ) );
	touchDrag[slot].control = -1;
	touchDrag[slot].startX = x;
	touchDrag[slot].startY = y;
	touchDrag[slot].lastX = x;
	touchDrag[slot].lastY = y;

	if ( touchLayout.editor ) {
		int tool = Touch_ToolbarHit( x, y );
		if ( tool >= 0 ) {
			touchDrag[slot].toolbarAction = tool;
			Touch_ToolbarAction( tool );
			return qtrue;
		}
		i = Touch_Find( x, y );
		touchDrag[slot].control = i;
		if ( i >= 0 ) {
			touchLayout.selected = i;
			if ( touchLayout.bindMode ) {
				Touch_CycleBinding( &touchLayout.controls[i] );
			}
		}
		return qtrue;
	}

	i = Touch_Find( x, y );
	if ( i < 0 ) {
		return qfalse;
	}
	c = &touchLayout.controls[i];
	if ( c->pointer >= 0 && c->pointer != pointer ) {
		return qfalse;
	}
	c->pointer = pointer;
	touchDrag[slot].control = i;

	if ( c->type == TOUCH_BUTTON ) {
		Touch_KeyEvent( c->keys[0], qtrue, time );
	} else if ( !Q_stricmp( c->keys[0], "LOOK" ) ) {
		c->stickX = 0;
		c->stickY = 0;
	} else {
		Touch_SetStickKeys( c, 0, qfalse, time );
	}
	return qtrue;
}

void Touch_PointerMove( int pointer, float x, float y )
{
	touchControl_t *c;
	int i, slot;
	float cx, cy, dx, dy;

	if ( !touchInitialized ) {
		return;
	}

	slot = pointer;
	if ( slot < 0 || slot >= (int)( sizeof( touchDrag ) / sizeof( touchDrag[0] ) ) ) {
		slot = 0;
	}

	if ( touchLayout.editor ) {
		i = touchDrag[slot].control;
		if ( i >= 0 && i < touchLayout.count ) {
			c = &touchLayout.controls[i];
			dx = x - touchDrag[slot].lastX;
			dy = y - touchDrag[slot].lastY;
			if ( touchLayout.resizeMode ) {
				c->w = Touch_ClampFloat( c->w + dx, 0.04f, 1.0f - c->x );
				c->h = Touch_ClampFloat( c->h + dy, 0.04f, 1.0f - c->y );
			} else {
				c->x = Touch_ClampFloat( c->x + dx, 0.0f, 1.0f - c->w );
				c->y = Touch_ClampFloat( c->y + dy, 0.0f, 1.0f - c->h );
			}
		}
		touchDrag[slot].lastX = x;
		touchDrag[slot].lastY = y;
		return;
	}

	i = touchDrag[slot].control;
	if ( i < 0 || i >= touchLayout.count ) {
		return;
	}
	c = &touchLayout.controls[i];
	if ( c->pointer != pointer ) {
		return;
	}

	dx = x - touchDrag[slot].lastX;
	dy = y - touchDrag[slot].lastY;
	touchDrag[slot].lastX = x;
	touchDrag[slot].lastY = y;

	if ( c->type == TOUCH_STICK ) {
		cx = c->x + c->w * 0.5f;
		cy = c->y + c->h * 0.5f;
		c->stickX = Touch_ClampFloat( ( x - cx ) / ( c->w * 0.5f ), -1.0f, 1.0f );
		c->stickY = Touch_ClampFloat( ( y - cy ) / ( c->h * 0.5f ), -1.0f, 1.0f );

		if ( !Q_stricmp( c->keys[0], "LOOK" ) ) {
			float scale = touch_lookSensitivity ? touch_lookSensitivity->value : 0.22f;
			int mx = (int)( dx * glConfig.vidWidth * scale );
			int my = (int)( dy * glConfig.vidHeight * scale );
			if ( mx || my ) {
				Com_QueueEvent( Sys_Milliseconds(), SE_MOUSE, mx, my, 0, NULL );
			}
		} else {
			int dir = 0;
			if ( c->stickY < -0.35f ) { dir |= 1; }
			if ( c->stickY >  0.35f ) { dir |= 2; }
			if ( c->stickX < -0.35f ) { dir |= 4; }
			if ( c->stickX >  0.35f ) { dir |= 8; }
			Touch_SetStickKeys( c, dir, qtrue, Sys_Milliseconds() );
		}
	}
}

void Touch_PointerUp( int pointer, float x, float y, int time )
{
	touchControl_t *c;
	int i, slot;

	if ( !touchInitialized ) {
		return;
	}
	slot = pointer;
	if ( slot < 0 || slot >= (int)( sizeof( touchDrag ) / sizeof( touchDrag[0] ) ) ) {
		slot = 0;
	}

	i = touchDrag[slot].control;
	touchDrag[slot].control = -1;

	/* A toolbar tap has already been handled on press. */
	if ( touchLayout.editor ) {
		return;
	}
	if ( i < 0 || i >= touchLayout.count ) {
		return;
	}
	c = &touchLayout.controls[i];
	if ( c->pointer != pointer ) {
		return;
	}
	c->pointer = -1;

	if ( c->type == TOUCH_BUTTON ) {
		Touch_KeyEvent( c->keys[0], qfalse, time );
	} else {
		Touch_SetStickKeys( c, 0, qfalse, time );
		c->stickX = 0;
		c->stickY = 0;
	}
}

void Touch_PointerCancelAll( void )
{
	int i, j;
	int now = Sys_Milliseconds();

	for ( i = 0; i < touchLayout.count; i++ ) {
		touchControl_t *c = &touchLayout.controls[i];
		if ( c->pointer >= 0 ) {
			if ( c->type == TOUCH_BUTTON ) {
				Touch_KeyEvent( c->keys[0], qfalse, now );
			} else {
				Touch_SetStickKeys( c, 0, qfalse, now );
			}
			c->pointer = -1;
			c->stickX = c->stickY = 0;
		}
	}
	for ( j = 0; j < (int)( sizeof( touchDrag ) / sizeof( touchDrag[0] ) ); j++ ) {
		touchDrag[j].control = -1;
	}
}

/*
=================
Touch_OverlayActive
=================
*/
qboolean Touch_OverlayActive( void )
{
	return touchInitialized && touch_enable && touch_enable->integer &&
		touchLayout.count > 0 && glConfig.vidWidth && glConfig.vidHeight &&
		( !touch_opacity || touch_opacity->value >= 0.05f );
}

/*
=================
Touch_SnapshotOverlay

Called on the main thread so the render thread never reads mutable touch
state directly.
=================
*/
void Touch_SnapshotOverlay( touchOverlay_t *overlay )
{
	overlay->layout = touchLayout;
	overlay->alpha = touch_opacity ? touch_opacity->value : 0.55f;
	if ( !Touch_OverlayActive() ) {
		overlay->layout.count = 0;
	}
}

/*
=================
Touch_DrawOverlaySnapshot
=================
*/
void Touch_DrawOverlaySnapshot( const touchOverlay_t *overlay )
{
	const touchLayout_t *layout = &overlay->layout;
	float alpha = overlay->alpha;
	int i, j;
	float toolX, toolY, toolW, toolH;
	float textSize;

	if ( layout->count <= 0 ) {
		return;
	}
	if ( !glConfig.vidWidth || !glConfig.vidHeight ) {
		return;
	}

	qglMatrixMode( GL_PROJECTION );
	qglPushMatrix();
	qglLoadIdentity();
	qglOrtho( 0, glConfig.vidWidth, glConfig.vidHeight, 0, -1, 1 );
	qglMatrixMode( GL_MODELVIEW );
	qglPushMatrix();
	qglLoadIdentity();

	qglDisable( GL_TEXTURE_2D );
	qglDisable( GL_DEPTH_TEST );
	qglEnable( GL_BLEND );
	qglBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );

	textSize = Touch_MaxFloat( 2.0f, glConfig.vidHeight / 360.0f );

	for ( i = 0; i < layout->count; i++ ) {
		const touchControl_t *c = &layout->controls[i];
		float x = c->x * glConfig.vidWidth;
		float y = c->y * glConfig.vidHeight;
		float w = c->w * glConfig.vidWidth;
		float h = c->h * glConfig.vidHeight;
		float selected = layout->selected == i ? 1.0f : 0.0f;
		qboolean active = c->pointer >= 0;

		if ( c->type == TOUCH_BUTTON ) {
			Touch_DrawRect( x, y, w, h,
				active ? 1.0f : ( 0.35f + selected * 0.4f ),
				active ? 0.85f : 0.55f,
				0.25f,
				active ? alpha + 0.25f : alpha );
			Touch_DrawRect( x + 3, y + 3, w - 6, h - 6, 0.9f, 0.9f, 0.9f, alpha * 0.25f );
		} else {
			float cx = x + w * 0.5f;
			float cy = y + h * 0.5f;
			float radius = Touch_MinFloat( w, h ) * 0.42f;
			float tx = cx + c->stickX * radius - w * 0.11f;
			float ty = cy + c->stickY * radius - h * 0.11f;

			Touch_DrawRing( cx, cy, radius,
				0.9f, 0.9f, 0.9f, alpha );
			Touch_DrawRect( tx, ty, w * 0.22f, h * 0.22f,
				1.0f, active ? 0.9f : 0.6f, 0.2f, alpha + 0.2f );
		}

		if ( layout->editor ) {
			Touch_DrawText( c->keys[0], x + 4, y + 4, textSize,
				1.0f, 1.0f, 1.0f, 1.0f );
		}
	}

	if ( layout->editor ) {
		for ( i = 0; i < TOUCH_TOOLBAR_COUNT; i++ ) {
			Touch_ToolbarRect( i, &toolX, &toolY, &toolW, &toolH );
			toolX *= glConfig.vidWidth;
			toolY *= glConfig.vidHeight;
			toolW *= glConfig.vidWidth;
			toolH *= glConfig.vidHeight;
			Touch_DrawRect( toolX, toolY, toolW, toolH,
				0.08f, 0.18f, 0.30f, 0.92f );
			Touch_DrawText( Touch_ToolbarLabel(i), toolX + 4, toolY + toolH * 0.28f,
				Touch_MaxFloat( 2.0f, glConfig.vidHeight / 540.0f ),
				0.95f, 0.95f, 0.95f, 1.0f );
		}
		Touch_DrawText( "TOUCH LAYOUT EDITOR", glConfig.vidWidth * 0.31f,
			glConfig.vidHeight * 0.085f, Touch_MaxFloat( 2.0f, glConfig.vidHeight / 400.0f ),
			1.0f, 0.9f, 0.3f, 1.0f );
		Touch_DrawText( layout->bindMode ? "MODE: BIND" :
			( layout->resizeMode ? "MODE: SIZE" : "MODE: MOVE" ),
			glConfig.vidWidth * 0.39f, glConfig.vidHeight * 0.125f,
			Touch_MaxFloat( 2.0f, glConfig.vidHeight / 420.0f ),
			1.0f, 1.0f, 1.0f, 1.0f );
	}

	/* Keep the renderer's common state sane for the next frame. */
	qglDisable( GL_BLEND );
	qglEnable( GL_TEXTURE_2D );
	qglEnable( GL_DEPTH_TEST );
	qglMatrixMode( GL_MODELVIEW );
	qglPopMatrix();
	qglMatrixMode( GL_PROJECTION );
	qglPopMatrix();

	/* Silence an unused-variable warning on builds without the editor font paths. */
	(void)j;
	(void)Touch_FontIndex;
}

/*
=================
Touch_DrawOverlay
=================
*/
void Touch_DrawOverlay( void )
{
	touchOverlay_t overlay;

	Touch_SnapshotOverlay( &overlay );
	Touch_DrawOverlaySnapshot( &overlay );
}
