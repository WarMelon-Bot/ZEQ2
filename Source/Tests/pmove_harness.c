/*
 * Deterministic pmove regression harness.
 *
 * Drives the shared player movement, melee and weapon state machines with a
 * repeatable set of command sequences and prints a checksum of the resulting
 * player states.  Pointer fields are excluded from the checksum so the result
 * is stable across refactors.
 */

#include "../../Shared/q_shared.h"
#include "../../Shared/qcommon.h"
#include "../Game/bg_public.h"
#include "../Game/bg_local.h"
#include "../Game/bg_userweapons.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void QDECL Com_Printf( const char *fmt, ... ) {
	(void)fmt;
}

void QDECL Com_Error( int code, const char *fmt, ... ) {
	(void)code;
	(void)fmt;
	fprintf( stderr, "pmove harness: Com_Error called\n" );
	exit( 1 );
}

void trap_Cvar_VariableStringBuffer( const char *var_name, char *buffer, int bufsize ) {
	(void)var_name;
	if ( bufsize > 0 ) {
		buffer[0] = '\0';
	}
}

int trap_RealTime( qtime_t *qtime ) {
	memset( qtime, 0, sizeof( *qtime ) );
	qtime->tm_sec = 7;
	return 0;
}

void trap_SnapVector( float *v ) {
	v[0] = rintf( v[0] );
	v[1] = rintf( v[1] );
	v[2] = rintf( v[2] );
}

static void TestTrace( trace_t *results, const vec3_t start, const vec3_t mins,
		const vec3_t maxs, const vec3_t end, int passEntityNum, int contentMask ) {
	(void)start;
	(void)mins;
	(void)maxs;
	(void)end;
	(void)passEntityNum;
	(void)contentMask;
	memset( results, 0, sizeof( *results ) );
	results->fraction = 1.0f;
	results->entityNum = ENTITYNUM_NONE;
}

static int TestPointContents( const vec3_t point, int passEntityNum ) {
	(void)point;
	(void)passEntityNum;
	return 0;
}

static unsigned int HashPlayerState( const playerState_t *ps ) {
	playerState_t copy;
	const unsigned char *bytes;
	unsigned int hash = 2166136261u;
	size_t i;

	memcpy( &copy, ps, sizeof( copy ) );
	copy.lockedPlayer = NULL;
	copy.lockedPosition = NULL;
	bytes = (const unsigned char *)&copy;
	for ( i = 0; i < sizeof( copy ); i++ ) {
		hash ^= bytes[i];
		hash *= 16777619u;
	}
	return hash;
}

static void InitPlayer( playerState_t *ps, int clientNum ) {
	memset( ps, 0, sizeof( *ps ) );
	ps->clientNum = clientNum;
	ps->pm_type = PM_NORMAL;
	ps->groundEntityNum = ENTITYNUM_NONE;
	ps->weapon = 1;
	ps->weaponstate = WEAPON_READY;
	VectorSet( ps->viewangles, 0.0f, 0.0f, 0.0f );
	ps->powerLevel[plCurrent] = 5000;
	ps->powerLevel[plMaximum] = 10000;
	ps->powerLevel[plHealth] = 1000;
	ps->powerLevel[plFatigue] = 1000;
	ps->powerLevel[plMaximumPool] = 1000;
	ps->powerLevel[plHealthPool] = 1000;
	ps->baseStats[stEnergyAttackCost] = 1.0f;
	ps->stats[stMeleeAttack] = 1;
	ps->stats[stKnockbackPower] = 1;
	ps->stats[stSkills] = 0x3f;
	ps->powerups[PW_SKILLS] = USABLE_SKILL1 | USABLE_SKILL2 | USABLE_SKILL3 |
		USABLE_SKILL4 | USABLE_SKILL5 | USABLE_SKILL6;
	ps->currentSkill[WPSTAT_NUMCHECK] = 1;
	ps->currentSkill[WPSTAT_POWERLEVELCOST] = 10;
	ps->currentSkill[WPSTAT_CHRGTIME] = 100;
	ps->currentSkill[WPSTAT_COOLTIME] = 100;
	ps->currentSkill[WPSTAT_RESTRICT_MOVEMENT] = 0;
	ps->currentSkill[WPSTAT_BITFLAGS] = 0;
}

