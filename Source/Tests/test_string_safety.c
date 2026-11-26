/* Regression tests for the engine's core string formatter.
 *
 * Com_sprintf used to stage every result in a 32000 byte stack buffer.  These
 * checks make sure the direct-to-destination implementation still terminates
 * correctly, reports truncation, and no longer rejects large output.
 */

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "q_shared.h"
#include "qcommon.h"

static int printfCalls;
static int fatalErrors;

void Com_Printf( const char *fmt, ... ) {
	(void)fmt;
	printfCalls++;
}

void Com_Error( int code, const char *fmt, ... ) {
	(void)code;
	(void)fmt;
	fatalErrors++;
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

static void reset( void ) {
	printfCalls = 0;
	fatalErrors = 0;
}

static void test_exact_and_short_output( void ) {
	char buffer[16];

	reset();
	Com_sprintf( buffer, sizeof( buffer ), "%s-%d", "ok", 7 );
	expect( strcmp( buffer, "ok-7" ) == 0, "short format writes the full result" );
	expect( printfCalls == 0 && fatalErrors == 0, "short format produces no diagnostics" );

	Com_sprintf( buffer, sizeof( buffer ), "123456789012345" );
	expect( strcmp( buffer, "123456789012345" ) == 0, "exact fit is preserved" );
	expect( printfCalls == 0 && fatalErrors == 0, "exact fit produces no diagnostics" );
}

static void test_truncation( void ) {
	char buffer[8];

	reset();
	Com_sprintf( buffer, sizeof( buffer ), "%s", "abcdefghijklmno" );
	expect( strlen( buffer ) == sizeof( buffer ) - 1, "truncated output is terminated" );
	expect( strcmp( buffer, "abcdefg" ) == 0, "truncated output keeps the leading bytes" );
	expect( printfCalls == 1, "truncation is reported once" );
	expect( fatalErrors == 0, "truncation is not treated as a fatal error" );
}

static void test_zero_and_one_byte_destinations( void ) {
	char buffer[2] = { 'x', 'y' };

	reset();
	Com_sprintf( buffer, 0, "%s", "ignored" );
	expect( buffer[0] == 'x' && buffer[1] == 'y', "zero-size destination is untouched" );

	Com_sprintf( buffer, 1, "%s", "ignored" );
	expect( buffer[0] == '\0', "one-byte destination is terminated" );
	expect( fatalErrors == 0, "small destinations do not cause fatal errors" );
}

static void test_large_output( void ) {
	size_t size = 40000;
	char *source = malloc( size );
	char dest[64];

	expect( source != NULL, "allocated a >32 KiB source string" );
	if ( !source ) {
		return;
	}
	memset( source, 'A', size - 1 );
	source[size - 1] = '\0';

	reset();
	Com_sprintf( dest, sizeof( dest ), "%s", source );
	expect( strlen( dest ) == sizeof( dest ) - 1, "large output is truncated safely" );
	expect( fatalErrors == 0, "large input no longer trips the old scratch-buffer limit" );

	free( source );
}

int main( void ) {
	printf( "1..14\n" );
	test_exact_and_short_output();
	test_truncation();
	test_zero_and_one_byte_destinations();
	test_large_output();

	if ( failures ) {
		printf( "%d string safety test(s) failed\n", failures );
		return 1;
	}
	printf( "All string safety tests passed.\n" );
	return 0;
}
