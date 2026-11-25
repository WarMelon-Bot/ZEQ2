/*
 * ZEQ2-Lite Android NativeActivity entry point.
 *
 * No Java source or Gradle plugin is required: the APK manifest loads
 * libzeq2.so and calls android_main().  Bundled engine assets are extracted to
 * the app's private data directory before Quake's filesystem starts, then the
 * regular Sys_EngineMain() startup path is used verbatim.
 */

#include "../../Engine/sys/sys_local.h"
#include "android_local.h"

#include <android/asset_manager.h>
#include <android/log.h>
#include <android_native_app_glue.h>

#include <errno.h>
#include <limits.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <unistd.h>

#define ANDROID_MAIN_LOG_TAG "ZEQ2"
#define ASSET_VERSION_MARKER "zeq2_assets_v1"

static void Android_Mkdir( const char *path )
{
	char buffer[ PATH_MAX ];
	char *p;
	size_t len = strlen( path );

	if ( len == 0 || len >= sizeof( buffer ) ) {
		return;
	}
	Q_strncpyz( buffer, path, sizeof( buffer ) );

	for ( p = buffer + 1; *p; p++ ) {
		if ( *p == '/' ) {
			*p = '\0';
			mkdir( buffer, 0777 );
			*p = '/';
		}
	}
	mkdir( buffer, 0777 );
}

static qboolean Android_WriteAsset( AAssetManager *manager, const char *relative,
	const char *destination )
{
	AAsset *asset;
	FILE *out;
	char buffer[ 16384 ];
	int readBytes;

	Android_Mkdir( destination );

	asset = AAssetManager_open( manager, relative, AASSET_MODE_STREAMING );
	if ( !asset ) {
		return qfalse;
	}

	out = fopen( destination, "wb" );
	if ( !out ) {
		AAsset_close( asset );
		return qfalse;
	}

	while ( ( readBytes = AAsset_read( asset, buffer, sizeof( buffer ) ) ) > 0 ) {
		if ( fwrite( buffer, 1, readBytes, out ) != (size_t)readBytes ) {
			fclose( out );
			AAsset_close( asset );
			return qfalse;
		}
	}

	fclose( out );
	AAsset_close( asset );
	return qtrue;
}

static void Android_ExtractDir( AAssetManager *manager, const char *assetDir,
	const char *destinationDir )
{
	AAssetDir *dir;
	const char *name;
	char childAsset[ PATH_MAX ];
	char childDest[ PATH_MAX ];

	dir = AAssetManager_openDir( manager, assetDir );
	if ( !dir ) {
		return;
	}

	Android_Mkdir( destinationDir );

	while ( ( name = AAssetDir_getNextFileName( dir ) ) != NULL ) {
		AAssetDir *childDir;

		if ( !name || !*name || strchr( name, '/' ) ) {
			continue;
		}

		Q_snprintf( childAsset, sizeof( childAsset ), "%s%s%s",
			assetDir, ( *assetDir && assetDir[strlen( assetDir ) - 1] == '/' ) ? "" : "/", name );
		Q_snprintf( childDest, sizeof( childDest ), "%s/%s", destinationDir, name );

		childDir = AAssetManager_openDir( manager, childAsset );
		if ( childDir ) {
			AAssetDir_close( childDir );
			Android_ExtractDir( manager, childAsset, childDest );
		} else if ( !Android_WriteAsset( manager, childAsset, childDest ) ) {
			__android_log_print( ANDROID_LOG_WARN, ANDROID_MAIN_LOG_TAG,
				"failed to extract asset %s", childAsset );
		}
	}

	AAssetDir_close( dir );
}

static void Android_ExtractAssets( struct android_app *app )
{
	char marker[ PATH_MAX ];
	FILE *f;
	const char *dataPath = app->activity->internalDataPath;

	if ( !dataPath || !*dataPath ) {
		return;
	}

	Android_Mkdir( dataPath );
	Q_snprintf( marker, sizeof( marker ), "%s/%s", dataPath, ASSET_VERSION_MARKER );

	if ( access( marker, F_OK ) == 0 ) {
		return;
	}

	__android_log_print( ANDROID_LOG_INFO, ANDROID_MAIN_LOG_TAG,
		"extracting bundled assets to %s", dataPath );
	Android_ExtractDir( app->activity->assetManager, "", dataPath );

	f = fopen( marker, "wb" );
	if ( f ) {
		fputs( "1\n", f );
		fclose( f );
	}
}

void android_main( struct android_app *app )
{
	char dataPath[ PATH_MAX ];
	char *argv[ 32 ];
	int argc = 0;

	sys_androidApp = app;
	Android_InstallCallbacks();
	Android_ExtractAssets( app );

	Q_strncpyz( dataPath, app->activity->internalDataPath, sizeof( dataPath ) );
	if ( !dataPath[0] ) {
		Q_strncpyz( dataPath, "/data/local/tmp/ZEQ2", sizeof( dataPath ) );
		Android_Mkdir( dataPath );
	}

	/* Make the filesystem and temp-file paths Android friendly. */
	setenv( "HOME", dataPath, 1 );
	setenv( "TMPDIR", dataPath, 1 );
	setenv( "ZEQ2_HOME", dataPath, 1 );
	setenv( "ZEQ2_TMPDIR", dataPath, 1 );
	chdir( dataPath );

	argv[argc++] = "ZEQ2";
	argv[argc++] = "+set"; argv[argc++] = "fs_basepath"; argv[argc++] = dataPath;
	argv[argc++] = "+set"; argv[argc++] = "fs_homepath"; argv[argc++] = dataPath;
	argv[argc++] = "+set"; argv[argc++] = "vm_game"; argv[argc++] = "2";
	argv[argc++] = "+set"; argv[argc++] = "vm_cgame"; argv[argc++] = "2";
	argv[argc++] = "+set"; argv[argc++] = "vm_ui"; argv[argc++] = "2";
	argv[argc++] = "+set"; argv[argc++] = "r_fullscreen"; argv[argc++] = "1";
	argv[argc++] = "+set"; argv[argc++] = "touch_enable"; argv[argc++] = "1";
	argv[argc++] = "+exec"; argv[argc++] = "zeq2_android.cfg";
	argv[argc] = NULL;

	Sys_EngineMain( argc, argv );
}
