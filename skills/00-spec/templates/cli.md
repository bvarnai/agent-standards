# CLI technical specification templates

Use **Template A (`docs/spec/global.md`)** for application-wide CLI architecture and cross-cutting invariants, and **Template B (`docs/spec/<subcommand>.md`)** for individual subcommands.

Omit any optional section whose `Include when:` condition does not apply—never emit placeholder `"N/A"` sections.

---

## Template A: Global CLI specification (`docs/spec/global.md`)

```markdown
# Global technical specification: <binary-name>

## Core sections (always included)

### 1. Command signature & global flags
- **Invocation:** `<binary> [subcommand] [flags] [args]` (note plugin dispatch if applicable, e.g., `git <name> ...`).
- **Global flags:**

| Flag | Short | Type | Default | Description |
| :--- | :--- | :--- | :--- | :--- |
| `--help` | `-h` | `bool` | `false` | Print usage and exit `0`. |

- **Mutual exclusions:** e.g., `--verbose` with `--quiet` exits with `2`.

### 2. Exit code matrix

| Exit code | Error category | Semantic meaning | Common triggers |
| :--- | :--- | :--- | :--- |
| `0` | `—` | Success | Command completed cleanly. |
| `1` | `Runtime error` | General runtime error | Unhandled execution or I/O error. |
| `2` | `Usage error` | CLI usage / syntax error | Unknown flag, wrong argument count, mutual exclusion. |
| `130` | `Interrupted` | Process interrupted | `SIGINT` or `SIGTERM` cancellation. |

### 3. Invariants
State **Always** / **Never** architectural and safety rules (e.g., *Always validate inputs before mutating state; never write partial config files*).

### 4. Edge cases & boundary conditions
- Boundary inputs, empty/missing state, idempotency on re-run, and error-propagation rules.

---

## Optional sections (omit when not applicable)

### Subcommand registry
*Include when:* the tool has multiple subcommands.
| Subcommand | Target module / package | Spec file | Core responsibility |
| :--- | :--- | :--- | :--- |
| `<name>` | `<module/subcommand>` | `<name>.md` | Concise summary of subcommand responsibility. |

### Environment variables
*Include when:* the tool reads or injects environment variables.
| Variable | Direction (read/inject) | Purpose | Default / fallback | Validation |
| :--- | :--- | :--- | :--- | :--- |
| `<VAR>` | read | ... | ... | ... |

### Configuration cascade & schema
*Include when:* the tool loads configuration files.
- **Resolution order:** e.g., CLI flags -> repo/local config -> user global config -> defaults.
- **Schema & validation:** supported format (YAML/JSON/TOML), required keys, and path/injection guards.

### Subprocess safety & signal handling
*Include when:* the tool spawns external commands or traps `SIGINT`/`SIGTERM`.
- **Subprocess invocation:** direct execution without an intermediate shell, deterministic plumbing with NUL (`-z` / `%x00`) delimiters, `LC_ALL=C`, and `--` before positional refs/paths.
- **Signal & cleanup:** `SIGINT`/`SIGTERM` trapping, child grace period, lockfile release, and rollback of partial state.

### TTY, color & output streams
*Include when:* machine-parseable `stdout` vs. `stderr` diagnostics or color/TTY detection matters.
- **`stdout`:** primary data payload only; strip spinners/progress/pager escapes when non-TTY.
- **`stderr`:** diagnostics and structured prefixes (`[<bin>]`, `Warning:`, `Error:`).
- **Color resolution:** `--no-color` -> `<APP>_COLOR` -> `NO_COLOR` -> `TERM=dumb` -> `isatty`.

### Persistent storage & package layout
*Include when:* the tool writes state/metadata files or needs explicit dependency boundaries.
- **Storage & permissions:** file formats, atomic write/rename guarantees, and permissions (`0600`/`0755`).
- **Package layout & dependency direction:** entrypoint and module boundaries (`domain`/core <- infrastructure <- CLI layer).

### Legacy discrepancies & modernization decisions
*Include when:* reverse-engineering `/legacy` or reference code.
- **Legacy quirks & fixes:** fragile legacy behaviors replaced by the new design.
- **Identifier map:** renamed binaries, environment variables, config keys, and metadata files.
```

---

## Template B: Subcommand specification (`docs/spec/<subcommand>.md`)

Keep subcommand specs concise (~40–80 lines). Reference `docs/spec/global.md` rather than redefining global flags, shared structs, or global exit codes:

```markdown
# Spec: <binary-name> <subcommand>

## 1. Command signature
- **Usage:** `<binary> <subcommand> [flags] <args>`
- **Arguments:** positional arguments, cardinality, and path resolution rules.
- **Flags:** subcommand-specific flags (`-f`, `--flag <type>`: description and default) plus global flags from `docs/spec/global.md`.

## 2. Prerequisites *(include when the subcommand has preconditions or env/binary dependencies)*
- **Required host binaries / env vars:** subcommand-specific binaries or env vars.
- **State assertions:** preflight invariants (e.g., clean worktree, attached branch, no active rebase/merge).

## 3. Core execution flow
1. **Argument & preflight check:** validate args, flags, and preflight assertions.
2. **Domain logic:** exact state inspections, commands/mutations, and confirmation prompts (`-y` bypass).
3. **Completion / rollback:** output written and clean exit `0` (or rollback / `--dry-run` behavior).

## 4. Error handling & exit codes
| Exit code | Error category | Scenario | Emitted `stderr` pattern | Cleanup / side effects |
| :--- | :--- | :--- | :--- | :--- |
| `0` | `—` | Success | ... | None. |
| `...` | `...` | ... | `[<bin>] Error: ...` | ... |

## 5. Edge cases & behavioral notes
- Idempotency, pre-existing state, interruption cleanup, and boundary conditions.

## 6. Black-box verification scenarios *(include when specifying complex state flows)*
| Scenario ID | Given | When | Then (exit code, output, state) |
| :--- | :--- | :--- | :--- |
| `TC-01` | ... | `<binary> <subcommand> ...` | ... |
```
