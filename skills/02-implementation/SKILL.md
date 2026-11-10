---
name: 02-implementation
description: Implement changes strictly traceable to an approved specification or Git issue, following stack-specific engineering standards and verifying via automated tests. Activate when implementing code or running /02-implementation.
metadata:
  lifecycle_stage: "02-implementation"
  mode: "interactive"
  recommended_flags: "--effort high"
---

# 02 — Spec-Driven Implementation

## Constraints & Domain Rules
1. Read and enforce [strict-technical-tone.md](../../fragments/strict-technical-tone.md).
2. Read and enforce [spec-driven-core.md](../../rules/spec-driven-core.md).
3. Inspect `CWD` and consult [stack-routing.md](../../fragments/stack-routing.md) to load the appropriate domain standards (`go-cli-standards.md`, `java-standards.md`, `embedded-standards.md`).

## Input Contract (Target Workspace CWD)
1. **Source of Truth**:
   - Require an approved specification in `docs/spec/` or an explicit Git issue. If neither exists, halt and invoke `/01-spec-generation` or `/00-issue-generation` first.
2. **Tool Execution Guidelines**:
   - Prefer native inspection tools (`list_dir`, `find_by_name`, `grep_search`, `view_file`).
   - Request explicit user approval before modifying existing files or creating new ones.
   - Request explicit user approval before executing mutating git commands or network downloads.

## Implementation Procedure
1. **Scaffold / Edit**: Implement changes in small, logical units. Ensure Unix (`LF`) line endings.
2. **Preserve Integrity**: Retain all unrelated existing comments, docstrings, and tests.
3. **Execute Verification**:
   - Run the stack test suite identified by `stack-routing.md` (e.g. `go test -race ./...`, `./mvnw test`, `ctest`).
   - Do not claim completion until automated tests pass cleanly with zero compiler warnings or lint errors.
