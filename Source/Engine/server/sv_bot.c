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
// sv_bot.c

#include "server.h"
#include "../botlib/botlib.h"

typedef struct bot_debugpoly_s
{
	int inuse;
	int color;
	int numPoints;
	vec3_t points[128];
} bot_debugpoly_t;

static bot_debugpoly_t *debugpolygons;
int bot_maxdebugpolys;

extern botlib_export_t	*botlib_export;
int	bot_enable;


/*
==================
SV_BotAllocateClient
==================
*/
int SV_BotAllocateClient(void) {
	int			i;
	client_t	*cl;

	// find a client slot
	for ( i = 0, cl = svs.clients; i < sv_maxclients->integer; i++, cl++ ) {
		if ( cl->state == CS_FREE ) {
			break;
		}
	}

	if ( i == sv_maxclients->integer ) {
		return -1;
	}

	cl->gentity = SV_GentityNum( i );
	cl->gentity->s.number = i;
	cl->state = CS_ACTIVE;
	cl->lastPacketTime = svs.time;
	cl->netchan.remoteAddress.type = NA_BOT;
	cl->rate = 16384;

	return i;
}

/*
==================
SV_BotFreeClient
==================
*/
void SV_BotFreeClient( int clientNum ) {
	client_t	*cl;

	if ( clientNum < 0 || clientNum >= sv_maxclients->integer ) {
		Com_Error( ERR_DROP, "SV_BotFreeClient: bad clientNum: %i", clientNum );
	}
	cl = &svs.clients[clientNum];
	cl->state = CS_FREE;
	cl->name[0] = 0;
	if ( cl->gentity ) {
		cl->gentity->r.svFlags &= ~SVF_BOT;
	}
}

/*
==================
BotDrawDebugPolygons
==================
*/
void BotDrawDebugPolygons(void (*drawPoly)(int color, int numPoints, float *points), int value) {
	static cvar_t *bot_debug, *bot_groundonly, *bot_reachability, *bot_highlightarea;
	bot_debugpoly_t *poly;
	int i, parm0;

	if (!debugpolygons)
		return;
	//bot debugging
	if (!bot_debug) bot_debug = Cvar_Get("bot_debug", "0", 0);
	//
	if (bot_enable && bot_debug->integer) {
		//show reachabilities
		if (!bot_reachability) bot_reachability = Cvar_Get("bot_reachability", "0", 0);
		//show ground faces only
		if (!bot_groundonly) bot_groundonly = Cvar_Get("bot_groundonly", "1", 0);
		//get the hightlight area
		if (!bot_highlightarea) bot_highlightarea = Cvar_Get("bot_highlightarea", "0", 0);
		//
		parm0 = 0;
		if (svs.clients[0].lastUsercmd.buttons & BUTTON_ATTACK) parm0 |= 1;
		if (bot_reachability->integer) parm0 |= 2;
		if (bot_groundonly->integer) parm0 |= 4;
		botlib_export->BotLibVarSet("bot_highlightarea", bot_highlightarea->string);
		botlib_export->Test(parm0, NULL, svs.clients[0].gentity->r.currentOrigin, 
			svs.clients[0].gentity->r.currentAngles);
	} //end if
	//draw all debug polys
	for (i = 0; i < bot_maxdebugpolys; i++) {
		poly = &debugpolygons[i];
		if (!poly->inuse) continue;
		drawPoly(poly->color, poly->numPoints, (float *) poly->points);
		//Com_Printf("poly %i, numpoints = %d\n", i, poly->numPoints);
	}
}

/*
==================
BotImport_DebugPolygonCreate
==================
*/
int BotImport_DebugPolygonCreate(int color, int numPoints, vec3_t *points) {
	bot_debugpoly_t *poly;
	int i;

	if (!debugpolygons)
		return 0;

	for (i = 1; i < bot_maxdebugpolys; i++) 	{
		if (!debugpolygons[i].inuse)
			break;
	}
	if (i >= bot_maxdebugpolys)
		return 0;
	poly = &debugpolygons[i];
	poly->inuse = qtrue;
	poly->color = color;
	poly->numPoints = numPoints;
	Com_Memcpy(poly->points, points, numPoints * sizeof(vec3_t));
	//
	return i;
}

/*
==================
BotImport_DebugPolygonDelete
==================
*/
void BotImport_DebugPolygonDelete(int id)
{
	if (!debugpolygons) return;
	debugpolygons[id].inuse = qfalse;
}

/*
==================
SV_BotFrame
==================
*/
void SV_BotFrame( int time ) {
	if (!bot_enable) return;
	//NOTE: maybe the game is already shutdown
	if (!gvm) return;
	VM_Call( gvm, BOTAI_START_FRAME, time );
}

/*
===============
SV_BotLibSetup
===============
*/
int SV_BotLibSetup( void ) {
	if (!bot_enable) {
		return 0;
	}

	if ( !botlib_export ) {
		Com_Printf( S_COLOR_RED "Error: SV_BotLibSetup without SV_BotInitBotLib\n" );
		return -1;
	}

	return botlib_export->BotLibSetup();
}

/*
===============
SV_ShutdownBotLib

Called when either the entire server is being killed, or
it is changing to a different game directory.
===============
*/
int SV_BotLibShutdown( void ) {

	if ( !botlib_export ) {
		return -1;
	}

	return botlib_export->BotLibShutdown();
}

