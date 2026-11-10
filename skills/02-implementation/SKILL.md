---
name: 02-implementation
description: Implement features, refactors, or bug fixes strictly traceable to an approved specification or Git issue, enforcing stack-specific engineering standards, living spec synchronization, and automated test verification. Activate when implementing code, fixing bugs, or running /02-implementation.
metadata:
  lifecycle_stage: "02-implementation"
  mode: "interactive"
  recommended_flags: "--effort medium"
---

# 02 — Spec-driven implementation

## Constraints & domain rules
1. Read and enforce [strict-technical-tone.md](../../fragments/strict-technical-tone.md).
2. Read and enforce [spec-driven-core.md](../../rules/spec-driven-core.md).
3. Inspect `CWD` and consult [stack-routing.md](../../fragments/stack-routing.md) to load the active domain standards (`go-cli-standards.md`, `java-standards.md`, `embedded-standards.md`, `shell-standards.md`).

## Input contract & living spec synchronization
1. **Source of truth**:
   - Require an approved specification in `docs/spec/` or an explicit Git issue. If neither exists, halt and invoke `/01-spec-generation` or `/00-issue-generation` first.
   - When `docs/spec/global.md` exists alongside `docs/spec/<unit>.md`, read both `global.md` (for shared architecture, error codes, execution boundaries, and package dependency rules) and the target `<unit>.md` before writing code.
2. **Living spec sync (prevent spec drift)**:
   - In repositories that maintain `docs/spec/`, if the target Git issue introduces or modifies CLI flags, subcommands, public interfaces, configuration schemas, exit codes, or execution flows, update `docs/spec/` first (or in the same atomic change) so `docs/spec/` never drifts behind the implementation.

## Implementation workflows

### 1. Feature / refactor workflow
1. **Day-0 scaffolding (new repositories only)**: When bootstrapping a brand-new project from `docs/spec/`, initialize standard governance and build files (`LICENSE`, `README.md`, `CHANGELOG.md`, `.gitignore`, `.gitattributes` with `* text=auto eol=lf`, and `.github/workflows/ci.yml`).
2. **Boundary & domain implementation**: Implement narrow execution/runner interfaces (`Runner`, `Inspector`, `HAL`) and core domain logic in small, bisectable units matching the package dependency direction in `global.md`.
3. **Automated tests**: Write unit and black-box verification tests covering every Acceptance Criterion, Edge Case, and Error Matrix row in the spec/issue.

### 2. Bug fix / regression workflow (`fix:`)
1. **Reproduce first (TDD)**: Write a deterministic failing unit or integration test that reproduces the reported bug or edge case before modifying production logic.
2. **Root-cause fix**: Apply the minimal, idiomatic fix at the root cause (avoiding symptom-level workarounds).
3. **Spec check**: If the bug exposed an undocumented invariant or exit code trigger, update `docs/spec/` to lock in the expected behavior.

### 3. Verification gate
- Run the stack's automated test suite and static analysis commands from [stack-routing.md](../../fragments/stack-routing.md) (`go test -race ./...`, `go vet ./...`, `./mvnw test`, `shellcheck`, `bats`, `ctest`).
- Do not claim completion until all automated tests and linters pass with zero warnings or errors.

## Output contract & commit / PR handoff
Upon passing verification, output:
1. **Acceptance Criteria Verification Matrix**:
   | Acceptance Criterion / Edge Case | Status | Verifying Test / File |
   | :--- | :--- | :--- |
   | ... | Pass | `path/to/test_file:TestName` |
2. **Proposed Git Commit & PR Commands** (Wait for user confirmation before executing mutating Git commands):
   ```bash
   git add <modified-files>
   git commit -m "<type>(<scope>): <concise summary>" -m "Closes #<issue-id>"
   ```
   If opening a Pull Request, propose a minimal `gh pr create` command that links directly to `#<issue-id>` and `docs/spec/<unit>.md` without duplicating the issue body.
