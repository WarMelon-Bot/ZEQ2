/*
 * Regression tests for the join-time snapshot path.
 *
 * sv_snapshot.c is included directly so the tests exercise the real snapshot
 * builder.  The collision-detection entry points are stubbed and counted:
 * a PVS/entity walk for a client that has not entered the world is both
 * wasted work and the cause of "Hitch warning" stalls during client joins.
 */

#include <stdio.h>
#include <stdlib.h>

static int pvsCalls;

#include "../Engine/server/sv_snapshot.c"

static int failures;

#define CHECK( condition, message ) \
	do { \
		if ( !(condition) ) { \
			printf( "FAIL: %s\n", (message) ); \
			failures++; \
		} \
	} while ( 0 )

// ---------------------------------------------------------------------------
// Engine globals and stubs
// ---------------------------------------------------------------------------

server_t sv;
serverStatic_t svs;
cvar_t *sv_maxclients;
cvar_t *sv_maxRate;
cvar_t *sv_minRate;
cvar_t *sv_lanForceRate;
cvar_t *sv_fps;
cvar_t *sv_padPackets;
cvar_t *com_timescale;

static cvar_t padPacketsCvar = { 0 };

static playerState_t testPlayerstate;
static byte testClusterPVS[ 256 ];

void Com_DPrintf( const char *fmt, ... ) { (void)fmt; }
void Com_Printf( const char *fmt, ... ) { (void)fmt; }
void Com_Error( int level, const char *fmt, ... ) { (void)level; (void)fmt; }
void Cvar_Set( const char *name, const char *value ) { (void)name; (void)value; }
qboolean Sys_IsLANAddress( const netadr_t adr ) { (void)adr; return qfalse; }

void MSG_Init( msg_t *buf, byte *data, int length ) {
	Com_Memset( buf, 0, sizeof( *buf ) );
	buf->data = data;
	buf->maxsize = length;
}

void MSG_Clear( msg_t *buf ) { buf->cursize = 0; }

void MSG_WriteData( msg_t *buf, const void *data, int length ) {
	int i;
	const byte *bytes = (const byte *)data;

	for ( i = 0; i < length && buf->cursize < buf->maxsize; i++ ) {
		buf->data[buf->cursize++] = bytes[i];
	}
}

void MSG_WriteBits( msg_t *buf, int value, int bits ) {
	(void)buf; (void)value; (void)bits;
}

void MSG_WriteByte( msg_t *buf, int c ) {
	if ( buf->cursize < buf->maxsize ) {
		buf->data[buf->cursize++] = (byte)c;
	}
}

void MSG_WriteLong( msg_t *buf, int c ) {
	MSG_WriteByte( buf, c & 0xff );
	MSG_WriteByte( buf, ( c >> 8 ) & 0xff );
	MSG_WriteByte( buf, ( c >> 16 ) & 0xff );
	MSG_WriteByte( buf, ( c >> 24 ) & 0xff );
}

void MSG_WriteString( msg_t *buf, const char *s ) {
	while ( *s ) {
		MSG_WriteByte( buf, *s++ );
	}
	MSG_WriteByte( buf, 0 );
}

void MSG_WriteDeltaEntity( msg_t *msg, entityState_t *from, entityState_t *to, qboolean force ) {
	(void)msg; (void)from; (void)to; (void)force;
}

void MSG_WriteDeltaPlayerstate( msg_t *msg, playerState_t *from, playerState_t *to ) {
	(void)msg; (void)from; (void)to;
}

void SV_Netchan_Transmit( client_t *client, msg_t *msg ) { (void)client; (void)msg; }
void SV_Netchan_TransmitNextFragment( client_t *client ) { (void)client; }
void SV_WriteDownloadToClient( client_t *client, msg_t *msg ) { (void)client; (void)msg; }

playerState_t *SV_GameClientNum( int num ) {
	(void)num;
	return &testPlayerstate;
}

sharedEntity_t *SV_GentityNum( int num ) { (void)num; return NULL; }
svEntity_t *SV_SvEntityForGentity( sharedEntity_t *gEnt ) { (void)gEnt; return NULL; }

int CM_PointLeafnum( const vec3_t p ) {
	(void)p;
	pvsCalls++;
	return 0;
}

int CM_LeafArea( int leafnum ) { (void)leafnum; return 0; }
int CM_LeafCluster( int leafnum ) { (void)leafnum; return 0; }
int CM_WriteAreaBits( byte *buffer, int area ) { (void)buffer; (void)area; return 0; }
byte *CM_ClusterPVS( int cluster ) { (void)cluster; return testClusterPVS; }
qboolean CM_AreasConnected( int area1, int area2 ) { (void)area1; (void)area2; return qfalse; }

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

