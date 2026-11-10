# CLI Technical Specification Templates

Use **Template A (`docs/spec/global.md`)** for application-wide CLI architecture and cross-cutting invariants, and **Template B (`docs/spec/<subcommand>.md`)** for individual subcommands.

---

## Template A: Global CLI Specification (`docs/spec/global.md`)

```markdown
# Global Technical Specification: <binary-name>

## 1. Binary & CLI Conventions
- **Binary Name & Invocation:** Direct invocation (`<binary> <subcommand> [flags] [args]`) and plugin dispatch if applicable (e.g., `git <name> <subcommand> [flags] [args]`).
- **Global Flags:** Markdown table (`Flag`, `Short`, `Type`, `Default`, `Description`) and mutual-exclusion rules (e.g., `--verbose` vs `--quiet` exits immediately with Exit Code `2`).
- **Output Protocols:**
  - **Standard Output (`stdout`):** Strictly reserved for primary data payloads and machine-parseable porcelain output; non-TTY/pipe behavior (strip spinners, progress bars, and pager escapes).
  - **Standard Error (`stderr`):** Dedicated exclusively to diagnostics, operational progress, and structured prefixes (`[<bin>] <msg>`, `Warning:`, `Error:`, `Hint:`, `Debug:`).
  - **Terminal Color & Ergonomics:** Resolution hierarchy (`--no-color` -> `<APP>_COLOR` -> `NO_COLOR` -> `TERM=dumb` -> `isatty`).

## 2. Environment & Runtime Context
- **Required Host Binaries:** Minimum versions (e.g., `git >= 2.25.0`), rationale, and explicit zero-dependency guarantees (replacing external shell utilities like `awk`, `sed`, `jq`, `mktemp` with native stdlib packages).
- **Environment Variables Read:** Markdown table (`Variable`, `Purpose`, `Default / Fallback`, `Validation Rules`).
- **Environment Variables Injected / Propagated:** Sanitized subprocess environment overrides (e.g., `LC_ALL=C`, `LANG=C`, `GIT_TERMINAL_PROMPT=0`, `GIT_ADVICE=0`) and hook variables.
- **Working Directory & Path Resolution:**
  - Repository/environment precondition assertions (worktree validation, bare repository and detached `HEAD` guards).
  - Subdirectory invocation normalization (`GIT_PREFIX` / caller `PWD` vs. repository root resolution).
  - Built-in help integration (`--help` man-page interception vs `-h` direct binary help).

## 3. Standard Exit Code Matrix
| Exit Code | Error Category / Sentinel | Semantic Meaning | Common Triggers |
| :--- | :--- | :--- | :--- |
| `0` | `nil` | Success | Command completed cleanly. |
| `1` | `ErrRuntime` | General Runtime Error | Unhandled execution, I/O, or hook error. |
| `2` | `ErrUsage` | CLI Usage / Syntax Error | Unknown flag, wrong argument count, mutually exclusive flags. |
| `...` | `...` | `...` | `...` |
| `130` | `ErrInterrupted` | Process Interrupted | `SIGINT` (Ctrl+C) or `SIGTERM` context cancellation. |

## 4. External Execution Boundary & Safety
- **Subprocess Invocation Standards:**
  - Deterministic plumbing over human-formatted porcelain commands; NUL-byte (`-z` / `%x00`) delimiters for path and log safety; `LC_ALL=C` enforcement.
  - Direct process execution (`exec.CommandContext`) without intermediate shell (`/bin/sh` or `cmd.exe`); `--` before positional ref/path arguments to prevent leading-dash injection.
- **Inspection vs. Preflight Checks:**
  - Separation between pure state telemetry (`Inspector` returning raw data without UI or exit-code coupling) and fatal invariant assertions (`checks` returning structured `AppError` mapped to exit codes).
- **Interruption & Signal Handling:**
  - `signal.NotifyContext` on `SIGINT`/`SIGTERM`, child termination grace period, lockfile release, and `defer` rollback of partial state or staging artifacts.

## 5. Persistent Storage, Config Schema & Shared Domain Models
- **Configuration Cascade & Schema:**
  - Multi-tier resolution order (User Global -> Shared Env Overlay -> Repo Local -> Auto-Discovery), YAML/JSON schema, and validation/security rules (path traversal, option/metacharacter injection guards).
- **Metadata & Storage Format:** Commit/file schemas, hook execution contracts, and directory/file permissions (`fs.FileMode`).
- **Target Package Layout & Dependency Boundaries:**
  - ASCII directory tree (`cmd/<binary>/main.go`, `internal/...`).
  - Strict dependency direction rules (`domain`/`errcode`/`term` <- infrastructure packages <- `cli`).
- **Shared Domain Models & Interfaces:** Core domain structs and execution boundary interfaces (`Runner`, `Inspector`, `Manager`).

## 6. Subcommand Registry
| Subcommand | Target Package | Spec File | Core Responsibility |
| :--- | :--- | :--- | :--- |
| `<name>` | `internal/cli` | `<name>.md` | Concise summary of subcommand responsibility. |

## 7. Legacy Discrepancies & Modernization Decisions (Include Only for Legacy Rewrites)
- **Legacy Quirks & Fixes:** Fragile legacy behaviors (unquoted paths, porcelain parsing, race conditions, non-atomic writes) and the modernized implementation replacing them.
- **Legacy-to-Modern Identifier Map:** Mapping table of renamed binaries, environment variables, config keys, and metadata files.
```

