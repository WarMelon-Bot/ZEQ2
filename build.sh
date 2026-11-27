#!/usr/bin/env bash
#
# ZEQ2-Lite CLI build / run helper
#
#   ./build.sh                 build everything and smoke-test server + client
#   ./build.sh build           build release + debug targets
#   ./build.sh release         build only the optimized release target (fastest)
#   ./build.sh native          build a release tuned for this CPU (MARCH=native)
#   ./build.sh test            run allocator unit tests and smoke tests
#   ./build.sh memory-test     build and run just the allocator unit tests
#   ./build.sh memory-test-asan  build and run the allocator tests with ASan/UBSan
#   ./build.sh pmove-test        run deterministic movement/melee/weapon regression tests
#   ./build.sh connect-cache-test  run model config cache regression tests
#   ./build.sh snapshot-join-test  run join-time snapshot/PVS regression tests
#   ./build.sh chat-message-test  run client chat/message hardening regression tests
#   ./build.sh network-safety-test  run untrusted network message parser regression tests
#   ./build.sh parse-io-test  run script number and filesystem suffix helper regression tests
#   ./build.sh connect-userinfo-test  sanitizer test for oversized connect userinfo
#   ./build.sh integration-test  connect a client to a real server and exercise actions
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
ANDROID_ABIS="${ANDROID_ABIS:-arm64-v8a}"
ANDROID_MIN_SDK=24
ANDROID_TARGET_SDK=35

log() { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2; }
die() { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

ARCH="$(uname -m | sed -e 's/i.86/x86_64/' -e 's/amd64/x86_64/')"
PLATFORM="$(uname | tr '[:upper:]' '[:lower:]' | sed -e 's/_.*//')"
RELEASE_DIR="$SOURCE_DIR/Build/Release-${PLATFORM}-${ARCH}"
DEBUG_DIR="$SOURCE_DIR/Build/Debug-${PLATFORM}-${ARCH}"
TEST_DIR="$SOURCE_DIR/Build/Tests"

APT_PACKAGES="build-essential ccache pkg-config libsdl1.2-dev libgl1-mesa-dev libcurl4-openssl-dev libopenal-dev libvorbis-dev libvulkan-dev libshaderc-dev mesa-vulkan-drivers"

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
    for module in sdl gl libcurl openal vorbisfile vulkan shaderc; do
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

build_native() {
    log "Building release tuned for this CPU (-march=native)..."
    # Make does not track command-line flag changes, so start from a clean
    # release tree to guarantee the native flags are actually applied.
    rm -rf "$RELEASE_DIR"
    make -C "$SOURCE_DIR" release -j"$JOBS" USE_LOCAL_HEADERS=0 \
        MARCH=native $MAKE_ARGS
    prepare_runtime "$RELEASE_DIR"
    verify_release_artifacts
    log "Native release build complete. Artifacts are in $RELEASE_DIR"
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
        *) return 1 ;;
    esac
}

android_abi_cc() {
    case "$1" in
        arm64-v8a)   printf 'aarch64-linux-android24-clang\n' ;;
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

connect_cache_test() {
    local cc="${CC:-cc}" binary="$TEST_DIR/connect-cache-tests"
    local game="$SOURCE_DIR/Game/Game"

    log "Building and running model config cache regression tests..."
    mkdir -p "$TEST_DIR"
    "$cc" -std=gnu17 -Wall -DGAME -DNDEBUG -DNO_VM_COMPILED \
        -DPRODUCT_VERSION='"ZEQ2-Lite connect cache tests"' \
        -I "$SOURCE_DIR/Shared" -I "$game" -I "$SOURCE_DIR/Engine/client" \
        -o "$binary" \
        "$SOURCE_DIR/Tests/test_connect_cache.c" \
        "$game/g_tiers.c" -lm
    "$binary"
}

