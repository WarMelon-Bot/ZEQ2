/* Typed engine symbol stubs for the standalone allocator tests. */

#include "q_shared.h"
#include "qcommon.h"

#define UNUSED( x ) ( (void)( x ) )

int cvar_modifiedFlags;
int c_traces;
int c_brush_traces;
int c_patch_traces;
int c_pointcontents;

void CL_CDDialog( void ) {}
void CL_CharEvent( int key ) { UNUSED( key ); }
void CL_Disconnect( qboolean showMainMenu ) { UNUSED( showMainMenu ); }
void CL_FlushMemory( void ) {}
void CL_InitKeyCommands( void ) {}
void CL_JoystickEvent( int axis, int value, int time ) {
	UNUSED( axis ); UNUSED( value ); UNUSED( time );
}
void CL_KeyEvent( int key, qboolean down, unsigned time ) {
	UNUSED( key ); UNUSED( down ); UNUSED( time );
}
void CL_MouseEvent( int dx, int dy, int time ) {
	UNUSED( dx ); UNUSED( dy ); UNUSED( time );
}
void CL_PacketEvent( netadr_t from, msg_t *msg ) { UNUSED( from ); UNUSED( msg ); }
void CL_Shutdown( char *finalmsg ) { UNUSED( finalmsg ); }
void CL_ShutdownAll( void ) {}
void CL_Snd_Restart( void ) {}
void CL_StartHunkUsers( qboolean rendererOnly ) { UNUSED( rendererOnly ); }
void COM_DefaultExtension( char *path, int maxSize, const char *extension ) {
	UNUSED( path ); UNUSED( maxSize ); UNUSED( extension );
}
void Cbuf_AddText( const char *text ) { UNUSED( text ); }
void Cbuf_Execute( void ) {}
void Cbuf_ExecuteText( int exec_when, const char *text ) {
	UNUSED( exec_when ); UNUSED( text );
}
void Cbuf_Init( void ) {}
int Cmd_Argc( void ) { return 0; }
char *Cmd_Args( void ) { return ""; }
char *Cmd_ArgsFrom( int arg ) { UNUSED( arg ); return ""; }
char *Cmd_Argv( int arg ) { UNUSED( arg ); return ""; }
void Cmd_CommandCompletion( void ( *callback )( const char *s ) ) { UNUSED( callback ); }
void Cmd_CompleteArgument( const char *command, char *args, int argNum ) {
	UNUSED( command ); UNUSED( args ); UNUSED( argNum );
}
void Cmd_CompleteCfgName( char *args, int argNum ) { UNUSED( args ); UNUSED( argNum ); }
void Cmd_Init( void ) {}
void Cmd_SetCommandCompletionFunc( const char *command, completionFunc_t complete ) {
	UNUSED( command ); UNUSED( complete );
}
void Cmd_TokenizeString( const char *text ) { UNUSED( text ); }
void Cmd_TokenizeStringIgnoreQuotes( const char *text_in ) { UNUSED( text_in ); }
char *Com_SkipCharset( char *s, char *sep ) { UNUSED( sep ); return s; }
void Com_TruncateLongString( char *buffer, const char *s ) { UNUSED( buffer ); UNUSED( s ); }
void QDECL Com_sprintf( char *dest, int size, const char *fmt, ... ) {
	UNUSED( dest ); UNUSED( size ); UNUSED( fmt );
}
void Cvar_CheckRange( cvar_t *cv, float minVal, float maxVal, qboolean shouldBeIntegral ) {
	UNUSED( cv ); UNUSED( minVal ); UNUSED( maxVal ); UNUSED( shouldBeIntegral );
}
void Cvar_CommandCompletion( void ( *callback )( const char *s ) ) { UNUSED( callback ); }
void Cvar_Init( void ) {}
void Cvar_Restart( qboolean unsetVM ) { UNUSED( unsetVM ); }
void Cvar_Set( const char *var_name, const char *value ) {
	UNUSED( var_name ); UNUSED( value );
}
void Cvar_SetValue( const char *var_name, float value ) {
	UNUSED( var_name ); UNUSED( value );
}
char *Cvar_VariableString( const char *var_name ) { UNUSED( var_name ); return ""; }
void Cvar_WriteVariables( fileHandle_t f ) { UNUSED( f ); }
void FS_FCloseFile( fileHandle_t f ) { UNUSED( f ); }
int FS_FOpenFileRead( const char *qpath, fileHandle_t *file, qboolean uniqueFILE ) {
	UNUSED( qpath ); UNUSED( file ); UNUSED( uniqueFILE );
	return -1;
}
fileHandle_t FS_FOpenFileWrite( const char *qpath ) { UNUSED( qpath ); return 0; }
void FS_FilenameCompletion( const char *dir, const char *ext, qboolean stripExt,
	void ( *callback )( const char *s ) ) {
	UNUSED( dir ); UNUSED( ext ); UNUSED( stripExt ); UNUSED( callback );
}
void FS_ForceFlush( fileHandle_t f ) { UNUSED( f ); }
void FS_InitFilesystem( void ) {}
qboolean FS_Initialized( void ) { return qfalse; }
void QDECL FS_Printf( fileHandle_t f, const char *fmt, ... ) {
	UNUSED( f ); UNUSED( fmt );
}
void FS_PureServerSetLoadedPaks( const char *pakSums, const char *pakNames ) {
	UNUSED( pakSums ); UNUSED( pakNames );
}
int FS_Read( void *buffer, int len, fileHandle_t f ) {
	UNUSED( buffer ); UNUSED( len ); UNUSED( f );
	return 0;
}
void FS_Restart( int checksumFeed ) { UNUSED( checksumFeed ); }
void FS_Shutdown( qboolean closemfp ) { UNUSED( closemfp ); }
int FS_Write( const void *buffer, int len, fileHandle_t f ) {
	UNUSED( buffer ); UNUSED( len ); UNUSED( f );
	return 0;
}
void Key_WriteBindings( fileHandle_t f ) { UNUSED( f ); }
void MSG_Init( msg_t *buf, byte *data, int length ) {
	UNUSED( buf ); UNUSED( data ); UNUSED( length );
}
void MSG_ReportChangeVectors_f( void ) {}
void NET_FlushPacketQueue( void ) {}
qboolean NET_GetLoopPacket( netsrc_t sock, netadr_t *net_from, msg_t *net_message ) {
	UNUSED( sock ); UNUSED( net_from ); UNUSED( net_message );
	return qfalse;
}
void Netchan_Init( int qport ) { UNUSED( qport ); }
float Q_random( int *seed ) { UNUSED( seed ); return 0.0f; }
void Q_strcat( char *dest, int size, const char *src ) {
	UNUSED( dest ); UNUSED( size ); UNUSED( src );
}
int Q_stricmp( const char *s1, const char *s2 ) { UNUSED( s1 ); UNUSED( s2 ); return 0; }
int Q_stricmpn( const char *s1, const char *s2, int n ) {
	UNUSED( s1 ); UNUSED( s2 ); UNUSED( n );
	return 0;
}
void Q_strncpyz( char *dest, const char *src, int destsize ) {
	UNUSED( dest ); UNUSED( src ); UNUSED( destsize );
}
void SV_Frame( int msec ) { UNUSED( msec ); }
void SV_Init( void ) {}
void SV_PacketEvent( netadr_t from, msg_t *msg ) { UNUSED( from ); UNUSED( msg ); }
void SV_Shutdown( char *finalmsg ) { UNUSED( finalmsg ); }
char *Sys_ConsoleInput( void ) { return NULL; }
qboolean Sys_GetPacket( netadr_t *net_from, msg_t *net_message ) {
	UNUSED( net_from ); UNUSED( net_message );
	return qfalse;
}
cpuFeatures_t Sys_GetProcessorFeatures( void ) { return (cpuFeatures_t)0; }
void Sys_Init( void ) {}
int Sys_Milliseconds( void ) { return 0; }
void Sys_Quit( void ) {}
qboolean Sys_RandomBytes( byte *string, int len ) {
	UNUSED( string ); UNUSED( len );
	return qfalse;
}
void Sys_SetEnv( const char *name, const char *value ) {
	UNUSED( name ); UNUSED( value );
}
void Sys_Sleep( int msec ) { UNUSED( msec ); }
void Sys_Yield( void ) {}
qboolean Sys_WritePIDFile( void ) { return qfalse; }
void VM_Forced_Unload_Done( void ) {}
void VM_Forced_Unload_Start( void ) {}
void VM_Init( void ) {}
char *QDECL va( char *format, ... ) { UNUSED( format ); return ""; }
