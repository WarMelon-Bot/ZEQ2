#!/usr/bin/env bash
#
# ZEQ2-Lite CLI build / run helper
#
#   ./build.sh                 build everything and smoke-test server + client
#   ./build.sh build           build release + debug targets
#   ./build.sh release         build only the optimized release target (fastest)
#   ./build.sh test            run allocator unit tests and smoke tests
#   ./build.sh memory-test     build and run just the allocator unit tests
#   ./build.sh warnings        clean rebuild that fails on any compiler warning
#   ./build.sh run [args...]   run the graphical client
#   ./build.sh smp [args...]   run the multi-threaded renderer client
#   ./build.sh server [args..] run the dedicated server
#   ./build.sh deps            check (and install) build dependencies
#   ./build.sh win64           cross-build the dedicated server and game DLL/QVMs for Windows x64
#   ./build.sh android         cross-build ARM Android clients and package a signed APK
#   ./build.sh clean           remove all build artifacts
#
# Environment overrides: JOBS, MAKE_ARGS, DEBIAN_FRONTEND, SDL_VIDEODRIVER,
#                        WIN64_CC, WIN64_WINDRES
#

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$ROOT/Source"
JOBS="${JOBS:-$(command -v nproc >/dev/null 2>&1 && nproc || echo 2)}"
MAKE_ARGS="${MAKE_ARGS:-}"
PROJECT="ZEQ2-Lite"

ANDROID_HOME="${ANDROID_HOME:-/usr/local/lib/android/sdk}"
ANDROID_NDK="${ANDROID_NDK:-/usr/local/lib/android/sdk/ndk/27.3.13750724}"
ANDROID_HOST_TAG="${ANDROID_HOST_TAG:-linux-x86_64}"
ANDROID_PLATFORM="${ANDROID_PLATFORM:-android-35}"
ANDROID_BUILD_TOOLS="${ANDROID_BUILD_TOOLS:-35.0.0}"
ANDROID_ABIS="${ANDROID_ABIS:-arm64-v8a armeabi-v7a}"
ANDROID_MIN_SDK=24
ANDROID_TARGET_SDK=35

log() { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2; }
die() { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

ARCH="$(uname -m | sed -e 's/i.86/i386/')"
PLATFORM="$(uname | tr '[:upper:]' '[:lower:]' | sed -e 's/_.*//')"
RELEASE_DIR="$SOURCE_DIR/Build/Release-${PLATFORM}-${ARCH}"
DEBUG_DIR="$SOURCE_DIR/Build/Debug-${PLATFORM}-${ARCH}"
TEST_DIR="$SOURCE_DIR/Build/Tests"

APT_PACKAGES="build-essential ccache pkg-config libsdl1.2-dev libgl1-mesa-dev libcurl4-openssl-dev libopenal-dev libvorbis-dev"

# ---------------------------------------------------------------------------
# Dependency handling
# ---------------------------------------------------------------------------

missing=()

check_deps() {
    missing=()
    local cmd
    for cmd in gcc make pkg-config; do
        command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
    done

    local module
    for module in sdl gl libcurl openal vorbisfile; do
        if ! pkg-config --exists "$module" 2>/dev/null; then
            if [[ "$module" == "sdl" ]] && command -v sdl-config >/dev/null 2>&1; then
                continue
            fi
            missing+=("pkg-config($module)")
        fi
    done

    if ((${#missing[@]} == 0)); then
        log "All build dependencies are present."
        return 0
    fi

    warn "Missing build dependencies: ${missing[*]}"
    return 1
}

install_deps() {
    command -v apt-get >/dev/null 2>&1 || die "Automatic dependency installation requires apt-get. Install: $APT_PACKAGES"

    local sudo_cmd=""
    if ((EUID != 0)); then
        command -v sudo >/dev/null 2>&1 || die "Run as root or install these packages: $APT_PACKAGES"
        sudo_cmd="sudo"
    fi

    log "Installing build dependencies: $APT_PACKAGES"
    DEBIAN_FRONTEND=noninteractive $sudo_cmd apt-get update -qq
    DEBIAN_FRONTEND=noninteractive $sudo_cmd apt-get install -y -qq $APT_PACKAGES
}

ensure_deps() {
    check_deps || install_deps
    check_deps || die "Dependencies are still missing after installation."
}

# ---------------------------------------------------------------------------
# Build helpers
# ---------------------------------------------------------------------------

verify_release_artifacts() {
    local -a artifacts=("$RELEASE_DIR/ZEQ2.$ARCH" "$RELEASE_DIR/ZEQ2Dedicated.$ARCH")
    if [[ "$PLATFORM" == linux || "$PLATFORM" == darwin ]]; then
        artifacts+=("$RELEASE_DIR/ZEQ2-smp.$ARCH")
    fi

    local artifact
    for artifact in "${artifacts[@]}"; do
        [[ -f "$artifact" ]] || die "Expected artifact was not built: $artifact"
    done
}

build_all() {
    log "Building release and debug in one parallel make invocation..."
    make -C "$SOURCE_DIR" release debug -j"$JOBS" USE_LOCAL_HEADERS=0 $MAKE_ARGS
    prepare_runtime "$RELEASE_DIR"
    verify_release_artifacts
    log "Build complete. Release artifacts are in $RELEASE_DIR"
}

build_release() {
    log "Building release (client, dedicated server, game modules and QVMs)..."
    make -C "$SOURCE_DIR" release -j"$JOBS" USE_LOCAL_HEADERS=0 $MAKE_ARGS
    prepare_runtime "$RELEASE_DIR"
    verify_release_artifacts
    log "Release build complete. Artifacts are in $RELEASE_DIR"
}

warnings_check() (
    local tmp_dir logfile count status=0
    tmp_dir="$(mktemp -d)"
    logfile="$tmp_dir/build.log"
    trap 'rm -rf "$tmp_dir"' EXIT

    # Build both configurations in a private directory so every translation
    # unit is compiled even when a normal incremental build would be up to date.
    log "Clean rebuild in $tmp_dir; any compiler warning is a failure..."
    make -C "$SOURCE_DIR" BUILD_DIR="$tmp_dir" release debug \
        -j"$JOBS" USE_LOCAL_HEADERS=0 $MAKE_ARGS >"$logfile" 2>&1 || status=$?

    if ((status != 0)); then
        cat "$logfile" >&2
        die "Warning check build failed with status $status."
    fi

    count="$(grep -c -E 'warning:|error:' "$logfile" || true)"
    if ((count > 0)); then
        log "Compiler diagnostics found ($count):"
        grep -E 'warning:|error:' "$logfile" | sort -u | head -100 >&2
        die "Warning check failed: $count compiler diagnostics."
    fi

    log "Warning check passed: release and debug compiled with no diagnostics."
)

build_win64() {
    local cc="${WIN64_CC:-x86_64-w64-mingw32-gcc}"
    local windres="${WIN64_WINDRES:-x86_64-w64-mingw32-windres}"
    local out_dir="$SOURCE_DIR/Build/Release-mingw32-x86_64"

    command -v "$cc" >/dev/null 2>&1 || die "Windows x64 cross-compiler '$cc' not found. Install mingw-w64 or set WIN64_CC."
    command -v "$windres" >/dev/null 2>&1 || die "Windows x64 resource compiler '$windres' not found. Install mingw-w64 or set WIN64_WINDRES."

    log "Cross-building Windows x64 dedicated server, game DLLs and QVMs..."
    make -C "$SOURCE_DIR" \
        PLATFORM=mingw32 ARCH=x86_64 CC="$cc" WINDRES="$windres" \
        USE_LOCAL_HEADERS=0 BUILD_CLIENT=0 BUILD_SERVER=1 \
        BUILD_GAME_SO=1 BUILD_GAME_QVM=1 \
        -j"$JOBS" release $MAKE_ARGS

    local artifact
    for artifact in \
        "$out_dir/ZEQ2Dedicated.exe" \
        "$out_dir/Base/gamex86_64.dll" \
        "$out_dir/Base/cgamex86_64.dll" \
        "$out_dir/Base/uix86_64.dll"; do
        [[ -f "$artifact" ]] || die "Expected Windows x64 artifact was not built: $artifact"
    done
    log "Windows x64 build complete. Artifacts are in $out_dir"
}

android_abi_arch() {
    case "$1" in
        arm64-v8a)   printf 'arm64\n' ;;
        armeabi-v7a) printf 'arm\n' ;;
        *) return 1 ;;
    esac
}

android_abi_cc() {
    case "$1" in
        arm64-v8a)   printf 'aarch64-linux-android24-clang\n' ;;
        armeabi-v7a) printf 'armv7a-linux-androideabi24-clang\n' ;;
        *) return 1 ;;
    esac
}