snapshot_join_test() {
    local cc="${CC:-cc}" binary="$TEST_DIR/snapshot-join-tests"

    log "Building and running join-time snapshot regression tests..."
    mkdir -p "$TEST_DIR"
    # The test includes the real server snapshot builder with collision stubs,
    # then verifies that connecting clients never walk the PVS.
    "$cc" -std=gnu17 -Wall -Wextra -Wno-unused-parameter -DDEDICATED -DNDEBUG \
        -DNO_VM_COMPILED -DPRODUCT_VERSION='"ZEQ2-Lite snapshot join tests"' \
        -I "$SOURCE_DIR/Shared" -I "$SOURCE_DIR/Game/Game" \
        -I "$SOURCE_DIR/Engine/client" -I "$SOURCE_DIR/Engine/server" \
        -o "$binary" "$SOURCE_DIR/Tests/test_snapshot_join.c" -lm
    "$binary"
}

chat_message_test() {
    local cc="${CC:-cc}" binary="$TEST_DIR/chat-message-tests" probe="$TEST_DIR/chat-sanitizer-probe"
    local cgame="$SOURCE_DIR/Game/CGame"
    local sanitizers="" flags

    log "Building and running client chat/message regression tests..."
    mkdir -p "$TEST_DIR"

    if printf 'int main(void) { return 0; }\n' | \
        "$cc" -x c - -o "$probe" -fsanitize=address,undefined >/dev/null 2>&1; then
        sanitizers="-fsanitize=address,undefined -fno-omit-frame-pointer"
    else
        warn "Compiler does not support ASan/UBSan; running chat tests without sanitizers."
    fi
    rm -f "$probe"

    flags="-std=gnu17 -g -O1 -Wall -Wextra $sanitizers"
    # shellcheck disable=SC2086
    "$cc" $flags -I "$SOURCE_DIR/Shared" -I "$cgame" \
        -o "$binary" "$SOURCE_DIR/Tests/test_chat_message.c" -lm

    ASAN_OPTIONS=detect_leaks=1 \
        UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
        "$binary"
}

string_test() {
    local cc="${CC:-cc}" binary="$TEST_DIR/string-tests"
    local sanitizers=""

    log "Building and running string formatter regression tests..."
    mkdir -p "$TEST_DIR"
    if printf 'int main(void) { return 0; }\n' | \
        "$cc" -x c - -o "$TEST_DIR/string-sanitizer-probe" -fsanitize=address,undefined >/dev/null 2>&1; then
        sanitizers="-fsanitize=address,undefined -fno-omit-frame-pointer"
    fi
    rm -f "$TEST_DIR/string-sanitizer-probe"

    # shellcheck disable=SC2086
    "$cc" -std=gnu17 -g -O1 -Wall -Wextra $sanitizers \
        -I "$SOURCE_DIR/Shared" -I "$SOURCE_DIR/Engine/client" \
        -o "$binary" \
        "$SOURCE_DIR/Tests/test_string_safety.c" \
        "$SOURCE_DIR/Shared/q_shared.c" -lm

    ASAN_OPTIONS=detect_leaks=1 \
        UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
        "$binary"
}

network_safety_test() {
    local cc="${CC:-cc}" binary="$TEST_DIR/network-safety-tests" probe="$TEST_DIR/sanitizer-probe"
    local sanitizers=""

    log "Building and running untrusted network message parser tests..."
    mkdir -p "$TEST_DIR"
    if printf 'int main(void) { return 0; }\n' | \
        "$cc" -x c - -o "$probe" -fsanitize=address,undefined >/dev/null 2>&1; then
        sanitizers="-fsanitize=address,undefined -fno-omit-frame-pointer"
    else
        warn "Compiler does not support ASan/UBSan; running network safety tests without sanitizers."
    fi
    rm -f "$probe"

    # shellcheck disable=SC2086
    "$cc" -std=gnu17 -g -O1 -Wall $sanitizers \
        -I "$SOURCE_DIR/Shared" -I "$SOURCE_DIR/Engine/client" \
        -o "$binary" \
        "$SOURCE_DIR/Tests/test_network_safety.c" \
        "$SOURCE_DIR/Shared/msg.c" \
        "$SOURCE_DIR/Shared/huffman.c" -lm

    ASAN_OPTIONS=detect_leaks=1 \
        UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
        "$binary"
}

