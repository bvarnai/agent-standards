# Shell & Bash engineering standards

These standards apply whenever authoring or modifying shell scripts (`*.sh`, extensionless executables in `bin/` or `.local/bin/`), sourced environment files (`.bashrc*`, `.bashrc.d/*`), or Bats test suites (`*.bats`).

## Naming conventions
1. **Public interfaces (`kebab-case`)**:
   - **Public callable functions & aliases**: Interactive shell functions and aliases exposed to the user session must use dash-separated names (e.g., `tools-shell`, `tools-reset`, `agy-work`, `repo-installer`) rather than underscores.
   - **Executable & entrypoint scripts**: Publicly invoked or sourced scripts in `bin/` or `.local/bin/` must use dash-separated filenames (e.g., `tools-env.sh`, `agy-switch`, `smart-copy`).
   - Do not mix underscores and dashes across public command interfaces.
2. **Internal identifiers (`snake_case` / `UPPER_SNAKE_CASE`)**:
   - **Script-internal functions & local variables**: Private helper functions and `local` variables inside standalone scripts use `lower_snake_case` (e.g., `get_active_profile`, `local target_mode`).
   - **Constants & environment variables**: Exported environment variables and script-wide constants use `UPPER_SNAKE_CASE` (e.g., `TOOLS_HOME`, `CONFIG_DIR`).

## Architectural & safety principles
1. **Google Shell Style Guide**:
   - Follow the [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html): 2-space indentation, `[[ ... ]]` over `[ ... ]` in Bash, and routing all error/diagnostic messages to `stderr` (`>&2`).
2. **Executed vs. sourced script safety**:
   - **Standalone executed scripts**: Begin with `#!/usr/bin/env bash` and enforce strict mode (`set -euo pipefail`).
   - **Sourced environment scripts** (`.bashrc.d/*`, `*-env.sh`): Never use `set -e`, `set -u`, or `exit` at top level, as failures would terminate the user's interactive shell session; use `return` inside functions and guard fallible commands with `|| true`.
3. **Variable hygiene, quoting & resource safety**:
   - Always quote parameter expansions (`"${var}"`) to prevent word splitting and glob expansion.
   - Declare function-scoped variables with `local`. Separate `local var` declarations from `var="$(cmd)"` assignments when the command's exit status must be checked (`local` masks the subshell exit code).
   - Register deterministic cleanup traps (`trap 'rm -rf "${tmp_dir}"' EXIT INT TERM`) whenever creating temporary files or directories in standalone scripts.
   - Pass `--` before positional file or ref arguments (`rm -f -- "${target}"`, `cd -- "${dir}" || return`) to guard against leading-dash injection.

## Verification & testing standards
1. **Static analysis (`shellcheck`)**:
   - Always run [ShellCheck](https://www.shellcheck.net/) (`shellcheck <script>`) and resolve all warnings and errors before completing changes.
2. **Automated testing (`bats`)**:
   - Test non-trivial shell scripts and `.bashrc.d` launchers using [Bats](https://github.com/bats-core/bats-core) (`*.bats`).
   - Isolate test state in temporary sandboxes (`TEST_SANDBOX="$(mktemp -d)"`, overriding `HOME` or `PATH`) and clean up in `teardown()`.
