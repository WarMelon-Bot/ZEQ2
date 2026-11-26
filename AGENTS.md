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
- **Primary Build CLI:** Use `./build.sh` in the repository root if present:
  - `./build.sh build` — Linux x86_64 engine and game modules
  - `./build.sh win64` — Windows x86_64 PE32+ cross-compilation
  - `./build.sh test` — Automated engine/VM smoke tests
- **Headless Server Smoke Test:** The engine requires `ZEQ2/default.cfg` to boot. Before running `ZEQ2Dedicated.x86_64`, ensure a minimal `ZEQ2/default.cfg` exists in the binary working directory and run with `+set sv_maxclients 2 +quit` under `timeout 20`.
- **Expanding Test Coverage:**
  - Whenever you implement a new feature, fix a bug, or add a new platform target (such as Android touch/virtual-key layouts or VM paths), add corresponding automated regression or smoke tests to the test suite (`./build.sh test` or dedicated test scripts) and register them in `AGENTS.md` above.
  - Run all existing and newly added test suites before committing.

## Git & Pull Request Workflow
1. Always create a descriptive feature/fix branch from `main` before making edits (`git checkout -b agent/<short-slug>`). If resuming an existing branch after a fallback, continue working on that branch.
2. Compile and verify all affected targets (`linux`, `win64`, `android`, and all test suites) pass with zero errors before committing.
3. Update `AGENTS.md` with any new build commands or test suites added during your run.
4. Commit cleanly, push the branch (`git push -u origin <branch>`), and open a Pull Request (`gh pr create`) summarizing changes, test results, and `AGENTS.md` updates.
