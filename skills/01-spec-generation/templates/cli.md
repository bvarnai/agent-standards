# CLI technical specification templates

Use **Template A (`docs/spec/global.md`)** for application-wide CLI architecture and cross-cutting invariants, and **Template B (`docs/spec/<subcommand>.md`)** for individual subcommands.

---

## Template A: Global CLI specification (`docs/spec/global.md`)

```markdown
# Global technical specification: <binary-name>

## 1. Binary & CLI conventions
- **Binary name & invocation:** Direct invocation (`<binary> <subcommand> [flags] [args]`) and plugin dispatch if applicable (e.g., `git <name> <subcommand> [flags] [args]`).
- **Global flags:** Markdown table (`Flag`, `Short`, `Type`, `Default`, `Description`) and mutual-exclusion rules (e.g., `--verbose` vs `--quiet` exits immediately with Exit Code `2`).
- **Output protocols:**
  - **Standard output (`stdout`):** Strictly reserved for primary data payloads and machine-parseable porcelain output; non-TTY/pipe behavior (strip spinners, progress bars, and pager escapes).
  - **Standard error (`stderr`):** Dedicated exclusively to diagnostics, operational progress, and structured prefixes (`[<bin>] <msg>`, `Warning:`, `Error:`, `Hint:`, `Debug:`).
  - **Terminal color & ergonomics:** Resolution hierarchy (`--no-color` -> `<APP>_COLOR` -> `NO_COLOR` -> `TERM=dumb` -> `isatty`).

## 2. Environment & runtime context
- **Required host binaries:** Minimum versions (e.g., `git >= 2.25.0`), rationale, and explicit zero-dependency guarantees (replacing external shell utilities like `awk`, `sed`, `jq`, `mktemp` with native stdlib packages).
- **Environment variables read:** Markdown table (`Variable`, `Purpose`, `Default / Fallback`, `Validation Rules`).
- **Environment variables injected / propagated:** Sanitized subprocess environment overrides (e.g., `LC_ALL=C`, `LANG=C`, `GIT_TERMINAL_PROMPT=0`, `GIT_ADVICE=0`) and hook variables.
- **Working directory & path resolution:**
  - Workspace/environment precondition assertions (e.g., repository/worktree validation, bare repository and detached `HEAD` guards when applicable).
  - Subdirectory invocation normalization (caller `PWD` vs. workspace root resolution; `GIT_PREFIX` handling for Git plugins).
  - Built-in help integration (`--help` man-page interception vs `-h` direct binary help).

## 3. Standard exit code matrix
| Exit code | Error category / sentinel | Semantic meaning | Common triggers |
| :--- | :--- | :--- | :--- |
| `0` | `nil` | Success | Command completed cleanly. |
| `1` | `ErrRuntime` | General runtime error | Unhandled execution, I/O, or hook error. |
| `2` | `ErrUsage` | CLI usage / syntax error | Unknown flag, wrong argument count, mutually exclusive flags. |
| `...` | `...` | `...` | `...` |
| `130` | `ErrInterrupted` | Process interrupted | `SIGINT` (Ctrl+C) or `SIGTERM` context cancellation. |

## 4. External execution boundary & safety
- **Subprocess invocation standards:**
  - Deterministic plumbing over human-formatted porcelain commands; NUL-byte (`-z` / `%x00`) delimiters for path and log safety; `LC_ALL=C` enforcement.
  - Direct process execution without an intermediate shell (e.g., `exec.CommandContext` in Go); pass `--` before positional ref/path arguments to prevent leading-dash injection.
- **Inspection vs. preflight checks:**
  - Separation between pure state telemetry (`Inspector` returning raw data without UI or exit-code coupling) and fatal invariant assertions (`checks` returning structured `AppError` mapped to exit codes).
- **Interruption & signal handling:**
  - Context/signal trapping on `SIGINT`/`SIGTERM` (e.g., `signal.NotifyContext` in Go or `trap ... INT TERM` in Shell), child termination grace period, lockfile release, and deterministic rollback of partial state or staging artifacts.

## 5. Persistent storage, config schema & shared domain models
- **Configuration cascade & schema:**
  - Multi-tier resolution order (User Global -> Shared Env Overlay -> Repo Local -> Auto-Discovery), YAML/JSON schema, and validation/security rules (path traversal, option/metacharacter injection guards).
- **Metadata & storage format:** Commit/file schemas, hook execution contracts, and directory/file permissions (e.g., `0600`/`0755` / `fs.FileMode`).
- **Target package / directory layout & dependency boundaries:**
  - ASCII directory tree (e.g., `cmd/<binary>/main.go`, `internal/...` for Go; `bin/`, `lib/`, `tests/` for Shell).
  - Strict dependency direction rules (`domain`/`errcode`/`term` <- infrastructure packages <- `cli`).
- **Shared domain models & interfaces:** Core domain structs and execution boundary interfaces (`Runner`, `Inspector`, `Manager`).

## 6. Subcommand registry
| Subcommand | Target package | Spec file | Core responsibility |
| :--- | :--- | :--- | :--- |
| `<name>` | `internal/cli` | `<name>.md` | Concise summary of subcommand responsibility. |

## 7. Legacy discrepancies & modernization decisions (include only for legacy rewrites)
- **Legacy quirks & fixes:** Fragile legacy behaviors (unquoted paths, porcelain parsing, race conditions, non-atomic writes) and the modernized implementation replacing them.
- **Legacy-to-modern identifier map:** Mapping table of renamed binaries, environment variables, config keys, and metadata files.
```

