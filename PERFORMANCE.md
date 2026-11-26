# Performance and dead-code cleanup

This branch removes the nonfunctional bot implementation and updates the
default build for modern hardware.

## Removed dead bot code

The bot library in the tree was a set of comment-only stubs. `botlib_export`
was never initialized, `UI_LoadBots()` was an empty function, and the UI bot
select screen could only ever show an empty list. Removing it eliminates dead
compile units and a number of null-pointer trap paths:

* `Source/Engine/botlib/` and `Source/Engine/server/sv_bot.c`
* `Source/Game/Game/ai_*.c/.h`, `chars.h`, `inv.h`, `syn.h`, `match.h`
* Bot/AAS/EA/character syscalls and declarations in the game module, plus the
  unused botlib precompiler traps in the client and UI modules
* The UI bot select menu, bot names/skill controls, and the `g_botsFile` cvar
* Obsolete bot objects, bot compiler flags and project-file entries

QVM syscall numbers and shared configstring indexes are left unchanged, so
existing game data and modules remain compatible.

## Build and runtime improvements

* Default x86-64 optimization now uses compiler-chosen alignment and
  `-mtune=generic`; the obsolete `-fstrength-reduce` and fixed alignment
  hints are gone.
* `./build.sh native` builds a clean release with `-march=native` for the
  machine performing the build. It deliberately avoids LTO: the current
  source tree contains constructs that LTO compiles but that misbehave at
  runtime, so it is not enabled by default.
* The frame throttle yields the CPU for sub-millisecond waits instead of
  burning a full core while waiting for high-refresh-rate frames.
* Replaced several O(n²) parsing loops that recomputed `strlen()` on every
  iteration with single-pass `strchr()`/`strlen()`/`memcpy()` equivalents.
* Fixed incorrect destination sizes in the weapon-GFX parser and a
  string-copy helper that produced diagnostics with whole-program analysis.

## Verification

`./build.sh release`, `./build.sh native`, `./build.sh test` and
`./build.sh warnings` all pass with no compiler diagnostics. The test suite
covers allocator behavior, deterministic movement/melee, config caching,
chat hardening, dedicated-server startup and OpenGL/Vulkan client smoke tests.
