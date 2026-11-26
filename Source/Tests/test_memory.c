/*
 * Standalone regression tests for the ZEQ2-Lite zone and hunk allocators.
 *
 * The tests link against the real Shared/common.c with a handful of engine
 * stubs, so they exercise the exact allocator used by the client and the
 * dedicated server.  Run them with: ./build.sh memory-test
 */

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "q_shared.h"
#include "qcommon.h"

extern cvar_t *com_dedicated;

// Matches HUNK_ALIGN in common.c.
#define TEST_HUNK_ALIGN 64

static cvar_t hunkCvar = { .name = "com_hunkMegs", .string = "2", .value = 2, .integer = 2 };
static cvar_t zoneCvar = { .name = "com_zoneMegs", .string = "2", .value = 2, .integer = 2 };
static cvar_t dedicatedCvar = { .name = "com_dedicated", .string = "1", .value = 1, .integer = 1 };

static int failures;

#define CHECK( condition, ... ) do { \
	if ( !(condition) ) { \
		printf( "FAIL %s:%d: ", __FILE__, __LINE__ ); \
		printf( __VA_ARGS__ ); \
		printf( "\n" ); \
		failures++; \
	} \
} while ( 0 )

/*
 * Engine stubs.  The allocator tests never enter the game loop, so only the
 * small set of functions called during allocator setup need definitions.
 */
void QDECL Sys_Error( const char *error, ... ) {
	va_list argptr;
	va_start( argptr, error );
	vfprintf( stderr, error, argptr );
	va_end( argptr );
	fputc( '\n', stderr );
	abort();
}

void Sys_Print( const char *msg ) {
	fputs( msg, stdout );
}

cvar_t *Cvar_Get( const char *var_name, const char *value, int flags ) {
	(void)value;
	(void)flags;
	if ( !strcmp( var_name, "com_hunkMegs" ) ) {
		return &hunkCvar;
	}
	if ( !strcmp( var_name, "com_zoneMegs" ) ) {
		return &zoneCvar;
	}
	return NULL;
}

int FS_LoadStack( void ) {
	return 0;
}

void Cmd_AddCommand( const char *cmd_name, xcommand_t function ) {
	(void)cmd_name;
	(void)function;
}

void SV_ShutdownGameProgs( void ) {
}

void VM_Clear( void ) {
}

static unsigned rngState = 0x12345678u;

static unsigned NextRandom( void ) {
	rngState ^= rngState << 13;
	rngState ^= rngState >> 17;
	rngState ^= rngState << 5;
	return rngState;
}

static void TestZoneBasic( void ) {
	byte *a, *b, *c;
	int before, after;

	before = Z_AvailableMemory();
	a = Z_Malloc( 1 );
	b = Z_Malloc( 1000 );
	c = S_Malloc( 33 );
	CHECK( a != NULL && b != NULL && c != NULL, "basic zone allocation returned NULL" );
	if ( !a || !b || !c ) {
		return;
	}
	CHECK( a[0] == 0 && b[999] == 0, "Z_Malloc did not zero memory" );
	CHECK( ( (uintptr_t)a % 16 ) == 0 && ( (uintptr_t)b % 16 ) == 0 && ( (uintptr_t)c % 16 ) == 0,
		"zone allocations are not aligned (a=%p b=%p c=%p)", (void *)a, (void *)b, (void *)c );

	// S_Malloc uses Z_TagMalloc, which deliberately does not zero its block.
	Com_Memset( c, 0xa5, 33 );
	CHECK( c[0] == 0xa5 && c[32] == 0xa5, "S_Malloc unexpectedly changed its block" );
	// a and b share the main zone, so only they may be ordered portably.  c
	// comes from the small zone; just make sure it is a distinct allocation.
	CHECK( b > a && c != a && c != b, "zone allocations overlap" );

	after = Z_AvailableMemory();
	CHECK( after < before, "available zone memory did not decrease (%i -> %i)", before, after );

	Z_Free( c );
	Z_Free( b );
	Z_Free( a );
	Z_CheckHeap();
	CHECK( Z_AvailableMemory() == before, "freeing did not restore zone memory (%i -> %i)", before, Z_AvailableMemory() );

	// Static strings must be freeable without touching the arena.
	CHECK( strcmp( CopyString( "" ), "" ) == 0, "empty static string is wrong: '%s'", CopyString( "" ) );
	CHECK( strcmp( CopyString( "7" ), "7" ) == 0, "digit static string is wrong: '%s'", CopyString( "7" ) );
	Z_Free( CopyString( "" ) );
	Z_Free( CopyString( "7" ) );
	Z_CheckHeap();
}

