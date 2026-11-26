# ZEQ2 Autonomous Agent Instructions

## Environment & Execution Rules
- **Headless CI Mode:** You are running non-interactively inside GitHub Actions (`ubuntu-latest`). Never ask interactive questions, prompt for confirmation, or call web search tools.
- **Full Repository Permissions:** `GITHUB_TOKEN` and `GH_TOKEN` use `AGENT_PAT` with full `repo` and `workflow` scopes. You are authorized to create and modify `.github/workflows/*.yml` files, create branches, push commits, and open Pull Requests via `gh pr create`.
- **Token Conservation:** Read only the specific source files relevant to the current issue. Do not dump large directory trees or entire log files into stdout—pipe build/test logs to `/tmp/` and inspect only errors or the last 30 lines.

## Build & Smoke-Test Commands
- **Primary Build CLI:** Use `./build.sh` in the repository root if present:
  - `./build.sh build` — Linux x86_64 engine and game modules
  - `./build.sh win64` — Windows x86_64 PE32+ cross-compilation
  - `./build.sh test` — Automated engine/VM smoke tests
- **Headless Server Smoke Test:** The engine requires `ZEQ2/default.cfg` to boot. Before running `ZEQ2Dedicated.x86_64`, ensure a minimal `ZEQ2/default.cfg` exists in the binary working directory and run with `+set sv_maxclients 2 +quit` under `timeout 20`.
- **Android Build:** If building or modifying Android targets, keep NDK/SDK setup cached or scripted cleanly inside `./build.sh` and `.github/workflows/` so CI runs remain reproducible.

## Git & Pull Request Workflow
1. Always create a descriptive feature/fix branch from `main` before making edits (`git checkout -b agent/<short-slug>`).
2. Compile and verify all affected targets (`linux`, `win64`, `android`, or `test`) pass with zero errors before committing.
3. Update this `AGENTS.md` file whenever you add new build flags, dependencies, or CLI subcommands so future runs stay fast.
4. Commit cleanly, push the branch (`git push -u origin <branch>`), and open a Pull Request (`gh pr create`) summarizing changes and test results.