---

## Template B: Subcommand Specification (`docs/spec/<subcommand>.md`)

Keep subcommand specs concise (~50–100 lines). Reference `docs/spec/global.md` rather than redefining global flags, shared structs, or global exit codes:

```markdown
# Spec: <binary-name> <subcommand>

## 1. Command Signature
- **Usage:** `<binary> <subcommand> [flags] <args>`
- **Arguments:** Positional arguments with cardinality (mandatory/optional), types, and path resolution rules (caller `PWD` vs. repository root).
- **Flags:**
  - Subcommand-specific flags (`-f`, `--flag <type>`: description and default).
  - Standard global flags reference (`--help`/`-h`, `--version`, `--verbose`/`-v`, `--quiet`/`-q`, `--no-color`).

## 2. Prerequisites & Environment
- **Required Host Binaries:** Specific external binaries required by this subcommand.
- **Environment Variables Read / Injected:** Subcommand-specific env vars or hook variables.
- **Working Directory Requirements (`GIT_PREFIX` behavior):** Subdirectory invocation and path canonicalization rules.
- **State Assertions:** Preflight invariants that must hold before execution (e.g., inside worktree, attached branch, clean worktree, no active rebase/merge, no index lock).

## 3. Core Execution Flow
Provide a numbered, deterministic step-by-step specification of the subcommand's algorithm:
1. **Argument & Context Verification:** Positional argument count, flag validation, mutual exclusions, and preflight assertions.
2. **<Step 2..N (Domain Logic)>:** Exact state inspections, plumbing commands executed, configuration cascade lookups, interactive confirmation prompts (`-y` bypass), and mutations.
3. **Concurrency / Rollback / Dry-Run Handling:** Optimistic concurrency retries, `--dry-run` behavior, or `defer` cleanup on failure.
4. **Completion:** Output written to `stdout`/`stderr` and clean exit with Exit Code `0`.

## 4. Error Handling & Exit Codes
Map subcommand-specific failure scenarios to the global exit code matrix in Section 3 of `docs/spec/global.md`:
| Exit Code | Error Category | Scenario | Emitted Stderr Pattern | Cleanup / Side Effects |
| :--- | :--- | :--- | :--- | :--- |
| `0` | `nil` | Success | ... | None. |
| `...` | `...` | `...` | `[<bin>] Error: ...` | ... |

## 5. Edge Cases & Behavioral Notes
- **Idempotency & Pre-existing State:** Behavior when target branch/resource already exists or command is re-run.
- **Atomic Cleanup on Interruption:** Exact rollback behavior if interrupted mid-flight (`SIGINT`/`SIGTERM`).
- **Security & Boundary Conditions:** In-memory credential handling, metacharacter/leading-dash guards, offline/read-only modes.

## 6. Black-Box Verification Scenarios (Include When Specifying Complex State Flows)
| Scenario ID | Given (Repo & Filesystem State) | When (CLI Invocation) | Then (Expected Exit Code, `stdout`/`stderr`, & State) |
| :--- | :--- | :--- | :--- |
| `TC-01` | ... | `<binary> <subcommand> ...` | ... |
```