static void SetCommands( pmove_t *pmove, int frame, int pattern ) {
	pmove->cmd.buttons = 0;
	pmove->cmd.forwardmove = 0;
	pmove->cmd.rightmove = 0;
	pmove->cmd.upmove = 0;

	switch ( pattern ) {
	case 0:
		pmove->cmd.forwardmove = (frame % 9 < 4) ? 64 : ((frame % 9 > 6) ? -64 : 0);
		pmove->cmd.rightmove = (frame % 11 < 3) ? 32 : 0;
		pmove->cmd.upmove = (frame % 17 < 2) ? 32 : 0;
		if ( frame % 13 < 5 ) { pmove->cmd.buttons |= BUTTON_ATTACK; }
		else if ( frame % 13 < 8 ) { pmove->cmd.buttons |= BUTTON_ALT_ATTACK; }
		if ( frame % 23 == 3 ) { pmove->cmd.buttons |= BUTTON_BLOCK; }
		if ( frame % 19 == 5 ) { pmove->cmd.buttons |= BUTTON_GESTURE; }
		break;
	case 1:
		pmove->cmd.forwardmove = 64;
		if ( frame % 7 < 5 ) { pmove->cmd.buttons |= BUTTON_ATTACK; }
		if ( frame % 11 < 4 ) { pmove->cmd.buttons |= BUTTON_BLOCK; }
		break;
	case 2:
		pmove->cmd.forwardmove = -64;
		if ( frame % 5 < 3 ) { pmove->cmd.buttons |= BUTTON_BLOCK; }
		if ( frame % 17 == 2 ) { pmove->cmd.buttons |= BUTTON_GESTURE; }
		break;
	case 3:
		pmove->cmd.upmove = (frame % 4 < 2) ? 32 : ((frame % 4 == 2) ? -32 : 0);
		pmove->cmd.rightmove = (frame % 6 < 3) ? 32 : -32;
		if ( frame % 3 ) { pmove->cmd.buttons |= BUTTON_ALT_ATTACK; }
		break;
	case 4:
		pmove->cmd.forwardmove = (frame % 16 < 12) ? 64 : -64;
		if ( frame % 9 < 6 ) { pmove->cmd.buttons |= BUTTON_ATTACK; }
		else { pmove->cmd.buttons |= BUTTON_ALT_ATTACK; }
		pmove->cmd.buttons |= BUTTON_BLOCK;
		break;
	}
	pmove->cmd.weapon = 1 + (frame / 20) % 6;
	pmove->cmd.angles[1] = (float)(frame % 40) * 3.0f;
}

static void RunScenario( const char *name, qboolean melee, int psState, int enemyState,
		int psFlags, int enemyFlags, int boost, int pattern ) {
	playerState_t ps;
	playerState_t enemy;
	vec3_t enemyOrigin;
	pmove_t pmove;
	int frame;
	unsigned int hash = 2166136261u;

	InitPlayer( &ps, 0 );
	InitPlayer( &enemy, 1 );
	VectorSet( enemyOrigin, 32.0f, 0.0f, 0.0f );
	if ( melee ) {
		ps.lockedTarget = 1;
		ps.lockedPlayer = &enemy;
		ps.lockedPosition = (vec3_t *)enemyOrigin;
		enemy.lockedTarget = 2;
		enemy.lockedPlayer = &ps;
		enemy.lockedPosition = (vec3_t *)ps.origin;
		ps.bitFlags |= usingFlight;
		enemy.bitFlags |= usingFlight;
	}
	ps.bitFlags |= psFlags;
	enemy.bitFlags |= enemyFlags;
	ps.stats[stMeleeState] = psState;
	enemy.stats[stMeleeState] = enemyState;
	ps.timers[tmBoost] = boost;
	ps.timers[tmMeleeIdle] = 0;
	enemy.timers[tmMeleeIdle] = 0;

	memset( &pmove, 0, sizeof( pmove ) );
	pmove.ps = &ps;
	pmove.cmd.serverTime = 1000;
	pmove.tracemask = -1;
	pmove.trace = TestTrace;
	pmove.pointcontents = TestPointContents;
	VectorSet( pmove.mins, -15, -15, -24 );
	VectorSet( pmove.maxs, 15, 15, 24 );

	for ( frame = 0; frame < 240; frame++ ) {
		pmove.cmd.serverTime = 1000 + frame * 50;
		SetCommands( &pmove, frame, pattern );
		Pmove( &pmove );
		hash ^= HashPlayerState( &ps );
		hash *= 16777619u;
		hash ^= HashPlayerState( &enemy );
		hash *= 16777619u;
	}

	printf( "%s %08x\n", name, hash );
}

int main( void ) {
	RunScenario( "movement+weapons", qfalse, 0, 0, 0, 0, 0, 0 );
	RunScenario( "movement-alt", qfalse, 0, 0, 0, 0, 0, 4 );
	RunScenario( "melee", qtrue, 0, 0, 0, 0, 0, 0 );
	RunScenario( "melee-attack", qtrue, 0, stMeleeIdle, 0, 0, 0, 1 );
	RunScenario( "melee-evade", qtrue, stMeleeIdle, stMeleeAggressing, 0, 0, 0, 2 );
	RunScenario( "melee-power", qtrue, stMeleeChargingPower, stMeleeIdle, 0, usingBoost, 3000, 3 );
	RunScenario( "melee-stun", qtrue, stMeleeChargingStun, stMeleeUsingBlock, 0, 0, 0, 4 );
	RunScenario( "melee-breaker", qtrue, stMeleeUsingChargeBreaker, stMeleeUsingSpeed, 0, 0, 1000, 1 );
	RunScenario( "melee-block", qtrue, stMeleeUsingBlock, stMeleeUsingSpeedBreaker, usingBlock, usingBlock, 0, 2 );
	return 0;
}
