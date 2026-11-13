---
name: 01-issue
description: Strictly draft issues using the mandatory issue template with clear problem context, acceptance criteria, edge cases, and verification plans, saving the raw Markdown to .issue-draft.md. Activate whenever asked to write, draft, or generate an issue (feat:, fix:, refactor:, perf:, docs:, test:, ci:, build:, chore:) or running /01-issue.
metadata:
  lifecycle_stage: "01-issue"
  mode: "interactive"
  recommended_flags: "--effort medium"
---

# 01 — Issue drafting

## Constraints
- **Tone:** Follow [strict-technical-tone.md](../../fragments/strict-technical-tone.md).
- **Permission:** Create or overwrite `.issue-draft.md` in CWD.
- **Root-cause triage for `fix:` issues**: When drafting a bug/regression issue (`fix:`), inspect the relevant source files first to identify the concrete root cause, reproduction conditions, and whether `docs/spec/` requires an edge-case or error-matrix update.
- **Proportionality**: Scale depth to complexity. For trivial `chore:` or `docs:` issues, keep design bullets minimal and explicitly mark `Edge cases & failure modes` as `None (trivial change)` rather than inventing filler.
- **Pre-flight ambiguity check**: If the request lacks critical architectural context, ask at most 1–3 concise clarifying questions before generating the issue.

## Output contract (raw Markdown file)
1. Write the generated issue in raw GitHub Flavored Markdown (no outer ` ```markdown ` wrapper, and with HTML guidance comments stripped) directly to `.issue-draft.md` in `CWD` (`Overwrite: true`).
2. Output the rendered issue in chat and provide:
   - The issue title in commit convention format: `<type>(<component>): <title>`.
   - A clickable link to `.issue-draft.md`. The user creates the ticket from it in their own tracker.

## Issue layout template

Format the issue using the template below in GitHub Flavored Markdown:

```markdown
### [Type]: Short title (matching Git conventions)

**Problem / context**
<!-- Current state, root cause or motivation, and why this change is needed now. -->

**Proposed changes & technical design**
<!-- Concrete architectural approach, file/API/schema impacts, and explicit non-goals if applicable. -->
- **Affected files / components:** `path/to/file`
- **Design:** ...
- **Out of scope:** (Optional — omit if trivial)

**Acceptance criteria**
- [ ] Criterion 1 (Functional, testable requirement)
- [ ] Criterion 2 (Functional, testable requirement)

**Edge cases & failure modes**
<!-- Boundary conditions, race conditions, error propagation, or null-handling rules. Write "None (trivial change)" if N/A. -->

**Verification & testing plan**
- [ ] **Unit tests:** [Target coverage, specific test conditions, and exact stack runner command]
- [ ] **Manual / integration verification:** [Steps to verify the change works end-to-end]
```