parse_io_test() {
    local cc="${CC:-cc}" binary="$TEST_DIR/parse-io-tests" probe="$TEST_DIR/parse-sanitizer-probe"
    local sanitizers=""

    log "Building and running script parser / IO helper regression tests..."
    mkdir -p "$TEST_DIR"
    if printf 'int main(void) { return 0; }\n' | \
        "$cc" -x c - -o "$probe" -fsanitize=address,undefined >/dev/null 2>&1; then
        sanitizers="-fsanitize=address,undefined -fno-omit-frame-pointer"
    else
        warn "Compiler does not support ASan/UBSan; running parse/IO tests without sanitizers."
    fi
    rm -f "$probe"

    # shellcheck disable=SC2086
    "$cc" -std=gnu17 -g -O1 -Wall -Wextra $sanitizers \
        -I "$SOURCE_DIR/Shared" -I "$SOURCE_DIR/Engine/client" \
        -o "$binary" \
        "$SOURCE_DIR/Tests/test_parse_io.c" \
        "$SOURCE_DIR/Shared/q_shared.c" -lm

    ASAN_OPTIONS=detect_leaks=1 \
        UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
        "$binary"
}

connect_userinfo_test() {
    local tmpdir home_dir runtime_dir port status=0
    local client_log server_log long_value n client_binary

    if [[ "$PLATFORM" != linux && "$PLATFORM" != darwin ]]; then
        warn "Skipping connect-userinfo test on $PLATFORM."
        return 0
    fi
    if ! command -v xvfb-run >/dev/null 2>&1; then
        warn "xvfb-run not found; skipping the connect-userinfo sanitizer test."
        return 0
    fi
    if ! command -v python3 >/dev/null 2>&1; then
        warn "python3 not found; skipping the connect-userinfo sanitizer test."
        return 0
    fi

    tmpdir="$(mktemp -d)"
    trap 'rm -rf "$tmpdir"' RETURN
    runtime_dir="$tmpdir/build/Release-${PLATFORM}-${ARCH}"
    home_dir="$tmpdir/home"
    client_log="$tmpdir/client.log"
    server_log="$tmpdir/server.log"

    log "Building sanitized client for the connect-userinfo regression test..."
    make -C "$SOURCE_DIR" BUILD_DIR="$tmpdir/build" release -j"$JOBS" \
        USE_LOCAL_HEADERS=0 \
        CFLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer -g -O1' \
        LDFLAGS='-fsanitize=address,undefined' >"$tmpdir/build.log" 2>&1 || {
            cat "$tmpdir/build.log" >&2
            die "Sanitized client build failed."
        }
    prepare_runtime "$runtime_dir"
    client_binary="$(find_binary "$runtime_dir" "ZEQ2.$ARCH")" || die "Sanitized client binary was not built."
    client_binary="$(basename "$client_binary")"

    mkdir -p "$home_dir/.ZEQ2/ZEQ2"
    long_value="$(printf 'B%.0s' $(seq 1 250))"
    {
        for n in 1 2 3 4 5; do
            printf 'setu custom%d "%s"\n' "$n" "$long_value"
        done
    } > "$home_dir/.ZEQ2/ZEQ2/autoexec.cfg"

    port="$(python3 -c 'import socket; s=socket.socket(socket.AF_INET, socket.SOCK_DGRAM); s.bind(("127.0.0.1", 0)); print(s.getsockname()[1]); s.close()')"
    python3 "$SOURCE_DIR/Tests/fake_connect_server.py" "$port" >"$server_log" 2>&1 &
    local server_pid=$!
    sleep 1

    log "Connecting a client with a ~1 KiB userinfo string to the fake server..."
    (cd "$runtime_dir" && HOME="$home_dir" \
        ASAN_OPTIONS=detect_leaks=0 \
        UBSAN_OPTIONS=halt_on_error=0:print_stacktrace=1 \
        timeout 30 xvfb-run -a "./$client_binary" \
        +connect "127.0.0.1:$port" +wait 5 +quit) >"$client_log" 2>&1 || status=$?
    kill "$server_pid" 2>/dev/null || true
    wait "$server_pid" 2>/dev/null || true

    if ((status != 0)); then
        cat "$client_log" >&2
        die "Sanitized client exited with status $status during connect."
    fi
    # This old renderer emits known UBSan alignment/null-argument diagnostics
    # under Xvfb; only fail on actual ASan findings, which are the overflow
    # this test is meant to guard against.
    if grep -q 'AddressSanitizer' "$client_log"; then
        cat "$client_log" >&2
        die "Sanitized client reported a memory error during connect."
    fi
    grep -q 'SAW_CONNECT' "$server_log" || {
        cat "$server_log" >&2
        die "Fake server did not observe the client connect packet."
    }
    log "Passed: oversized userinfo connect packet is handled safely."
}