build_android() {
    local sdk_ndk_dir="$ANDROID_NDK/toolchains/llvm/prebuilt/$ANDROID_HOST_TAG/bin"
    local build_tools="$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS"
    local android_jar="$ANDROID_HOME/platforms/$ANDROID_PLATFORM/android.jar"
    local aapt2="$build_tools/aapt2"
    local zipalign="$build_tools/zipalign"
    local apksigner="$build_tools/apksigner"
    local out_dir="$SOURCE_DIR/Build/Android"
    local stage="$out_dir/stage"
    local unsigned="$stage/unsigned.apk"
    local aligned="$stage/aligned.apk"
    local keystore="$out_dir/debug.keystore"
    local apk="$out_dir/ZEQ2-Lite-debug.apk"
    local host_qvm_dir="$SOURCE_DIR/Build/Release-${PLATFORM}-${ARCH}"
    local abi arch cc source_so

    command -v keytool >/dev/null 2>&1 || die "keytool not found; install a JDK to sign the APK."
    command -v zip >/dev/null 2>&1 || die "zip not found; it is required to stage APK assets."
    [[ -x "$aapt2" ]] || die "aapt2 not found at $aapt2 (override ANDROID_BUILD_TOOLS)."
    [[ -x "$zipalign" ]] || die "zipalign not found at $zipalign."
    [[ -x "$apksigner" ]] || die "apksigner not found at $apksigner."
    [[ -f "$android_jar" ]] || die "android.jar not found at $android_jar (override ANDROID_PLATFORM)."
    [[ -d "$sdk_ndk_dir" ]] || die "Android NDK toolchain not found at $sdk_ndk_dir (override ANDROID_NDK/ANDROID_HOST_TAG)."

    log "Building host QVMs for the Android assets..."
    make -C "$SOURCE_DIR" release -j"$JOBS" USE_LOCAL_HEADERS=0 \
        BUILD_CLIENT=0 BUILD_SERVER=0 BUILD_GAME_SO=0 BUILD_GAME_QVM=1 $MAKE_ARGS

    for abi in $ANDROID_ABIS; do
        arch="$(android_abi_arch "$abi")" || die "Unsupported Android ABI: $abi"
        cc="$(android_abi_cc "$abi")" || die "Unsupported Android ABI: $abi"
        [[ -x "$sdk_ndk_dir/$cc" ]] || die "Android compiler not found: $sdk_ndk_dir/$cc"

        log "Cross-building $abi native library..."
        rm -rf "$SOURCE_DIR/Build/Release-android-$arch"
        make -C "$SOURCE_DIR" \
            PLATFORM=android ARCH="$arch" CC="$sdk_ndk_dir/$cc" \
            ANDROID_NDK="$ANDROID_NDK" CROSS_COMPILING=1 USE_LOCAL_HEADERS=1 \
            BUILD_CLIENT=1 BUILD_SERVER=0 BUILD_GAME_SO=0 BUILD_GAME_QVM=0 \
            BUILD_CLIENT_SMP=0 -j"$JOBS" release $MAKE_ARGS
    done

    log "Staging Android APK assets and native libraries..."
    rm -rf "$stage" "$apk"
    mkdir -p "$stage/assets/ZEQ2/vm"
    for abi in $ANDROID_ABIS; do
        arch="$(android_abi_arch "$abi")"
        mkdir -p "$stage/lib/$abi"
        case "$abi" in
            arm64-v8a)   source_so="$SOURCE_DIR/Build/Release-android-arm64/ZEQ2.arm64" ;;
            armeabi-v7a) source_so="$SOURCE_DIR/Build/Release-android-arm/ZEQ2.arm" ;;
        esac
        [[ -f "$source_so" ]] || die "Native library was not built: $source_so"
        cp -f "$source_so" "$stage/lib/$abi/libzeq2.so"
    done

    cp -R "$ROOT/android/assets/." "$stage/assets/"
    for qvm in cgame game ui; do
        [[ -f "$host_qvm_dir/Base/vm/$qvm.qvm" ]] || die "Missing host-built QVM: $host_qvm_dir/Base/vm/$qvm.qvm"
        cp -f "$host_qvm_dir/Base/vm/$qvm.qvm" "$stage/assets/ZEQ2/vm/"
    done

    log "Linking Android manifest..."
    "$aapt2" link --manifest "$ROOT/android/AndroidManifest.xml" \
        -I "$android_jar" \
        --min-sdk-version "$ANDROID_MIN_SDK" --target-sdk-version "$ANDROID_TARGET_SDK" \
        --version-code 1 --version-name 1.0 \
        -o "$stage/base.apk"

    cp -f "$stage/base.apk" "$unsigned"
    (cd "$stage" && zip -q -r unsigned.apk assets lib)

    log "Aligning and signing APK..."
    "$zipalign" -f 4 "$unsigned" "$aligned"

    if [[ ! -f "$keystore" ]]; then
        log "Generating a debug signing keystore at $keystore"
        keytool -genkeypair -noprompt \
            -keystore "$keystore" -storepass android -keypass android \
            -alias androiddebugkey -dname "CN=Android Debug,O=Android,C=US" \
            -keyalg RSA -keysize 2048 -validity 10000 >/dev/null
    fi

    "$apksigner" sign \
        --ks "$keystore" --ks-pass pass:android --key-pass pass:android \
        --v1-signing-enabled true --v2-signing-enabled true \
        --out "$apk" "$aligned"
    "$apksigner" verify --print-certs "$apk" >/dev/null

    log "Android build complete: $apk"
    log "Game data: install a ZEQ2 .pk3 into $stage/assets/ZEQ2/ and rebuild to include it."
}

