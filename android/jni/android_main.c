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
/* Bumped when the extraction logic or the bundled asset set changes. */
#define ASSET_VERSION_MARKER "zeq2_assets_v2"

/*
 * Join an asset manager path without introducing a leading slash.  Asset
 * manager names are always relative to the APK's assets/ directory; "/name"
 * is not the same asset as "name" and fails to open.
 */
static void Android_JoinPath( char *out, size_t size, const char *dir, const char *name )
{
	size_t len = strlen( dir );

	Q_snprintf( out, size, "%s%s%s", dir,
		( len > 0 && dir[ len - 1 ] != '/' ) ? "/" : "", name );
}

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

static qboolean Android_WriteAssetHandle( AAsset *asset, const char *destination )
{
	FILE *out;
	char buffer[ 16384 ];
	int readBytes;
	int chunks = 0;

	Android_Mkdir( destination );

	out = fopen( destination, "wb" );
	if ( !out ) {
		return qfalse;
	}

	while ( ( readBytes = AAsset_read( asset, buffer, sizeof( buffer ) ) ) > 0 ) {
		if ( fwrite( buffer, 1, readBytes, out ) != (size_t)readBytes ) {
			fclose( out );
			return qfalse;
		}

		/* The UI thread waits for the NativeActivity looper while the native
		 * thread extracts assets.  Keep draining it so a large bundled pk3
		 * cannot turn into an "app not responding" dialog. */
		if ( ( ++chunks & 15 ) == 0 ) {
			Android_PumpEvents();
			if ( Android_IsDestroyed() ) {
				fclose( out );
				return qfalse;
			}
		}
	}

	fclose( out );
	return readBytes >= 0;
}

static qboolean Android_ExtractDir( AAssetManager *manager, const char *assetDir,
	const char *destinationDir )
{
	AAssetDir *dir;
	const char *name;
	char childAsset[ PATH_MAX ];
	char childDest[ PATH_MAX ];
	qboolean ok = qtrue;

	dir = AAssetManager_openDir( manager, assetDir );
	if ( !dir ) {
		return qfalse;
	}

	Android_Mkdir( destinationDir );

	while ( ( name = AAssetDir_getNextFileName( dir ) ) != NULL ) {
		AAsset *asset;
		AAssetDir *childDir;

		if ( !name || !*name || strchr( name, '/' ) ) {
			continue;
		}

		Android_JoinPath( childAsset, sizeof( childAsset ), assetDir, name );
		Android_JoinPath( childDest, sizeof( childDest ), destinationDir, name );

		Android_PumpEvents();
		if ( Android_IsDestroyed() ) {
			ok = qfalse;
			break;
		}

		/* Check for a file first: AAssetManager_openDir() also returns a
		 * non-NULL handle for some file paths, which used to make the old
		 * recursion silently skip every bundled asset. */
		asset = AAssetManager_open( manager, childAsset, AASSET_MODE_UNKNOWN );
		if ( asset ) {
			if ( !Android_WriteAssetHandle( asset, childDest ) ) {
				__android_log_print( ANDROID_LOG_WARN, ANDROID_MAIN_LOG_TAG,
					"failed to extract asset %s", childAsset );
				ok = qfalse;
			}
			AAsset_close( asset );
			continue;
		}

		childDir = AAssetManager_openDir( manager, childAsset );
		if ( childDir ) {
			AAssetDir_close( childDir );
			if ( !Android_ExtractDir( manager, childAsset, childDest ) ) {
				ok = qfalse;
			}
		} else {
			__android_log_print( ANDROID_LOG_WARN, ANDROID_MAIN_LOG_TAG,
				"failed to open asset %s", childAsset );
			ok = qfalse;
		}
	}

	AAssetDir_close( dir );
	return ok;
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
	if ( !Android_ExtractDir( app->activity->assetManager, "", dataPath ) ) {
		__android_log_print( ANDROID_LOG_WARN, ANDROID_MAIN_LOG_TAG,
			"asset extraction was incomplete; it will be retried" );
		return;
	}

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
	if ( Android_IsDestroyed() ) {
		return;
	}

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
