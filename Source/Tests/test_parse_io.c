/* Regression tests for the shared helpers used by the filesystem and by the
 * weapon physics / graphics script scanners.
 *
 * These converters replace atof/strtol on untrusted script data.  They must
 * reject overflow and trailing text instead of wrapping values or producing
 * infinities, and the suffix helper must never read before a short filename.
 */

#include <math.h>
#include <stdio.h>
#include <string.h>

#include "q_shared.h"

void QDECL Com_Printf( const char *fmt, ... ) {
	(void)fmt;
}

void QDECL Com_Error( int code, const char *fmt, ... ) {
	(void)code;
	(void)fmt;
}

static int failures;
static int checks;

static void expect( qboolean condition, const char *what ) {
	checks++;
	if ( condition ) {
		printf( "ok - %s\n", what );
	} else {
		printf( "not ok - %s\n", what );
		failures++;
	}
}

static void test_integer_conversion( void ) {
	int value = 12345;

	expect( Q_ParseInteger( "0", &value ) && value == 0, "zero parses" );
	expect( Q_ParseInteger( "-1", &value ) && value == -1, "negative integer parses" );
	expect( Q_ParseInteger( "+42", &value ) && value == 42, "explicit positive parses" );
	expect( Q_ParseInteger( "2147483647", &value ) && value == INT_MAX, "INT_MAX parses" );
	expect( Q_ParseInteger( "-2147483648", &value ) && value == INT_MIN, "INT_MIN parses" );

	value = 7;
	expect( !Q_ParseInteger( "2147483648", &value ) && value == 7, "positive overflow is rejected" );
	expect( !Q_ParseInteger( "-2147483649", &value ) && value == 7, "negative overflow is rejected" );
	expect( !Q_ParseInteger( "12foo", &value ) && value == 7, "trailing text is rejected" );
	expect( !Q_ParseInteger( "-", &value ) && value == 7, "bare sign is rejected" );
	expect( !Q_ParseInteger( "", &value ) && value == 7, "empty string is rejected" );
	expect( !Q_ParseInteger( "1.0", &value ) && value == 7, "decimal is not an integer token" );
}

static void test_float_conversion( void ) {
	float value = -1.0f;

	expect( Q_ParseFloat( "0", &value ) && value == 0.0f, "integer text parses as float" );
	expect( Q_ParseFloat( "1.25", &value ) && fabsf( value - 1.25f ) < 0.0001f, "decimal parses" );
	expect( Q_ParseFloat( "-.5", &value ) && fabsf( value + 0.5f ) < 0.0001f, "leading-dot negative parses" );
	expect( Q_ParseFloat( "12.", &value ) && fabsf( value - 12.0f ) < 0.0001f, "trailing dot parses" );

	value = -1.0f;
	expect( !Q_ParseFloat( "1e30", &value ) && value == -1.0f, "exponent notation is rejected" );
	expect( !Q_ParseFloat( "1.2.3", &value ) && value == -1.0f, "second decimal point is rejected" );
	expect( !Q_ParseFloat( "9999999999999999999999999999999999999999", &value ) && value == -1.0f, "float overflow is rejected" );
	expect( !Q_ParseFloat( "-", &value ) && value == -1.0f, "bare sign is not a float" );
	expect( !Q_ParseFloat( ".", &value ) && value == -1.0f, "bare dot is not a float" );
}

static void test_suffix_matching( void ) {
	const char *shortName = "a";
	const char *config = "players/goku/default.cfg";

	expect( Q_EndsWithIgnoreCase( shortName, strlen( shortName ), ".shader" ) == qfalse,
		"short name does not match a longer suffix" );
	expect( Q_EndsWithIgnoreCase( shortName, strlen( shortName ), ".cfg" ) == qfalse,
		"short name does not match .cfg" );
	expect( Q_EndsWithIgnoreCase( config, strlen( config ), ".cfg" ) == qtrue,
		"exact suffix matches" );
	expect( Q_EndsWithIgnoreCase( config, strlen( config ), ".CFG" ) == qtrue,
		"suffix matching is case insensitive" );
	expect( Q_EndsWithIgnoreCase( config, strlen( config ), ".config" ) == qfalse,
		"partial suffix does not match" );
	expect( Q_EndsWithIgnoreCase( config, 1, ".cfg" ) == qfalse,
		"explicit short length does not match" );
}

int main( void ) {
	printf( "1..%d\n", 26 );
	test_integer_conversion();
	test_float_conversion();
	test_suffix_matching();

	if ( failures ) {
		printf( "%d parse/IO helper test(s) failed\n", failures );
		return 1;
	}
	printf( "All parse/IO helper tests passed (%d checks).\n", checks );
	return 0;
}