static void TestZoneStress( void ) {
#define SLOT_COUNT 64
#define ITERATIONS 20000
	void *ptrs[SLOT_COUNT];
	unsigned sizes[SLOT_COUNT];
	unsigned patterns[SLOT_COUNT];
	int i, slot;
	size_t size, j;
	byte *p;
	clock_t start;
	unsigned allocations = 0;
	int failuresBefore = failures;

	memset( ptrs, 0, sizeof( ptrs ) );
	memset( sizes, 0, sizeof( sizes ) );

	start = clock();
	for ( i = 0; i < ITERATIONS; i++ ) {
		slot = (int)( NextRandom() % SLOT_COUNT );
		if ( ptrs[slot] ) {
			p = ptrs[slot];
			for ( size = 0; size < sizes[slot]; size++ ) {
				CHECK( p[size] == (byte)( patterns[slot] + size ),
					"zone block %d corrupted at offset %u", slot, (unsigned)size );
				if ( failures != failuresBefore ) {
					return;
				}
			}
			Z_Free( ptrs[slot] );
			ptrs[slot] = NULL;
		} else {
			size = 1 + NextRandom() % 2048;
			p = Z_Malloc( (int)size );
			if ( !p ) {
				CHECK( 0, "stress allocation failed at iteration %d", i );
				return;
			}
			patterns[slot] = NextRandom() & 0xff;
			for ( j = 0; j < size; j++ ) {
				p[j] = (byte)( patterns[slot] + j );
			}
			ptrs[slot] = p;
			sizes[slot] = (unsigned)size;
			allocations++;
		}
		if ( ( i % 250 ) == 0 ) {
			Z_CheckHeap();
		}
	}

	for ( i = 0; i < SLOT_COUNT; i++ ) {
		if ( ptrs[i] ) {
			Z_Free( ptrs[i] );
		}
	}

	Z_CheckHeap();
	printf( "  zone stress: %u allocations in %.3fs\n",
		allocations, (double)( clock() - start ) / CLOCKS_PER_SEC );

	// A large allocation can only succeed if all the small neighbours were
	// coalesced back into one block.
p = Z_Malloc( 512 * 1024 );
	CHECK( p != NULL, "zone did not coalesce free blocks" );
Z_Free( p );
	Z_CheckHeap();
#undef SLOT_COUNT
#undef ITERATIONS
}

static void TestZoneTags( void ) {
	void *tagged[16];
	int i;
	int before = Z_AvailableMemory();

	for ( i = 0; i < 16; i++ ) {
		tagged[i] = Z_TagMalloc( 64 + i, i % 2 ? TAG_BOTLIB : TAG_RENDERER );
		CHECK( tagged[i] != NULL, "tagged allocation %d failed", i );
	}
Z_FreeTags( TAG_BOTLIB );
	Z_CheckHeap();
	CHECK( Z_AvailableMemory() < before, "tagged allocations did not consume memory" );
	for ( i = 0; i < 16; i += 2 ) {
		Z_Free( tagged[i] );
	}
	Z_CheckHeap();
	CHECK( Z_AvailableMemory() == before, "tagged frees did not restore memory" );
}