pmove_test() {
    local cc="${CC:-cc}" binary="$TEST_DIR/pmove-tests" output="$TEST_DIR/pmove-tests.out"
    local game="$SOURCE_DIR/Game/Game"

    log "Building and running deterministic pmove regression tests..."
    mkdir -p "$TEST_DIR"
    "$cc" -std=gnu17 -Wall -DGAME -DNDEBUG -DNO_VM_COMPILED \
        -DPRODUCT_VERSION='"ZEQ2-Lite pmove tests"' \
        -I "$SOURCE_DIR/Shared" -I "$game" -I "$SOURCE_DIR/Engine/client" \
        -o "$binary" \
        "$SOURCE_DIR/Tests/pmove_harness.c" \
        "$game/bg_pmove.c" "$game/bg_pmanim.c" "$game/bg_pmmelee.c" \
        "$game/bg_pmmove.c" "$game/bg_pmweapon.c" "$game/bg_slidemove.c" \
        "$game/bg_misc.c" "$game/bg_lib.c" \
        "$SOURCE_DIR/Shared/q_math.c" "$SOURCE_DIR/Shared/q_shared.c" -lm
    "$binary" >"$output"
    diff -u "$SOURCE_DIR/Tests/pmove_harness.expected" "$output"
}

memory_test_sanitized() {
    local cc="${CC:-cc}" binary="$TEST_DIR/memory-tests-asan"
    local probe="$TEST_DIR/sanitizer-probe"

    log "Building and running zone/hunk allocator unit tests with ASan/UBSan..."
    mkdir -p "$TEST_DIR"
    if ! printf 'int main(void) { return 0; }\n' | \
        "$cc" -x c - -o "$probe" -fsanitize=address,undefined >/dev/null 2>&1; then
        warn "Compiler does not support ASan/UBSan; skipping sanitized allocator tests."
        return 0
    fi
    rm -f "$probe"

    "$cc" -std=gnu17 -g -O1 -Wall -fsanitize=address,undefined -fno-omit-frame-pointer \
        -DDEDICATED -DNDEBUG -DNO_VM_COMPILED \
        -DPRODUCT_VERSION='"ZEQ2-Lite memory tests (ASan/UBSan)"' \
        -I "$SOURCE_DIR/Shared" -I "$SOURCE_DIR/Engine/client" \
        -o "$binary" \
        "$SOURCE_DIR/Tests/test_memory.c" \
        "$SOURCE_DIR/Tests/engine_stubs.c" \
        "$SOURCE_DIR/Shared/common.c" -lm
    ASAN_OPTIONS=detect_leaks=1 \
        UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
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

# Verify that a native 64-bit server accepts allocator sizes above the old
# 1 GiB/4 GiB ceilings.  The cvars are latched, so this uses a short-lived
# dedicated server process instead of the unit-test binary.
memory_limit_test() {
    case "$ARCH" in
        x86_64|amd64|arm64|aarch64|ppc64|ppc64le|s390x|sparc64|ia64) ;;
        *) warn "Skipping high-memory limit test on unsupported architecture $ARCH."
           return 0 ;;
    esac

    if [[ "${ZEQ2_SKIP_MEMORY_LIMIT_TEST:-0}" == 1 ]]; then
        warn "Skipping high-memory limit test (ZEQ2_SKIP_MEMORY_LIMIT_TEST=1)."
        return 0
    fi

    prepare_runtime "$RELEASE_DIR"
    local binary logfile status=0
    binary="$(find_binary "$RELEASE_DIR" 'ZEQ2Dedicated.*')" || die "Dedicated server was not built."
    logfile="$(mktemp)"
    trap 'rm -f "$logfile"' RETURN

    log "Smoke-testing raised 64-bit allocator limits..."
    (cd "$RELEASE_DIR" && timeout 30 "./$(basename "$binary")" \
        +set com_hunkMegs 4097 +set com_zoneMegs 1025 \
        +set sv_maxclients 1 +quit) >"$logfile" 2>&1 || status=$?

    if ((status != 0)); then
        cat "$logfile" >&2
        die "Dedicated server exited with status $status with raised memory limits."
    fi
    if grep -q 'clamped to' "$logfile"; then
        cat "$logfile" >&2
        die "64-bit build still clamped com_hunkMegs/com_zoneMegs."
    fi
    grep -q 'Common Initialization Complete' "$logfile" || {
        cat "$logfile" >&2
        die "Dedicated server did not finish initialization with raised limits."
    }
    log "Smoke test passed: 64-bit hunk/zone limits accept multi-gigabyte cvars."
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

