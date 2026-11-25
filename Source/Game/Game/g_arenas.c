/*
===========================================================================
Copyright (C) 1999-2005 Id Software, Inc.

This file is part of Quake III Arena source code.

Quake III Arena source code is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation; either version 2 of the License,
or (at your option) any later version.

Quake III Arena source code is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Quake III Arena source code; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
===========================================================================
*/
//
//
// g_arenas.c
//

#include "g_local.h"


gentity_t	*podium1;
gentity_t	*podium2;
gentity_t	*podium3;


/*
==================
UpdateTournamentInfo
==================
*/
void UpdateTournamentInfo( void ) {
	int			i;
	gentity_t	*player;
	int			playerClientNum;
#ifdef MISSIONPACK
  int score1, score2;
	qboolean won;
#endif
	char		msg[MAX_STRING_CHARS];

	// find the real player
	player = NULL;
	for (i = 0; i < level.maxclients; i++ ) {
		player = &g_entities[i];
		if ( !player->inuse ) {
			continue;
		}
		if ( !( player->r.svFlags & SVF_BOT ) ) {
			break;
		}
	}
	// this should never happen!
	if ( !player || i == level.maxclients ) {
		return;
	}
	playerClientNum = i;

	CalculateRanks();

	if ( level.clients[playerClientNum].sess.sessionTeam == TEAM_SPECTATOR ) {
		Com_sprintf( msg, sizeof(msg), "postgame %i %i 0 0 0 0 0 0", level.numNonSpectatorClients, playerClientNum );
	}
	trap_SendConsoleCommand( EXEC_APPEND, msg );
}


static void CelebrateStop( gentity_t *player ) {
	int		anim;
	anim = ANIM_IDLE;
	player->s.torsoAnim = ( ( player->s.torsoAnim & ANIM_TOGGLEBIT ) ^ ANIM_TOGGLEBIT ) | anim;
}


/*
==================
SpawnModelsOnVictoryPads
==================
*/
void SpawnModelsOnVictoryPads( void ) {}


/*
===============
Svcmd_AbortPodium_f
===============
*/
void Svcmd_AbortPodium_f( void ) {
	if( g_gametype.integer != GT_SINGLE_PLAYER ) {
		return;
	}

	if( podium1 ) {
		podium1->nextthink = level.time;
		podium1->think = CelebrateStop;
	}
}
