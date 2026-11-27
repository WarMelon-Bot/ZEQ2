# ZEQ2 Autonomous Agent Instructions

## Environment & Execution Rules
- **Headless CI Mode:** You are running non-interactively inside GitHub Actions (`ubuntu-latest`). Never ask interactive questions, prompt for confirmation, or call web search tools.
- **Full Repository Permissions:** `GITHUB_TOKEN` and `GH_TOKEN` use `AGENT_PAT` with full `repo` and `workflow` scopes. You are authorized to create and modify `.github/workflows/*.yml` files, edit `AGENTS.md`, create branches, push commits, and open Pull Requests via `gh pr create`.
- **Token Conservation:** Read only the specific source files relevant to the current issue. Do not dump large directory trees or entire log files into stdout—pipe build/test logs to `/tmp/` and inspect only errors or the last 30 lines.

## Self-Updating Documentation (`AGENTS.md`)
- **Living Document:** You are explicitly authorized and expected to update this `AGENTS.md` file whenever you:
  1. Add, rename, or discover new build scripts, CLI flags, or target platforms (e.g., Linux, Win64, Android NDK/Gradle).
  2. Create or expand automated test suites, smoke tests, or runtime verification checks.
  3. Resolve environment quirks (such as required packages, missing config files, or SDK paths) so future runs never repeat the same discovery work.
- Keep entries in `AGENTS.md` concise and structured so future runs conserve tokens.

## Build & Testing Suites

### Primary Build CLI
Use `./build.sh` in the repository root. The following commands are available:

**General Build Commands:**
- `./build.sh` — Build everything and smoke-test server + client (default)
- `./build.sh build` — Build release and debug targets
- `./build.sh release` — Build only the optimized release target (fastest)
- `./build.sh native` — Build a release tuned for this CPU (`-march=native`)
- `./build.sh run [args...]` — Run the graphical client (extra arguments passed through)
- `./build.sh smp [args...]` — Run the client with the multi-threaded renderer (`r_smp 1`)
- `./build.sh server [args..]` — Run the dedicated server (extra arguments passed through)
- `./build.sh deps` — Check (and install) build dependencies via apt

**Linux-Specific Builds:**
- `./build.sh build` — Linux x86_64 engine and game modules (default platform)
- `./build.sh warnings` — Fresh release+debug rebuild; fail if any compiler warning appears

**Windows x64 Cross-Compilation:**
- `./build.sh win64` — Cross-build the dedicated server and game DLLs/QVMs for Windows x64 (requires mingw-w64; set `WIN64_CC` and/or `WIN64_WINDRES` if needed)

**Android Cross-Compilation:**
- `./build.sh android` — Cross-build ARM Android clients and package a signed APK (requires Android SDK & NDK; default ABI: `arm64-v8a`)

### Build Configuration Options
Environment variables recognized by `build.sh`:
- `JOBS` — Parallel build jobs (default: number of CPU cores)
- `MAKE_ARGS` — Additional flags passed to `make`
- `WIN64_CC` — Windows x64 cross-compiler (default: `x86_64-w64-mingw32-gcc`)
- `WIN64_WINDRES` — Windows x64 resource compiler (default: `x86_64-w64-mingw32-windres`)
- `ANDROID_HOME` — Path to Android SDK
- `ANDROID_NDK` — Path to Android NDK
- `ANDROID_PLATFORM` — Android platform version (default: `android-35`)
- `ANDROID_BUILD_TOOLS` — Android build tools version (default: `35.0.0`)
- `ANDROID_ABIS` — Target ABIs (default: `arm64-v8a`)
- `SDL_VIDEODRIVER` — SDL video driver override

### Headless Server Smoke Test
The engine requires `ZEQ2/default.cfg` to boot. Before running the dedicated server, ensure a minimal `ZEQ2/default.cfg` exists in the binary working directory and run with:
```
./ZEQ2Dedicated.x86_64 +set sv_maxclients 2 +quit
```
under `timeout 20`.

---

### Linux Test Suites
Run tests with `./build.sh test` or invoke individually:

**Unit / Regression Tests:**
- `./build.sh memory-test` — Build and run zone/hunk allocator unit tests
- `./build.sh memory-test-asan` — Build and run allocator unit tests with ASan/UBSan
- `./build.sh pmove-test` — Build and run deterministic movement/melee/weapon regression tests (diff-against `.expected` file)
- `./build.sh connect-cache-test` — Run model config cache regression tests
- `./build.sh snapshot-join-test` — Verify connecting/primed/zombie clients never build a PVS snapshot and that join snapshots are empty, non-delta, and flagged `SNAPFLAG_NOT_ACTIVE`
- `./build.sh chat-message-test` — Run client chat/message hardening regression tests
- `./build.sh string-test` — Run Com_sprintf truncation/stack-safety regression tests
- `./build.sh network-safety-test` — Run untrusted network message parser regression tests
- `./build.sh parse-io-test` — Sanitizer-backed regression tests for strict script number parsing and safe filesystem suffix matching
- `./build.sh connect-userinfo-test` — Sanitizer test for oversized connect userinfo packets

**Smoke Tests:**
- `./build.sh smoke-test` — Smoke-test the dedicated server (start and quit); verify "Common Initialization Complete" and that allocator limits are not clamped
- `./build.sh memory-limit-test` — Verify a 64-bit server accepts multi-gigabyte allocator cvars (`com_hunkMegs`/`com_zoneMegs`)
- `./build.sh client-smoke-test` — Headless render-thread smoke tests (default threaded client, single-threaded `r_smp 0`, and `ZEQ2-smp` compatibility client if built)
- `./build.sh vulkan-smoke-test` — Smoke-test the Vulkan client under Xvfb (lavapipe); verify Vulkan backend initialized and 8 stencil bits; verify no shader/pipeline creation failures. Runs both single-threaded and threaded renderer paths.

**Integration Test:**
- `./build.sh integration-test` — Connect a client to a real server and exercise movement, combat, chat, and console actions. Validates the full connect → enter game → act → chat → disconnect cycle. Hitch warnings are checked from `Game Initialization` onward, so join-time hitches fail the test; only the earlier map-load/VM-compilation hitch is tolerated.

### Test Suites in GitHub Actions
The `.github/workflows/ci.yml` workflow runs:
1. `./build.sh deps` — Install build dependencies
2. `./build.sh build` — Build release and debug targets
3. `./build.sh test` — Run unit/regression tests, then smoke-test server, OpenGL and Vulkan clients
4. `./build.sh warnings` — Verify warning-free clean rebuild

The `.github/workflows/android-apk.yml` workflow runs:
1. `./build.sh android` — Cross-build ARM Android clients and package a signed APK
2. APK verification (apksigner verify, aapt2 badging, zip entry validation)
3. APK artifact upload

### Expanding Test Coverage
- Whenever you implement a new feature, fix a bug, or add a new platform target (such as Android touch/virtual-key layouts or VM paths), add corresponding automated regression or smoke tests to the test suite (`./build.sh test` or dedicated test scripts) and register them in `AGENTS.md` above.
- Run all existing and newly added test suites before committing.