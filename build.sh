#!/usr/bin/env bash
#
# ZEQ2-Lite CLI build / run helper
#
#   ./build.sh                 build everything and smoke-test the server
#   ./build.sh build           build release + debug targets
#   ./build.sh test            run the dedicated-server smoke test
#   ./build.sh run [args...]   run the graphical client
#   ./build.sh server [args..] run the dedicated server
#   ./build.sh deps            check (and install) build dependencies
#   ./build.sh clean           remove all build artifacts
#
# Environment overrides: JOBS, MAKE_ARGS, DEBIAN_FRONTEND, SDL_VIDEODRIVER
#

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$ROOT/Source"
JOBS="${JOBS:-$(command -v nproc >/dev/null 2>&1 && nproc || echo 2)}"
MAKE_ARGS="${MAKE_ARGS:-}"
PROJECT="ZEQ2-Lite"

log() { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2; }
die() { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

ARCH="$(uname -m | sed -e 's/i.86/i386/')"
PLATFORM="$(uname | tr '[:upper:]' '[:lower:]' | sed -e 's/_.*//')"
RELEASE_DIR="$SOURCE_DIR/Build/Release-${PLATFORM}-${ARCH}"
DEBUG_DIR="$SOURCE_DIR/Build/Debug-${PLATFORM}-${ARCH}"

APT_PACKAGES="build-essential pkg-config libsdl1.2-dev libgl1-mesa-dev libcurl4-openssl-dev libopenal-dev libvorbis-dev"

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

make_build() {
    local config="$1"
    log "Building ${config} (client, dedicated server, game modules and QVMs)..."
    make -C "$SOURCE_DIR" "$config" -j"$JOBS" USE_LOCAL_HEADERS=0 $MAKE_ARGS
}

build_all() {
    make_build release
    make_build debug
    prepare_runtime "$RELEASE_DIR"

    local artifact
    for artifact in "$RELEASE_DIR/ZEQ2.$ARCH" "$RELEASE_DIR/ZEQ2Dedicated.$ARCH"; do
        [[ -f "$artifact" ]] || die "Expected artifact was not built: $artifact"
    done
    log "Build complete. Release artifacts are in $RELEASE_DIR"
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
  test      Smoke-test the dedicated server
  run       Run the graphical client (extra arguments are passed through)
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
            if [[ "$1" == all || "$1" == deps || "$1" == build || "$1" == test || \
                  "$1" == run || "$1" == server || "$1" == clean ]]; then
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
        smoke_test
        ;;
    deps)
        ensure_deps
        ;;
    build)
        build_all
        ;;
    test)
        smoke_test
        ;;
    run)
        run_binary 'ZEQ2.*' "${args[@]}"
        ;;
    server)
        run_binary 'ZEQ2Dedicated.*' "${args[@]}"
        ;;
    clean)
        log "Cleaning build artifacts..."
        make -C "$SOURCE_DIR" distclean USE_LOCAL_HEADERS=0 $MAKE_ARGS
        ;;
esac
