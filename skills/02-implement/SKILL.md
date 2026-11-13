---
name: 02-implement
description: Implement features, refactors, or bug fixes strictly traceable to an approved specification or issue, enforcing stack-specific engineering standards, living spec synchronization, and automated test verification. Activate when implementing code, fixing bugs, or running /02-implement.
metadata:
  lifecycle_stage: "02-implement"
  mode: "interactive"
  recommended_flags: "--effort medium"
---

# 02 — Spec-driven implementation

## Constraints
- **Tone:** Follow [strict-technical-tone.md](../../fragments/strict-technical-tone.md).
- **Permission:** Create and edit source, test, `docs/spec/`, and user documentation files in CWD that the issue or spec requires.

## Input contract
1. **Source of truth**:
   - Require an explicit issue (or `.issue-draft.md` in `CWD`) and/or approved specification in `docs/spec/`. If neither exists, halt and invoke `/01-issue` or `/00-spec` first.
   - When `docs/spec/global.md` exists alongside `docs/spec/<unit>.md`, read both `global.md` (for shared architecture, error codes, execution boundaries, and package dependency rules) and the target `<unit>.md` before writing code.
2. **Topic branch check**:
   - Inspect `git branch --show-current`. If still on the default branch:
     - With `git-brx` on `PATH`: propose `git brx create issue/<id> -y` for a tracked issue. The user confirms or changes the branch type; follow the git-brx skill for everything after that.
     - Without `git-brx`: ask how the project creates branches. Do not invent a convention.

## Implementation workflows

### 1. Feature / refactor workflow
1. **Day-0 scaffolding (new repositories only)**: When bootstrapping a brand-new project from `docs/spec/`, initialize standard governance and build files (`LICENSE`, `README.md`, `CHANGELOG.md`, `.gitignore`, `.gitattributes` with `* text=auto eol=lf`, and `.github/workflows/ci.yml`).
2. **Boundary & domain implementation**: Implement narrow execution/runner interfaces (`Runner`, `Inspector`, `HAL`) and core domain logic in small, bisectable units matching the package dependency direction in `global.md`. Update `docs/spec/` and affected user-facing documentation (`README.md`, `docs/user-guide/`) in the same change when CLI flags, configuration keys, or user-visible behaviors change.
3. **Automated tests**: Write unit and black-box verification tests covering every Acceptance Criterion, Edge Case, and Error Matrix row in the spec/issue.

### 2. Bug fix / regression workflow (`fix:`)
1. **Reproduce first (TDD)**: Write a deterministic failing unit or integration test that reproduces the reported bug or edge case before modifying production logic.
2. **Root-cause fix**: Apply the minimal, idiomatic fix at the root cause (avoiding symptom-level workarounds).
3. **Spec check**: If the bug exposed an undocumented invariant or exit code trigger, update `docs/spec/` to lock in the expected behavior.

### 3. Verification gate
- Run the stack's automated test suite and static analysis commands from [`rules/stack-routing.md`](../../rules/stack-routing.md) (`go test -race ./...`, `go vet ./...`, `./mvnw test`, `shellcheck`, `bats`, `ctest`).
- Do not claim completion until all automated tests and linters pass with zero warnings or errors.

## Output contract & commit / PR handoff
Upon passing verification, output:
1. **Acceptance criteria verification matrix**:
   | Acceptance criterion / edge case | Status | Verifying test / file |
   | :--- | :--- | :--- |
   | ... | Pass | `path/to/test_file:TestName` |
2. **Proposed commit** (format from [`rules/git.md`](../../rules/git.md); keep `.issue-draft.md` untracked as the local work-unit spec—update it if scope changes mid-flight so the remote issue can be synced, and remove it only after the PR merges; wait for user confirmation before executing mutating Git commands):
   ```bash
   git add <modified-files>
   git commit -m "<type>(<component>): <concise summary>"
   ```
3. **Handoff**: with `git-brx` on `PATH`, continue with the git-brx skill (sync, publish, review). Without it, stop after the commit; the user publishes and opens the PR their own way.