run_vulkan_smoke_test() {
    local label="$1" smp="$2" expect_thread="$3"
    local binary logfile home_dir status=0 icd
    binary="$(find_binary "$RELEASE_DIR" 'ZEQ2.*')" || die "Client was not built."
    logfile="$(mktemp)"
    home_dir="$(mktemp -d)"
    icd=/usr/share/vulkan/icd.d/lvp_icd.json
    local driver_files="${VK_ICD_FILENAMES:-}"
    if [[ -z "$driver_files" && -f "$icd" ]]; then
        driver_files="$icd"
    fi

    log "Smoke-testing ${label} (Xvfb/lavapipe)..."
    (cd "$RELEASE_DIR" && HOME="$home_dir" \
        VK_ICD_FILENAMES="$driver_files" \
        timeout 45 xvfb-run -a "./$(basename "$binary")" \
        +set r_renderer vulkan +set r_smp "$smp" +set r_measureOverdraw 1 \
        +wait 30 +quit) >"$logfile" 2>&1 || status=$?

    if ((status != 0)); then
        cat "$logfile" >&2
        rm -rf "$home_dir" "$logfile"
        die "Vulkan client exited with status $status."
    fi
    if ! grep -q 'Vulkan backend initialized' "$logfile"; then
        cat "$logfile" >&2
        rm -rf "$home_dir" "$logfile"
        die "Vulkan backend was not initialized."
    fi
    if ! grep -q 'stencil(8-bits)' "$logfile"; then
        cat "$logfile" >&2
        rm -rf "$home_dir" "$logfile"
        die "Vulkan backend did not report 8 stencil bits."
    fi
    if grep -E -q 'shader translation failed|shader compilation failed|vkCreateGraphicsPipelines failed' "$logfile"; then
        cat "$logfile" >&2
        rm -rf "$home_dir" "$logfile"
        die "Vulkan shader or pipeline creation failed."
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

vulkan_smoke_test() {
    [[ "$PLATFORM" == linux ]] || return 0
    command -v xvfb-run >/dev/null 2>&1 || {
        warn "xvfb-run not found; skipping the headless Vulkan smoke test."
        return 0
    }

    local binary
    binary="$(find_binary "$RELEASE_DIR" 'ZEQ2.*')" || die "Client was not built."
    grep -aq 'Vulkan backend initialized' "$binary" || {
        warn "This build has no Vulkan backend; skipping the Vulkan smoke test."
        return 0
    }

    run_vulkan_smoke_test "Vulkan backend (single-threaded option)" 0 no
    run_vulkan_smoke_test "Vulkan backend (threaded renderer)" 1 yes
}

# ---------------------------------------------------------------------------
# Connected client / server integration test
# ---------------------------------------------------------------------------

integration_test() {
    if [[ "$PLATFORM" != linux && "$PLATFORM" != darwin ]]; then
        warn "Skipping the integration test on platform $PLATFORM."
        return 0
    fi
    if ! command -v xvfb-run >/dev/null 2>&1; then
        warn "xvfb-run not found; skipping the integration test."
        return 0
    fi

    prepare_runtime "$RELEASE_DIR"
    local server_binary client_binary
    server_binary="$(find_binary "$RELEASE_DIR" 'ZEQ2Dedicated.*')" || die "Dedicated server was not built."
    client_binary="$(find_binary "$RELEASE_DIR" 'ZEQ2.*')" || die "Client was not built."

    local work_dir
    work_dir="$(mktemp -d)"
    server_pid=""
    # shellcheck disable=SC2317
    cleanup_integration() {
        [[ -n "$server_pid" ]] && kill "$server_pid" 2>/dev/null || true
        [[ -n "$server_pid" ]] && wait "$server_pid" 2>/dev/null || true
        rm -rf "$work_dir"
    }
    trap cleanup_integration RETURN

    # Build the minimal BSP used by this test.  A start with a solid floor is
    # enough for the game VM to spawn a player and process user commands.
    python3 "$SOURCE_DIR/Tests/generate_test_map.py" \
        "$RELEASE_DIR/ZEQ2/maps/testroom.bsp" >/dev/null

    # The default player model has no real assets in this source tree.  A
    # minimal animation.cfg keeps cgame from aborting on a missing model.
    mkdir -p "$RELEASE_DIR/ZEQ2/players/goku"
    printf 'footsteps default\nsex male\n0 1 0 10\n' \
        > "$RELEASE_DIR/ZEQ2/players/goku/animation.cfg"

    # Actions are driven from a config file rather than +command arguments.
    # The engine strips leading '+' when parsing the command line, but config
    # files preserve them, so +forward etc. reach the input system correctly.
    cat > "$RELEASE_DIR/ZEQ2/test-actions.cfg" <<'CFGEOF'
wait 100
viewpos
+forward
wait 20
-forward
+back
wait 20
-back
+moveleft
wait 20
-moveleft
+moveright
wait 20
-moveright
+strafe
wait 20
-strafe
+left
wait 20
-left
+right
wait 20
-right
+lookup
wait 20
-lookup
+lookdown
wait 20
-lookdown
+mlook
wait 20
-mlook
+moveup
wait 20
-moveup
+movedown
wait 20
-movedown
+speed
wait 20
-speed
+attack
wait 20
-attack
+button1
wait 6
-button1
+button2
wait 6
-button2
+button3
wait 6
-button3
+button4
wait 6
-button4
+button5
wait 6
-button5
+button6
wait 6
-button6
+button7
wait 6
-button7
+button8
wait 6
-button8
+button9
wait 6
-button9
+scores
wait 6
-scores
+zoom
wait 6
-zoom
weapnext
weapprev
weapon 1
sizeup
sizedown
stats
loaddeferred
viewpos
say integration_chat
say_team integration_team_chat
give all
god
notarget
noclip
wait 30
viewpos
quit
CFGEOF

    # Pick a free UDP port so parallel test runs cannot collide.
    local port
    port="$(python3 -c 'import socket; s=socket.socket(socket.AF_INET, socket.SOCK_DGRAM); s.bind(("127.0.0.1",0)); print(s.getsockname()[1]); s.close()')"

    local client_log="$work_dir/client.log"
    local server_log="$work_dir/server.log"
    local home_dir="$work_dir/home"
    mkdir -p "$home_dir"

    log "Starting dedicated server on port $port..."
    (
        cd "$RELEASE_DIR"
        exec "./$(basename "$server_binary")" \
            +set developer 1 \
            +set sv_maxclients 4 \
            +set sv_pure 0 \
            +set sv_cheats 1 \
            +set sv_floodProtect 0 \
            +set net_port "$port" \
            +map testroom
    ) >"$server_log" 2>&1 &
    server_pid=$!

    # Wait until the game VM has loaded and the map is running.
    local ready=0 i
    for i in $(seq 1 100); do
        if grep -q 'Game Initialization' "$server_log"; then
            ready=1
            break
        fi
        kill -0 "$server_pid" 2>/dev/null || break
        sleep 0.1
    done
    if (( ! ready )); then
        cat "$server_log" >&2
        die "Dedicated server did not finish game initialization."
    fi

    log "Connecting client and exercising movement, combat, chat, and console actions..."
    local client_status=0
    (
        cd "$RELEASE_DIR"
        HOME="$home_dir" timeout 180 xvfb-run -a "./$(basename "$client_binary")" \
            +set cl_pure 0 \
            +set s_backend null \
            +connect "127.0.0.1:$port" \
            +exec test-actions.cfg
    ) >"$client_log" 2>&1 || client_status=$?

    kill "$server_pid" 2>/dev/null || true
    wait "$server_pid" 2>/dev/null || true
    server_pid=""

    if (( client_status != 0 )); then
        cat "$client_log" >&2
        die "Connected client exited with status $client_status."
    fi

    # Validate the full connect -> enter game -> act -> chat -> disconnect cycle.
    local failure=0
    check_log() {
        local label="$1" file="$2" pattern="$3"
        if ! grep -qE "$pattern" "$file"; then
            printf '  missing %s (%s)\n' "$label" "$pattern" >&2
            failure=1
        fi
    }

    check_log "client init" "$client_log" 'CL_InitCGame'
    check_log "client load cgame VM" "$client_log" 'cgame.*loaded|vm/cgame.qvm'
    check_log "client clean quit" "$client_log" 'Client Shutdown \(Client quit\)'
    check_log "server accept" "$server_log" 'ClientConnect: 0'
    check_log "server enter game" "$server_log" 'ClientBegin: 0'
    check_log "server saw chat" "$server_log" 'say: UnnamedPlayer: integration_chat'
    # With g_gametype 0 (non-team) the game converts SAY_TEAM to SAY_ALL, so
    # accept either log prefix as long as the message reached the server.
    check_log "server saw team chat" "$server_log" '(say|sayteam): UnnamedPlayer: integration_team_chat'
    check_log "server saw disconnect" "$server_log" 'ClientDisconnect: 0'

    # Real errors must never appear.  Asset/file warnings and headless ALSA
    # noise are expected in this source-only test environment and are ignored.
    for pattern in \
        '^ERROR:' \
        'Com_Error' \
        'Hitch warning' \
        'DEFAULT_MODEL .* failed to register' \
        'Unknown command' \
        'client text ignored' \
        'Segmentation fault' \
        'AddressSanitizer' \
        'cmdCount <[=] 0' \
        'lost .* clientCommands'; do
        local server_check_log="$server_log"
        if [[ "$pattern" == 'Hitch warning' ]]; then
            # VM compilation makes the first server frame slow in headless CI,
            # but that happens before "Game Initialization".  Everything after
            # it -- including the whole connect/primed/enter-world sequence --
            # must be hitch free, otherwise a join-time regression would be
            # hidden by waiting for ClientBegin to filter the log.
            server_check_log="$(sed -n '/Game Initialization/,$p' "$server_log")"
        fi
        if grep -qE "$pattern" "$client_log" || printf '%s\n' "$server_check_log" | grep -qE "$pattern"; then
            printf '  unexpected error matching %s\n' "$pattern" >&2
            failure=1
        fi
    done

    if (( failure )); then
        printf '\n--- client log ---\n' >&2
        cat "$client_log" >&2
        printf '\n--- server log ---\n' >&2
        cat "$server_log" >&2
        die "Client/server integration test failed."
    fi

    local positions
    positions="$(grep -cE '\([-0-9]+ [-0-9]+ [-0-9]+\) : [-0-9]+' "$client_log")"
    if (( positions < 2 )); then
        die "Movement did not produce multiple viewpos reports (got $positions)."
    fi

    log "Integration test passed: client connected, moved, attacked, chatted, and disconnected cleanly."
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
  native    Build a release tuned for this CPU (-march=native)
  test      Run unit/regression tests, then smoke-test server, OpenGL and Vulkan clients
  memory-limit-test  Verify a 64-bit server accepts multi-gigabyte allocator cvars
  memory-test  Build and run the zone/hunk allocator unit tests
  memory-test-asan  Build and run the allocator unit tests with ASan/UBSan
  pmove-test  Build and run deterministic movement/melee/weapon regression tests
  connect-cache-test  Run model config cache regression tests
  snapshot-join-test  Run join-time snapshot/PVS regression tests
  chat-message-test  Run client chat/message hardening regression tests
  string-test  Com_sprintf truncation/stack-safety regression tests
  network-safety-test  Run untrusted network message parser regression tests
  parse-io-test  Run script number and filesystem suffix helper regression tests
  connect-userinfo-test  Sanitizer test for oversized connect userinfo packets
  integration-test  Connect a client to a real server and exercise all actions
  vulkan_smoke_test  Smoke-test the Vulkan client under Xvfb (lavapipe)
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
                  "$1" == native || "$1" == test || "$1" == memory-limit-test || \
                  "$1" == memory-test || "$1" == memory-test-asan || \
                  "$1" == pmove-test || "$1" == connect-cache-test || \
                  "$1" == snapshot-join-test || \
                   "$1" == chat-message-test || \
                   "$1" == string-test || \
                   "$1" == network-safety-test || "$1" == parse-io-test || \
                   "$1" == connect-userinfo-test || \
                  "$1" == integration-test || "$1" == vulkan_smoke_test || \
                  "$1" == warnings || \
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
        memory_test_sanitized
        pmove_test
        connect_cache_test
        snapshot_join_test
        chat_message_test
        string_test
        network_safety_test
        parse_io_test
        smoke_test
        memory_limit_test
        client_smoke_test
        vulkan_smoke_test
        integration_test
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
    native)
        build_native
        ;;
    test)
        memory_test
        memory_test_sanitized
        pmove_test
        connect_cache_test
        snapshot_join_test
        chat_message_test
        string_test
        network_safety_test
        parse_io_test
        smoke_test
        memory_limit_test
        client_smoke_test
        vulkan_smoke_test
        integration_test
        ;;
    pmove-test)
        pmove_test
        ;;
    connect-cache-test)
        connect_cache_test
        ;;
    snapshot-join-test)
        snapshot_join_test
        ;;
    chat-message-test)
        chat_message_test
        ;;
    string-test)
        string_test
        ;;
    network-safety-test)
        network_safety_test
        ;;
    parse-io-test)
        parse_io_test
        ;;
    connect-userinfo-test)
        connect_userinfo_test
        ;;
    integration-test)
        integration_test
        ;;
    memory-limit-test)
        memory_limit_test
        ;;
    memory-test)
        memory_test
        ;;
    memory-test-asan)
        memory_test_sanitized
        ;;
    vulkan_smoke_test)
        vulkan_smoke_test
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
