/* Standalone regression tests for untrusted network-message parsing.
 *
 * These exercise the real MSG and Huffman code with ASan/UBSan so truncated
 * or attacker-controlled packets cannot read or write outside their buffers.
 */

#include <setjmp.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "q_shared.h"
#include "qcommon.h"

static jmp_buf errorJump;
static int caughtError;

void Com_Error( int code, const char *fmt, ... ) {
	va_list ap;
	char message[256];

	va_start( ap, fmt );
	Q_vsnprintf( message, sizeof( message ), fmt, ap );
	va_end( ap );
	caughtError = code;
	longjmp( errorJump, 1 );
}

void Com_Printf( const char *fmt, ... ) {
	(void)fmt;
}

static cvar_t shownetCvar;
cvar_t *cl_shownet = &shownetCvar;

void Q_strncpyz( char *dest, const char *src, int destsize ) {
	if ( destsize < 1 ) {
		return;
	}
	destsize--;
	strncpy( dest, src, destsize );
	dest[destsize] = '\0';
}

static int failures;

static void expect( qboolean condition, const char *what ) {
	if ( condition ) {
		printf( "ok - %s\n", what );
	} else {
		printf( "not ok - %s\n", what );
		failures++;
	}
}

/* A server-controlled playerstate delta must not walk past the field table. */
static void test_playerstate_field_count( void ) {
	byte data[8];
	msg_t msg;
	playerState_t from, to;

	MSG_InitOOB( &msg, data, sizeof( data ) );
	memset( data, 0, sizeof( data ) );
	memset( &from, 0, sizeof( from ) );
	memset( &to, 0, sizeof( to ) );
	data[0] = 255;
	msg.cursize = 1;
	MSG_BeginReadingOOB( &msg );

	caughtError = 0;
	if ( setjmp( errorJump ) == 0 ) {
		MSG_ReadDeltaPlayerstate( &msg, &from, &to );
		expect( qfalse, "oversized playerstate field count is rejected" );
	} else {
		expect( caughtError == ERR_DROP,
			"oversized playerstate field count is rejected" );
	}
}

/* Bitstream reads must stay inside the received packet, even for a peer that
 * claims a much larger payload than it actually sent. */
static void test_bitstream_bounds( void ) {
	byte *data = malloc( 1 );
	msg_t msg;

	expect( data != NULL, "allocated one-byte packet" );
	if ( !data ) {
		return;
	}
	data[0] = 0;
	MSG_Init( &msg, data, 1 );
	msg.cursize = 1;
	MSG_Bitstream( &msg );
	MSG_BeginReading( &msg );

	(void)MSG_ReadLong( &msg );
	expect( msg.overflowed == qtrue, "bitstream read stops at end of packet" );
	free( data );
}

/* The connectionless connect prefix needs two length bytes before decoding. */
static void test_huffman_short_packet( void ) {
	byte *data = malloc( 13 );
	msg_t msg;
	int i;

	expect( data != NULL, "allocated short connect packet" );
	if ( !data ) {
		return;
	}
	for ( i = 0; i < 13; i++ ) {
		data[i] = 0;
	}
	MSG_Init( &msg, data, 13 );
	msg.cursize = 13;
	MSG_BeginReadingOOB( &msg );
	Huff_Decompress( &msg, 12 );
	expect( qtrue, "one-byte Huffman payload is ignored without OOB read" );
	free( data );
}

int main( void ) {
	shownetCvar.integer = 0;

	printf( "1..3\n" );
	test_playerstate_field_count();
	test_bitstream_bounds();
	test_huffman_short_packet();

	if ( failures ) {
		printf( "%d network safety test(s) failed\n", failures );
		return 1;
	}
	printf( "All network safety tests passed.\n" );
	return 0;
}
