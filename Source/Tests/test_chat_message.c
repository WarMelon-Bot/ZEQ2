/*
 * Regression tests for the hardened client chat/message helpers.
 *
 * The helpers live in Source/Game/CGame/cg_chat.h and cg_teamchat.h so they
 * can be exercised without pulling in the whole cgame module. Q_strncpyz is
 * stubbed here; the
 * actual allocator/string implementation is covered by the other test targets.
 */
#include "../Game/CGame/cg_chat.h"
#include "../Game/CGame/cg_teamchat.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int failures;

#define CHECK( expr ) do { \
	if ( !(expr) ) { \
		fprintf( stderr, "FAIL %s:%d: %s\n", __FILE__, __LINE__, #expr ); \
		failures++; \
	} \
} while ( 0 )

void Q_strncpyz( char *dest, const char *src, int destsize ) {
	int i;

	if ( !dest || !src || destsize < 1 ) {
		return;
	}
	for ( i = 0; i < destsize - 1 && src[i]; i++ ) {
		dest[i] = src[i];
	}
	dest[i] = '\0';
}

static void test_color_strings( void ) {
	CHECK( Q_IsColorString( "^0" ) );
	CHECK( Q_IsColorString( "^9" ) );
	CHECK( Q_IsColorString( "^a" ) );
	CHECK( Q_IsColorString( "^z" ) );
	CHECK( Q_IsColorString( "^A" ) );
	CHECK( Q_IsColorString( "^Z" ) );
	CHECK( !Q_IsColorString( (const char *)NULL ) );
	CHECK( !Q_IsColorString( "" ) );
	CHECK( !Q_IsColorString( "^" ) );
	CHECK( !Q_IsColorString( "^ " ) );
	CHECK( !Q_IsColorString( "x^1" ) );

	// The old isalnum() check had undefined behaviour for negative chars.
	CHECK( !Q_IsColorString( "^\x80" ) );
}

static void test_copy_text( void ) {
	char dest[16];
	char small[8];

	memset( dest, 'X', sizeof( dest ) );
	CG_ChatCopyText( dest, sizeof( dest ), NULL );
	CHECK( dest[0] == '\0' );

	CG_ChatCopyText( dest, sizeof( dest ), "" );
	CHECK( dest[0] == '\0' );

	// Colour escapes are preserved so the HUD renders coloured chat again.
	CG_ChatCopyText( dest, sizeof( dest ), "^1Red^7 and ^aMalphite" );
	CHECK( strcmp( dest, "^1Red^7 and ^aM" ) == 0 );

	// Truncation must never leave a dangling escape at the end.
	memset( small, 'X', sizeof( small ) );
	CG_ChatCopyText( small, sizeof( small ), "123456^1X" );
	CHECK( strcmp( small, "123456" ) == 0 );
	CHECK( strlen( small ) < sizeof( small ) );

	// Control/high-bit bytes cannot inject newlines or binary glyphs.
	CG_ChatCopyText( dest, sizeof( dest ), "a\r\nb\x01" "\x80" "c" );
	CHECK( strcmp( dest, "a  b  c" ) == 0 );
}

static void test_speaker_names( void ) {
	char name[64];
	char clientName[64];
	char longName[300];
	char line[400];
	int i;

	CG_ChatSpeakerName( "\x19(Goku^7) (New York)\x19: hello", name, sizeof( name ) );
	CHECK( strcmp( name, "(Goku) (New York)" ) == 0 );

	CG_ChatSpeakerName( "^1Goku^7: hi", name, sizeof( name ) );
	CG_ChatCleanName( "^1Goku^7", clientName, sizeof( clientName ) );
	CHECK( strcmp( name, "Goku" ) == 0 );
	CHECK( strcmp( name, clientName ) == 0 );

	CG_ChatSpeakerName( "Bobbynobody", name, sizeof( name ) );
	CHECK( strcmp( name, "Bobbynobody" ) == 0 );

	for ( i = 0; i < (int)sizeof( longName ) - 1; i++ ) {
		longName[i] = 'A';
	}
	longName[sizeof( longName ) - 1] = '\0';
	snprintf( line, sizeof( line ), "%s: hello", longName );

	memset( name, 'X', sizeof( name ) );
	CG_ChatSpeakerName( line, name, sizeof( name ) );
	CHECK( strlen( name ) == sizeof( name ) - 1 );
	CHECK( name[sizeof( name ) - 1] == '\0' );

	CG_ChatSpeakerName( NULL, name, sizeof( name ) );
	CHECK( name[0] == '\0' );
}