static void TestHunk( void ) {
	byte *low, *high, *temp1, *temp2;
	int before, after, remaining;

	com_dedicated = &dedicatedCvar;
	Com_InitHunkMemory();

	before = Hunk_MemoryRemaining();
	CHECK( before > 1024 * 1024, "unexpected hunk size: %i", before );

	// Give the high bank a temp high-water mark first.  Without this, h_high
	// is served from the low bank because both banks start with no waste and
	// Hunk_SwapBanks only swaps when the temp side has more unused history.
	temp1 = Hunk_AllocateTempMemory( 256 * 1024 );
	CHECK( temp1 != NULL, "could not prime the high hunk bank" );
	Hunk_ClearTempMemory();

	low = Hunk_Alloc( 1024, h_low );
	high = Hunk_Alloc( 2048, h_high );
	CHECK( low != NULL && high != NULL, "hunk allocation returned NULL" );
	if ( !low || !high ) {
		return;
	}
	CHECK( ( (uintptr_t)low % TEST_HUNK_ALIGN ) == 0 && ( (uintptr_t)high % TEST_HUNK_ALIGN ) == 0,
		"hunk allocations are not cache-line aligned (%p, %p)", (void *)low, (void *)high );
	CHECK( low[0] == 0 && high[2047] == 0, "Hunk_Alloc did not zero memory" );
	CHECK( high > low && (size_t)( high - low ) > 1024 * 1024,
		"h_high was not served from the high bank (%p, %p)", (void *)low, (void *)high );

	after = Hunk_MemoryRemaining();
	CHECK( after < before, "hunk remaining did not decrease (%i -> %i)", before, after );

	temp1 = Hunk_AllocateTempMemory( 1000 );
	temp2 = Hunk_AllocateTempMemory( 2000 );
	CHECK( temp1 != NULL && temp2 != NULL, "hunk temp allocation returned NULL" );
	if ( temp1 && temp2 ) {
		CHECK( ( (uintptr_t)temp1 % TEST_HUNK_ALIGN ) == 0 && ( (uintptr_t)temp2 % TEST_HUNK_ALIGN ) == 0,
			"hunk temp allocations are not aligned (%p, %p)", (void *)temp1, (void *)temp2 );
		memset( temp1, 0x5a, 1000 );
		memset( temp2, 0xa5, 2000 );
		CHECK( Hunk_MemoryRemaining() < after, "temp allocation did not consume hunk memory" );
		Hunk_FreeTempMemory( temp2 );
		Hunk_FreeTempMemory( temp1 );
		CHECK( Hunk_MemoryRemaining() == after, "LIFO temp free did not restore hunk memory (%i != %i)",
			Hunk_MemoryRemaining(), after );
	}

	temp1 = Hunk_AllocateTempMemory( 4096 );
	Hunk_ClearTempMemory();
	CHECK( Hunk_MemoryRemaining() == after, "Hunk_ClearTempMemory did not restore hunk memory (%i != %i)",
		Hunk_MemoryRemaining(), after );

	Hunk_SetMark();
	remaining = Hunk_MemoryRemaining();
	Hunk_ClearToMark();
	CHECK( Hunk_MemoryRemaining() == remaining, "Hunk_ClearToMark changed remaining memory" );

	// Touching all allocated hunk pages must not fault or corrupt the heap.
	Com_TouchMemory();
	Z_CheckHeap();
}

int main( int argc, char **argv ) {
	(void)argc;
	(void)argv;

	printf( "Running ZEQ2-Lite memory allocator tests...\n" );

	// Q3_64BIT drives both the allocator ceilings and the VM struct padding,
	// so fail early if platform detection ever disagrees with the toolchain.
	CHECK( sizeof( void * ) == Q3_POINTER_SIZE,
		"Q3_64BIT does not match pointer size (%llu != %d)",
		(unsigned long long)sizeof( void * ), Q3_POINTER_SIZE );

	Com_InitSmallZoneMemory();
	Com_InitZoneMemory();
	TestZoneBasic();
	TestZoneStress();
	TestZoneTags();
	TestHunk();

	if ( failures ) {
		printf( "%d memory allocator test(s) FAILED\n", failures );
		return 1;
	}
	printf( "All memory allocator tests passed.\n" );
	return 0;
}
