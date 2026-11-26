/*
 * Regression tests for server-side connect work that used to hitch everyone.
 *
 * ClientUserinfoChanged() re-read/re-parsed every tier config on every
 * connect and userinfo update, and pure-pak validation compared up to 1024x
 * 1024 checksums inside one packet event.  The tier tests link the real
 * g_tiers.c against a tiny filesystem stub so repeated loads can be detected.
 */

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

#include "../Game/Game/g_local.h"
#include "../Shared/checksum_hash.h"

static int failures;

#define CHECK(cond) do { \
	if (!(cond)) { \
		fprintf(stderr, "FAIL %s:%d: %s\n", __FILE__, __LINE__, #cond); \
		failures++; \
	} \
} while (0)

/* ------------------------------------------------------------------------ */
/* engine stubs                                                              */
/* ------------------------------------------------------------------------ */

typedef struct {
	char	path[MAX_QPATH];
	char	data[512];
} fakeFile_t;

static fakeFile_t	fakeFiles[64];
static int			fakeFileCount;
static int			fsOpens;
static int			fsCloses;

vmCvar_t g_breakLimitRate = { .value = 1.0f, .integer = 1, .string = "1" };

static fakeFile_t *FindFakeFile( const char *path ) {
	int i;

	for ( i = 0; i < fakeFileCount; i++ ) {
		if ( !strcmp( fakeFiles[i].path, path ) ) {
			return &fakeFiles[i];
		}
	}
	return NULL;
}

static void AddFakeFile( const char *path, const char *data ) {
	fakeFile_t *file = &fakeFiles[fakeFileCount++];

	Q_strncpyz( file->path, path, sizeof( file->path ) );
	Q_strncpyz( file->data, data, sizeof( file->data ) );
}

int trap_FS_FOpenFile( const char *qpath, fileHandle_t *f, fsMode_t mode ) {
	fakeFile_t *file = FindFakeFile( qpath );

	fsOpens++;
	if ( !file || mode != FS_READ ) {
		if ( f ) {
			*f = 0;
		}
		return -1;
	}
	if ( f ) {
		*f = (fileHandle_t)( file - fakeFiles + 1 );
	}
	return strlen( file->data );
}

void trap_FS_Read( void *buffer, int len, fileHandle_t f ) {
	fakeFile_t *file;

	if ( f < 1 || f > fakeFileCount ) {
		return;
	}
	file = &fakeFiles[f - 1];
	if ( len > (int)strlen( file->data ) ) {
		len = strlen( file->data );
	}
	memcpy( buffer, file->data, len );
}

void trap_FS_FCloseFile( fileHandle_t f ) {
	fsCloses++;
}

/* Simple whitespace tokenizer; the tier configs used here have no quotes. */
char *COM_Parse( char **data ) {
	static char token[256];
	char *s = *data;
	int len = 0;

	while ( *s && ( *s == ' ' || *s == '\t' || *s == '\r' || *s == '\n' ) ) {
		s++;
	}
	if ( !*s ) {
		*data = s;
		return "";
	}
	while ( *s && *s != ' ' && *s != '\t' && *s != '\r' && *s != '\n' && len < (int)sizeof( token ) - 1 ) {
		token[len++] = *s++;
	}
	token[len] = '\0';
	*data = s;
	return token;
}

char *QDECL va( char *format, ... ) {
	static char buffers[8][MAX_QPATH * 2];
	static int index;
	va_list ap;

	index = ( index + 1 ) % 8;
	va_start( ap, format );
	vsnprintf( buffers[index], sizeof( buffers[index] ), format, ap );
	va_end( ap );
	return buffers[index];
}

void Q_strncpyz( char *dest, const char *src, int destSize ) {
	if ( destSize < 1 ) {
		return;
	}
	if ( !src ) {
		src = "";
	}
	strncpy( dest, src, destSize - 1 );
	dest[destSize - 1] = '\0';
}

