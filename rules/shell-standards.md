# Shell & Bash Engineering Standards

These standards apply whenever authoring or modifying shell scripts (`*.sh`, extensionless executables in `bin/` or `.local/bin/`), sourced environment files (`.bashrc*`, `.bashrc.d/*`), or Bats test suites (`*.bats`).

## Naming Conventions
1. **Public Interfaces (`kebab-case`)**:
   - **Public Callable Functions & Aliases**: Interactive shell functions and aliases exposed to the user session must use dash-separated names (e.g., `tools-shell`, `tools-reset`, `agy-work`, `repo-installer`) rather than underscores.
   - **Executable & Entrypoint Scripts**: Publicly invoked or sourced scripts in `bin/` or `.local/bin/` must use dash-separated filenames (e.g., `tools-env.sh`, `agy-switch`, `smart-copy`).
   - Do not mix underscores and dashes across public command interfaces.
2. **Internal Identifiers (`snake_case` / `UPPER_SNAKE_CASE`)**:
   - **Script-Internal Functions & Local Variables**: Private helper functions and `local` variables inside standalone scripts use `lower_snake_case` (e.g., `get_active_profile`, `local target_mode`).
   - **Constants & Environment Variables**: Exported environment variables and script-wide constants use `UPPER_SNAKE_CASE` (e.g., `TOOLS_HOME`, `CONFIG_DIR`).

## Architectural & Safety Principles
1. **Google Shell Style Guide**:
   - Follow the [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html): 2-space indentation, `[[ ... ]]` over `[ ... ]` in Bash, and routing all error/diagnostic messages to `stderr` (`>&2`).
2. **Executed vs. Sourced Script Safety**:
   - **Standalone Executed Scripts**: Begin with `#!/usr/bin/env bash` and enforce strict mode (`set -euo pipefail`).
   - **Sourced Environment Scripts** (`.bashrc.d/*`, `*-env.sh`): Never use `set -e`, `set -u`, or `exit` at top level, as failures would terminate the user's interactive shell session; use `return` inside functions and guard fallible commands with `|| true`.
3. **Variable Hygiene & Quoting**:
   - Always quote parameter expansions (`"${var}"`) to prevent word splitting and glob expansion.
   - Declare function-scoped variables with `local`. Separate `local var` declarations from `var="$(cmd)"` assignments when the command's exit status must be checked (`local` masks the subshell exit code).

## Verification & Testing Standards
1. **Static Analysis (`shellcheck`)**:
   - Always run [ShellCheck](https://www.shellcheck.net/) (`shellcheck <script>`) and resolve all warnings and errors before completing changes.
2. **Automated Testing (`bats`)**:
   - Test non-trivial shell scripts and `.bashrc.d` launchers using [Bats](https://github.com/bats-core/bats-core) (`*.bats`).
   - Isolate test state in temporary sandboxes (`TEST_SANDBOX="$(mktemp -d)"`, overriding `HOME` or `PATH`) and clean up in `teardown()`.
