# ZEQ2-Lite for Android

This directory contains a NativeActivity-based Android port.  It needs no Java
source and no Gradle/Android Plugin: `build.sh android` cross-compiles the
engine with the NDK and assembles a signed APK with the Android SDK tools.

## Build

```sh
./build.sh android
```

The resulting APK is written to:

```
Source/Build/Android/ZEQ2-Lite-debug.apk
```

Environment overrides:

- `ANDROID_HOME` (default `/usr/local/lib/android/sdk`)
- `ANDROID_NDK` (default `/usr/local/lib/android/sdk/ndk/27.3.13750724`)
- `ANDROID_HOST_TAG` (default `linux-x86_64`)
- `ANDROID_PLATFORM` / `ANDROID_BUILD_TOOLS` (defaults `android-35` / `35.0.0`)
- `ANDROID_ABIS` (default `arm64-v8a`)
- `JOBS`

The build script also builds the game QVMs with the host compiler and packages
them as assets.  On first launch the native activity extracts all bundled
assets into the application's private data directory and points
`fs_basepath`/`fs_homepath` at it.  Extraction keeps draining the NativeActivity
looper so a slow device (or a large bundled `.pk3`) cannot trigger an
"app isn't responding" dialog before the engine starts.  The marker file is
written only after every asset was extracted successfully.

## Game data

This repository does not contain ZEQ2's `.pk3`/map data, so the APK is
technically complete but cannot run an actual match until game data is added.
To include your own data, copy `.pk3` files into `android/assets/ZEQ2/` before
running `./build.sh android`.  The asset-version marker is bumped in
`android/jni/android_main.c` when bundled asset contents change; increment it
so existing installations re-extract the assets.

## Touch controls

The packaged layout is in `assets/ZEQ2/touch_layout.cfg`:

- left stick: forward/back/strafe
- right stick: view/look (`SE_MOUSE` relative motion)
- buttons: primary attack, jump, alternate attack, speed/dash

Bindings that match the layout are installed from `assets/ZEQ2/default.cfg`.

In-game commands:

- `touch_layout_edit` — toggle the on-screen layout editor
- `touch_layout_add button|stick [key]` — add a control
- `touch_bind <index> <key> [slot]` — change a binding (e.g. `MOUSE1`, `JOY1`)
- `touch_layout_save` / `touch_layout_load` / `touch_layout_reset`
- `touch_enable`, `touch_opacity`, `touch_lookSensitivity`

The editor has a touch-only BIND mode that cycles a control's primary key
without needing a hardware keyboard or console.

## Implementation notes

- Graphics use native EGL + OpenGL ES 1.x.  A small compatibility header maps
  desktop GL names and implements the immediate-mode subset used by the old
  renderer and the touch overlay.  `GLimp_Init` installs the renderer's runtime
  `qgl` dispatch table after the EGL context is current; without it the first
  `qgl*` call dereferenced a NULL pointer and killed startup.
- Fatal signals on Android exit directly instead of running the full engine
  shutdown from a signal handler, which could deadlock against the UI thread
  waiting on NativeActivity's looper.
- Input comes from NativeActivity: touch pointers feed the shared touch layer,
  while hardware keyboards/mice feed the normal `SE_KEY`/`SE_MOUSE` queue.
- Audio starts with a null DMA backend, so the game runs without sound while a
  real OpenSL ES/AAudio backend can be added later.
- Mumble and VoIP are disabled in Android builds.
- The native library exports `android_main` and `ANativeActivity_onCreate`;
  `native_app_glue` is linked from the installed NDK.