int Q_stricmp( const char *s1, const char *s2 ) {
	return strcasecmp( s1, s2 );
}

void Com_Error( int level, const char *fmt, ... ) {
	va_list ap;
	va_start( ap, fmt );
	vfprintf( stderr, fmt, ap );
	va_end( ap );
	abort();
}

/* ------------------------------------------------------------------------ */
/* tests                                                                     */
/* ------------------------------------------------------------------------ */

static void TestChecksumHash( void ) {
	checksumHash_t hash;
	int i;

	memset( &hash, 0, sizeof( hash ) );
	ChecksumHash_NextGeneration( &hash );

	for ( i = 0; i < 1024; i++ ) {
		CHECK( ChecksumHash_Insert( &hash, 1, 1000 + i * 37 ) );
	}
	for ( i = 0; i < 1024; i++ ) {
		CHECK( ChecksumHash_Contains( &hash, 1, 1000 + i * 37 ) );
	}
	CHECK( !ChecksumHash_Contains( &hash, 1, 999999 ) );
	CHECK( !ChecksumHash_Insert( &hash, 1, 1000 ) );
	/* tables are independent: table 0 is used for duplicate detection */
	CHECK( ChecksumHash_Insert( &hash, 0, 1000 ) );
	CHECK( ChecksumHash_Contains( &hash, 0, 1000 ) );
	CHECK( !ChecksumHash_Contains( &hash, 1, 1000 + 1024 * 37 ) );

	/* a new client must not see the previous client's checksums */
	ChecksumHash_NextGeneration( &hash );
	CHECK( !ChecksumHash_Contains( &hash, 1, 1000 ) );
	CHECK( ChecksumHash_Insert( &hash, 1, 1000 ) );
}

int main( void ) {
	gclient_t first, second;
	int opensAfterFirst;

	TestChecksumHash();

	AddFakeFile( "players/tierDefault.cfg", "speed 1.0 fatigueRecovery 2.0\n" );
	AddFakeFile( "players/goku/tier1/tier.cfg", "speed 2.0\n" );
	AddFakeFile( "players/vegeta/tier1/tier.cfg", "speed 3.0\n" );

	memset( &first, 0, sizeof( first ) );
	memset( &second, 0, sizeof( second ) );
	Q_strncpyz( first.modelName, "goku", sizeof( first.modelName ) );

	G_ClearTierCache();
	fsOpens = fsCloses = 0;

	setupTiers( &first );
	/* 8 tiers x (default config + model config) */
	CHECK( fsOpens == 16 );
	/* every file that exists is closed; missing tier configs are not */
	CHECK( fsCloses == 9 );
	CHECK( first.tiers[0].exists );
	CHECK( first.tiers[0].speed == 2.0 );
	CHECK( first.tiers[1].speed == 1.0 );
	opensAfterFirst = fsOpens;

	/* another client with the same model must reuse the parsed configs */
	Q_strncpyz( second.modelName, "goku", sizeof( second.modelName ) );
	setupTiers( &second );
	CHECK( fsOpens == opensAfterFirst );
	CHECK( memcmp( first.tiers, second.tiers, sizeof( first.tiers ) ) == 0 );

	/* a different model is parsed separately */
	Q_strncpyz( second.modelName, "vegeta", sizeof( second.modelName ) );
	setupTiers( &second );
	CHECK( fsOpens == opensAfterFirst + 16 );
	CHECK( second.tiers[0].speed == 3.0 );

	/* map changes must be able to invalidate the cached data */
	G_ClearTierCache();
	Q_strncpyz( first.modelName, "goku", sizeof( first.modelName ) );
	setupTiers( &first );
	CHECK( fsOpens == opensAfterFirst + 32 );

	if ( failures ) {
		fprintf( stderr, "%d check(s) failed\n", failures );
		return 1;
	}
	printf( "connect-cache tests passed\n" );
	return 0;
}