---

## Template B: Subcommand specification (`docs/spec/<subcommand>.md`)

Keep subcommand specs concise (~50–100 lines). Reference `docs/spec/global.md` rather than redefining global flags, shared structs, or global exit codes:

```markdown
# Spec: <binary-name> <subcommand>

## 1. Command signature
- **Usage:** `<binary> <subcommand> [flags] <args>`
- **Arguments:** Positional arguments with cardinality (mandatory/optional), types, and path resolution rules (caller `PWD` vs. repository root).
- **Flags:**
  - Subcommand-specific flags (`-f`, `--flag <type>`: description and default).
  - Standard global flags reference (`--help`/`-h`, `--version`, `--verbose`/`-v`, `--quiet`/`-q`, `--no-color`).

## 2. Prerequisites & environment
- **Required host binaries:** Specific external binaries required by this subcommand.
- **Environment variables read / injected:** Subcommand-specific env vars or hook variables.
- **Working directory requirements (`GIT_PREFIX` behavior):** Subdirectory invocation and path canonicalization rules.
- **State assertions:** Preflight invariants that must hold before execution (e.g., inside worktree, attached branch, clean worktree, no active rebase/merge, no index lock).

## 3. Core execution flow
Provide a numbered, deterministic step-by-step specification of the subcommand's algorithm:
1. **Argument & context verification:** Positional argument count, flag validation, mutual exclusions, and preflight assertions.
2. **<Step 2..N (domain logic)>:** Exact state inspections, plumbing commands executed, configuration cascade lookups, interactive confirmation prompts (`-y` bypass), and mutations.
3. **Concurrency / rollback / dry-run handling:** Optimistic concurrency retries, `--dry-run` behavior, or `defer` cleanup on failure.
4. **Completion:** Output written to `stdout`/`stderr` and clean exit with Exit Code `0`.

## 4. Error handling & exit codes
Map subcommand-specific failure scenarios to the global exit code matrix in Section 3 of `docs/spec/global.md`:
| Exit code | Error category | Scenario | Emitted stderr pattern | Cleanup / side effects |
| :--- | :--- | :--- | :--- | :--- |
| `0` | `nil` | Success | ... | None. |
| `...` | `...` | `...` | `[<bin>] Error: ...` | ... |

## 5. Edge cases & behavioral notes
- **Idempotency & pre-existing state:** Behavior when target branch/resource already exists or command is re-run.
- **Atomic cleanup on interruption:** Exact rollback behavior if interrupted mid-flight (`SIGINT`/`SIGTERM`).
- **Security & boundary conditions:** In-memory credential handling, metacharacter/leading-dash guards, offline/read-only modes.

## 6. Black-box verification scenarios (include when specifying complex state flows)
| Scenario ID | Given (repo & filesystem state) | When (CLI invocation) | Then (expected exit code, `stdout`/`stderr`, & state) |
| :--- | :--- | :--- | :--- |
| `TC-01` | ... | `<binary> <subcommand> ...` | ... |
```