/*
==================
SV_BotInitCvars
==================
*/
void SV_BotInitCvars(void) {

	Cvar_Get("bot_enable", "1", 0);						//enable the bot
	Cvar_Get("bot_developer", "0", CVAR_CHEAT);			//bot developer mode
	Cvar_Get("bot_debug", "0", CVAR_CHEAT);				//enable bot debugging
	Cvar_Get("bot_maxdebugpolys", "2", 0);				//maximum number of debug polys
	Cvar_Get("bot_groundonly", "1", 0);					//only show ground faces of areas
	Cvar_Get("bot_reachability", "0", 0);				//show all reachabilities to other areas
	Cvar_Get("bot_visualizejumppads", "0", CVAR_CHEAT);	//show jumppads
	Cvar_Get("bot_forceclustering", "0", 0);			//force cluster calculations
	Cvar_Get("bot_forcereachability", "0", 0);			//force reachability calculations
	Cvar_Get("bot_forcewrite", "0", 0);					//force writing aas file
	Cvar_Get("bot_aasoptimize", "0", 0);				//no aas file optimisation
	Cvar_Get("bot_saveroutingcache", "0", 0);			//save routing cache
	Cvar_Get("bot_thinktime", "100", CVAR_CHEAT);		//msec the bots thinks
	Cvar_Get("bot_reloadcharacters", "0", 0);			//reload the bot characters each time
	Cvar_Get("bot_testichat", "0", 0);					//test ichats
	Cvar_Get("bot_testrchat", "0", 0);					//test rchats
	Cvar_Get("bot_testsolid", "0", CVAR_CHEAT);			//test for solid areas
	Cvar_Get("bot_testclusters", "0", CVAR_CHEAT);		//test the AAS clusters
	Cvar_Get("bot_fastchat", "0", 0);					//fast chatting bots
	Cvar_Get("bot_nochat", "0", 0);						//disable chats
	Cvar_Get("bot_pause", "0", CVAR_CHEAT);				//pause the bots thinking
	Cvar_Get("bot_report", "0", CVAR_CHEAT);			//get a full report in ctf
	Cvar_Get("bot_grapple", "0", 0);					//enable grapple
	Cvar_Get("bot_rocketjump", "1", 0);					//enable rocket jumping
	Cvar_Get("bot_challenge", "0", 0);					//challenging bot
	Cvar_Get("bot_minplayers", "0", 0);					//minimum players in a team or the game
	Cvar_Get("bot_interbreedchar", "", CVAR_CHEAT);		//bot character used for interbreeding
	Cvar_Get("bot_interbreedbots", "10", CVAR_CHEAT);	//number of bots used for interbreeding
	Cvar_Get("bot_interbreedcycle", "20", CVAR_CHEAT);	//bot interbreeding cycle
	Cvar_Get("bot_interbreedwrite", "", CVAR_CHEAT);	//write interbreeded bots to this file
}

/*
==================
SV_BotInitBotLib
==================
*/
void SV_BotInitBotLib(void) {
	if (debugpolygons) Z_Free(debugpolygons);
	bot_maxdebugpolys = Cvar_VariableIntegerValue("bot_maxdebugpolys");
	debugpolygons = Z_Malloc(sizeof(bot_debugpoly_t) * bot_maxdebugpolys);

	// GetBotLibAPI is not called in this build, so there is no import
	// structure to populate here.
}


//
//  * * * BOT AI CODE IS BELOW THIS POINT * * *
//

/*
==================
SV_BotGetConsoleMessage
==================
*/
int SV_BotGetConsoleMessage( int client, char *buf, int size )
{
	client_t	*cl;
	int			index;

	cl = &svs.clients[client];
	cl->lastPacketTime = svs.time;

	if ( cl->reliableAcknowledge == cl->reliableSequence ) {
		return qfalse;
	}

	cl->reliableAcknowledge++;
	index = cl->reliableAcknowledge & ( MAX_RELIABLE_COMMANDS - 1 );

	if ( !cl->reliableCommands[index][0] ) {
		return qfalse;
	}

	Q_strncpyz( buf, cl->reliableCommands[index], size );
	return qtrue;
}

#if 0
/*
==================
EntityInPVS
==================
*/
int EntityInPVS( int client, int entityNum ) {
	client_t			*cl;
	clientSnapshot_t	*frame;
	int					i;

	cl = &svs.clients[client];
	frame = &cl->frames[cl->netchan.outgoingSequence & PACKET_MASK];
	for ( i = 0; i < frame->num_entities; i++ )	{
		if ( svs.snapshotEntities[(frame->first_entity + i) % svs.numSnapshotEntities].number == entityNum ) {
			return qtrue;
		}
	}
	return qfalse;
}
#endif

/*
==================
SV_BotGetSnapshotEntity
==================
*/
int SV_BotGetSnapshotEntity( int client, int sequence ) {
	client_t			*cl;
	clientSnapshot_t	*frame;

	cl = &svs.clients[client];
	frame = &cl->frames[cl->netchan.outgoingSequence & PACKET_MASK];
	if (sequence < 0 || sequence >= frame->num_entities) {
		return -1;
	}
	return svs.snapshotEntities[(frame->first_entity + sequence) % svs.numSnapshotEntities].number;
}