# ---------------------------------------------------------------------------
# Runtime helpers
# ---------------------------------------------------------------------------

find_binary() {
    local dir="$1" pattern="$2" match
    local -a matches=( "$dir"/$pattern )
    for match in "${matches[@]}"; do
        if [[ -f "$match" && -x "$match" ]]; then
            printf '%s\n' "$match"
            return 0
        fi
    done
    return 1
}

prepare_runtime() {
    local dir="$1"
    [[ -d "$dir" ]] || die "Build directory not found: $dir (run '$0 build' first)"

    mkdir -p "$dir/ZEQ2/vm"

    # The engine needs a default.cfg; only create a stub when the real game
    # data has not been installed by the user.
    if [[ ! -f "$dir/ZEQ2/default.cfg" ]]; then
        cat > "$dir/ZEQ2/default.cfg" <<'EOF'
// Minimal configuration created by build.sh for smoke tests.
// Replace with the game's real default.cfg for actual gameplay.
EOF
    fi

    local module
    for module in "$dir"/Base/*.so; do
        [[ -e "$module" ]] && cp -f "$module" "$dir/ZEQ2/"
    done
    for module in "$dir"/Base/vm/*.qvm; do
        [[ -e "$module" ]] && cp -f "$module" "$dir/ZEQ2/vm/"
    done
}

run_binary() {
    local pattern="$1"
    shift
    prepare_runtime "$RELEASE_DIR"
    local binary
    binary="$(find_binary "$RELEASE_DIR" "$pattern")" || die "No built binary matching '$pattern' in $RELEASE_DIR"
    log "Running $(basename "$binary") $*"
    cd "$RELEASE_DIR"
    exec "./$(basename "$binary")" "$@"
}

memory_test() {
    local cc="${CC:-cc}"
    local binary="$TEST_DIR/memory-tests"

    log "Building and running zone/hunk allocator unit tests..."
    mkdir -p "$TEST_DIR"
    # Link the real allocator from common.c against small engine stubs so the
    # tests cover the same code paths that ship in the client and server.
    "$cc" -std=gnu17 -Wall -DDEDICATED -DNDEBUG -DNO_VM_COMPILED \
        -DPRODUCT_VERSION='"ZEQ2-Lite memory tests"' \
        -I "$SOURCE_DIR/Shared" -I "$SOURCE_DIR/Engine/client" \
        -o "$binary" \
        "$SOURCE_DIR/Tests/test_memory.c" \
        "$SOURCE_DIR/Tests/engine_stubs.c" \
        "$SOURCE_DIR/Shared/common.c" -lm
    "$binary"
}

smoke_test() {
    prepare_runtime "$RELEASE_DIR"
    local binary logfile
    binary="$(find_binary "$RELEASE_DIR" 'ZEQ2Dedicated.*')" || die "Dedicated server was not built."
    logfile="$(mktemp)"
    trap 'rm -f "$logfile"' RETURN

    log "Smoke-testing the dedicated server (starting and quitting)..."
    local status=0
    (cd "$RELEASE_DIR" && timeout 30 "./$(basename "$binary")" +set sv_maxclients 2 +quit) >"$logfile" 2>&1 || status=$?

    if ((status != 0)); then
        cat "$logfile" >&2
        die "Dedicated server exited with status $status."
    fi
    grep -q 'Common Initialization Complete' "$logfile" || {
        cat "$logfile" >&2
        die "Dedicated server did not finish initialization."
    }
    log "Smoke test passed: dedicated server started and exited cleanly."
}

run_client_smoke_test() {
    local label="$1" pattern="$2" expect_thread="$3"
    shift 3

    local binary logfile home_dir status=0
    binary="$(find_binary "$RELEASE_DIR" "$pattern")" || die "Client matching '$pattern' was not built."
    logfile="$(mktemp)"
    # Isolate the archived config so one run cannot change r_smp for the next.
    home_dir="$(mktemp -d)"

    log "Smoke-testing ${label} (Xvfb)..."
    (cd "$RELEASE_DIR" && HOME="$home_dir" timeout 45 xvfb-run -a "./$(basename "$binary")" \
        "$@" +wait 30 +quit) >"$logfile" 2>&1 || status=$?

    if ((status != 0)); then
        cat "$logfile" >&2
        rm -rf "$home_dir" "$logfile"
        die "$label exited with status $status."
    fi

    if [[ "$expect_thread" == yes ]]; then
        grep -q 'Render thread starting' "$logfile" || {
            cat "$logfile" >&2
            rm -rf "$home_dir" "$logfile"
            die "$label did not start the render thread."
        }
        grep -q 'Render thread terminating' "$logfile" || {
            cat "$logfile" >&2
            rm -rf "$home_dir" "$logfile"
            die "$label did not shut the render thread down cleanly."
        }
    else
        if grep -q 'Render thread starting' "$logfile"; then
            cat "$logfile" >&2
            rm -rf "$home_dir" "$logfile"
            die "$label started a render thread even though r_smp was disabled."
        fi
    fi

    rm -rf "$home_dir" "$logfile"
    log "Passed: $label"
}

client_smoke_test() {
    if [[ "$PLATFORM" != linux && "$PLATFORM" != darwin ]]; then
        return 0
    fi
    if ! command -v xvfb-run >/dev/null 2>&1; then
        warn "xvfb-run not found; skipping the headless render-thread smoke tests."
        return 0
    fi

    prepare_runtime "$RELEASE_DIR"
    run_client_smoke_test "default client (threaded renderer)" 'ZEQ2.*' yes
    run_client_smoke_test "single-threaded option (r_smp 0)" 'ZEQ2.*' no +set r_smp 0
    if [[ -e "$RELEASE_DIR/ZEQ2-smp.$ARCH" ]]; then
        run_client_smoke_test "ZEQ2-smp compatibility client" 'ZEQ2-smp.*' yes +set r_smp 1
    fi
}

# ---------------------------------------------------------------------------
# Command line
# ---------------------------------------------------------------------------

usage() {
    cat <<EOF
Usage: $0 [command] [options]

Commands:
  all       Check dependencies, build release+debug, and smoke-test (default)
  deps      Check/install build dependencies via apt
  build     Build release and debug targets
  release   Build only the optimized release target
  test      Run allocator unit tests, then smoke-test server and client
  memory-test  Build and run the zone/hunk allocator unit tests
  warnings  Fresh release+debug rebuild; fail if any compiler warning appears
  win64     Cross-build Windows x64 server and game modules (needs mingw-w64)
  android   Cross-build ARM Android clients and package a signed APK
  run       Run the graphical client (extra arguments are passed through)
  smp       Run the client with the multi-threaded renderer (r_smp 1)
  server    Run the dedicated server (extra arguments are passed through)
  clean     Remove all build artifacts

Options:
  -j N      Parallel build jobs (default: $(nproc 2>/dev/null || echo 2))
  -h        Show this help

Examples:
  $0
  $0 run +set fs_game ZEQ2
  $0 server +map mymap
  JOBS=2 $0 build
  $0 win64
  $0 android
EOF
}

command_name="all"
args=()
while (($#)); do
    case "$1" in
        -j)
            shift
            [[ $# -gt 0 ]] || die "-j requires a number"
            JOBS="$1"
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            if [[ "$1" == all || "$1" == deps || "$1" == build || "$1" == release || \
                  "$1" == test || "$1" == memory-test || "$1" == warnings || \
                  "$1" == win64 || "$1" == android || \
                  "$1" == run || "$1" == smp || "$1" == server || "$1" == clean ]]; then
                command_name="$1"
            else
                args+=("$1")
            fi
            ;;
    esac
    shift
done

case "$command_name" in
    all)
        ensure_deps
        build_all
        memory_test
        smoke_test
        client_smoke_test
        ;;
    deps)
        ensure_deps
        ;;
    build)
        build_all
        ;;
    release)
        build_release
        ;;
    test)
        memory_test
        smoke_test
        client_smoke_test
        ;;
    memory-test)
        memory_test
        ;;
    warnings)
        warnings_check
        ;;
    win64)
        build_win64
        ;;
    android)
        build_android
        ;;
    run)
        run_binary "ZEQ2.$ARCH" "${args[@]}"
        ;;
    smp)
        args=(+set r_smp 1 "${args[@]}")
        run_binary 'ZEQ2-smp.*' "${args[@]}"
        ;;
    server)
        run_binary 'ZEQ2Dedicated.*' "${args[@]}"
        ;;
    clean)
        log "Cleaning build artifacts..."
        make -C "$SOURCE_DIR" distclean USE_LOCAL_HEADERS=0 $MAKE_ARGS
        ;;
esac