static void ResetWorld( void ) {
	Com_Memset( &sv, 0, sizeof( sv ) );
	Com_Memset( &svs, 0, sizeof( svs ) );
	Com_Memset( &testPlayerstate, 0, sizeof( testPlayerstate ) );
	Com_Memset( testClusterPVS, 0, sizeof( testClusterPVS ) );
	sv.state = SS_GAME;
	sv.num_entities = 0;
	sv_padPackets = &padPacketsCvar;
	svs.numSnapshotEntities = 64;
	svs.snapshotEntities = calloc( svs.numSnapshotEntities, sizeof( *svs.snapshotEntities ) );
	pvsCalls = 0;
}

static void TestConnectingClientsSkipPVS( void ) {
	static const int states[] = { CS_CONNECTED, CS_PRIMED, CS_ZOMBIE };
	int i;

	for ( i = 0; i < (int)( sizeof( states ) / sizeof( states[0] ) ); i++ ) {
		client_t client;
		clientSnapshot_t *frame;

		ResetWorld();
		Com_Memset( &client, 0, sizeof( client ) );
		client.state = states[i];
		client.gentity = (sharedEntity_t *)&client;	// any non-NULL entity
		svs.nextSnapshotEntities = 5;

		SV_BuildClientSnapshot( &client );

		frame = &client.frames[client.netchan.outgoingSequence & PACKET_MASK];
		CHECK( pvsCalls == 0, "connecting/zombie client still walks the PVS" );
		CHECK( frame->num_entities == 0, "connecting snapshot has entities" );
		CHECK( frame->first_entity == 5, "empty snapshot uses a stale entity range" );
		CHECK( frame->ps.clientNum == 0 && frame->ps.origin[0] == 0,
			"connecting snapshot encodes a stale playerstate" );
		CHECK( !( client.state == CS_ACTIVE && client.gentity != NULL ),
			"connecting client reported as active" );
	}

	free( svs.snapshotEntities );
}

static void TestActiveClientBuildsSnapshot( void ) {
	client_t client;
	clientSnapshot_t *frame;

	ResetWorld();
	Com_Memset( &client, 0, sizeof( client ) );
	client.state = CS_ACTIVE;
	client.gentity = (sharedEntity_t *)&client;
	testPlayerstate.clientNum = 3;
	VectorSet( testPlayerstate.origin, 10, 20, 30 );

	SV_BuildClientSnapshot( &client );

	frame = &client.frames[client.netchan.outgoingSequence & PACKET_MASK];
	CHECK( pvsCalls == 1, "active client did not use its viewpoint for visibility" );
	CHECK( frame->ps.clientNum == 3, "active client playerstate was not copied" );
	CHECK( frame->ps.origin[0] == 10 && frame->ps.origin[1] == 20,
		"active client viewpoint was not copied" );
	CHECK( client.state == CS_ACTIVE && client.gentity != NULL,
		"active client reported as inactive" );

	free( svs.snapshotEntities );
}

static void TestNotActiveFlagAndDelta( void ) {
	byte buffer[ 1024 ];
	msg_t msg;
	client_t client;
	clientSnapshot_t *frame;

	ResetWorld();
	Com_Memset( &client, 0, sizeof( client ) );
	client.state = CS_PRIMED;
	client.gentity = (sharedEntity_t *)&client;
	client.deltaMessage = 4;
	frame = &client.frames[client.netchan.outgoingSequence & PACKET_MASK];
	frame->num_entities = 0;

	MSG_Init( &msg, buffer, sizeof( buffer ) );
	SV_WriteSnapshotToClient( &client, &msg );

	CHECK( msg.cursize >= 7, "snapshot message was too short" );
	if ( msg.cursize >= 7 ) {
		CHECK( msg.data[0] == svc_snapshot, "missing svc_snapshot message" );
		CHECK( msg.data[5] == 0, "connecting snapshot was delta compressed" );
		CHECK( ( msg.data[6] & SNAPFLAG_NOT_ACTIVE ) != 0,
			"connecting snapshot is missing SNAPFLAG_NOT_ACTIVE" );
	}

	free( svs.snapshotEntities );
}

int main( void ) {
	TestConnectingClientsSkipPVS();
	TestActiveClientBuildsSnapshot();
	TestNotActiveFlagAndDelta();

	if ( failures ) {
		printf( "%d snapshot join regression check(s) failed\n", failures );
		return 1;
	}

	printf( "Snapshot join regression tests passed\n" );
	return 0;
}