static void test_team_lines( void ) {
	char line[241];
	char tiny[2];
	char spam[301];
	char color[16];
	char lastColor;
	size_t consumed;
	int i;

	// All-escape input used to advance the write pointer without ever
	// reaching the visible-width limit. The byte budget must stop it.
	for ( i = 0; i < (int)sizeof( spam ) - 1; i += 2 ) {
		spam[i] = Q_COLOR_ESCAPE;
		spam[i + 1] = '1';
	}
	spam[sizeof( spam ) - 1] = '\0';

	consumed = CG_ChatBuildTeamLine( spam, line, sizeof( line ), 80, &lastColor );
	CHECK( consumed > 0 );
	CHECK( consumed <= sizeof( spam ) - 1 );
	CHECK( strlen( line ) < sizeof( line ) );
	CHECK( line[0] == Q_COLOR_ESCAPE );
	CHECK( line[1] >= '0' && line[1] <= '7' );

	// Word wrapping rewinds to the last space and keeps control bytes out.
	lastColor = COLOR_WHITE;
	consumed = CG_ChatBuildTeamLine( "1234 5678 90", line, sizeof( line ), 8, &lastColor );
	CHECK( consumed == 5 );
	CHECK( strcmp( line, "^71234 " ) == 0 );
	consumed = CG_ChatBuildTeamLine( "1234 5678 90" + consumed, line, sizeof( line ), 8, &lastColor );
	CHECK( consumed > 0 );
	CHECK( strcmp( line, "^75678 90" ) == 0 );

	// Colour state carries across wrapped lines.
	lastColor = COLOR_WHITE;
	consumed = CG_ChatBuildTeamLine( "^3abcdef", line, 64, 2, &lastColor );
	CHECK( consumed == 4 );
	CHECK( strcmp( line, "^7^3ab" ) == 0 );
	CHECK( lastColor == '3' );
	Q_strncpyz( color, "^3abcdef" + consumed, sizeof( color ) );
	CG_ChatBuildTeamLine( color, line, 64, 2, &lastColor );
	CHECK( strcmp( line, "^3cd" ) == 0 );

	lastColor = COLOR_WHITE;
	CG_ChatBuildTeamLine( "a\r\n\x01\x7f!b", line, sizeof( line ), 80, &lastColor );
	CHECK( strcmp( line, "^7a    !b" ) == 0 );

	// A zero/one byte destination cannot be overrun and makes no progress.
	line[0] = 'X';
	CHECK( CG_ChatBuildTeamLine( "abc", NULL, sizeof( line ), 80, &lastColor ) == 0 );
	CHECK( CG_ChatBuildTeamLine( "abc", line, 0, 80, &lastColor ) == 0 );
	CHECK( line[0] == 'X' );
	CHECK( CG_ChatBuildTeamLine( "abc", tiny, sizeof( tiny ), 80, &lastColor ) == 1 );
	CHECK( strlen( tiny ) == 1 );
}

static void test_message_slots( void ) {
	char messages[3][8];
	int clients[3];
	int index;
	char longText[512];
	int i;

	memset( messages, 0, sizeof( messages ) );
	clients[0] = clients[1] = clients[2] = -1;

	CHECK( CG_ChatMessageSlot( NULL, sizeof( messages[0] ), clients, 3 ) == -1 );
	CHECK( CG_ChatMessageSlot( &messages[0][0], 0, clients, 3 ) == -1 );
	CHECK( CG_ChatMessageSlot( &messages[0][0], sizeof( messages[0] ), NULL, 3 ) == -1 );
	CHECK( CG_ChatMessageSlot( &messages[0][0], sizeof( messages[0] ), clients, 0 ) == -1 );

	index = CG_ChatMessageSlot( &messages[0][0], sizeof( messages[0] ), clients, 3 );
	CHECK( index == 0 );
	Q_strncpyz( messages[index], "one", sizeof( messages[index] ) );
	clients[index] = 1;

	index = CG_ChatMessageSlot( &messages[0][0], sizeof( messages[0] ), clients, 3 );
	CHECK( index == 1 );
	Q_strncpyz( messages[index], "two", sizeof( messages[index] ) );
	clients[index] = 2;

	index = CG_ChatMessageSlot( &messages[0][0], sizeof( messages[0] ), clients, 3 );
	CHECK( index == 2 );
	Q_strncpyz( messages[index], "three", sizeof( messages[index] ) );
	clients[index] = 3;

	// A fourth message rotates the oldest out without writing slot 3.
	index = CG_ChatMessageSlot( &messages[0][0], sizeof( messages[0] ), clients, 3 );
	CHECK( index == 0 );
	CHECK( strcmp( messages[0], "" ) == 0 );
	CHECK( strcmp( messages[1], "one" ) == 0 );
	CHECK( strcmp( messages[2], "two" ) == 0 );
	CHECK( clients[0] == -1 );
	CHECK( clients[1] == 1 );
	CHECK( clients[2] == 2 );

	for ( i = 0; i < (int)sizeof( longText ) - 1; i++ ) {
		longText[i] = 'Z';
	}
	longText[sizeof( longText ) - 1] = '\0';
	CG_ChatCopyText( messages[index], sizeof( messages[index] ), longText );
	CHECK( strlen( messages[index] ) == sizeof( messages[index] ) - 1 );
	CHECK( messages[index][sizeof( messages[index] ) - 1] == '\0' );
}

int main( void ) {
	printf( "Running client chat/message regression tests...\n" );

	test_color_strings();
	test_copy_text();
	test_team_lines();
	test_speaker_names();
	test_message_slots();

	if ( failures ) {
		fprintf( stderr, "%d chat/message test(s) failed\n", failures );
		return 1;
	}

	printf( "All client chat/message tests passed.\n" );
	return 0;
}
