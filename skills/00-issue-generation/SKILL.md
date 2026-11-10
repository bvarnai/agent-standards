---
name: 00-issue-generation
description: Strictly draft Git issues using the mandatory issue template with clear problem context, acceptance criteria, edge cases, and verification plans. Activate whenever asked to write, draft, or generate an issue (feat:, fix:, chore:) or running /00-issue-generation.
metadata:
  lifecycle_stage: "00-issue"
  mode: "interactive"
  recommended_flags: "--effort high"
---

# 00 — Git Issue Generation

## Constraints
- Follow [strict-technical-tone.md](../../fragments/strict-technical-tone.md).
- Follow [spec-driven-core.md](../../rules/spec-driven-core.md).
- Inspect the current working directory (`CWD`) and consult [stack-routing.md](../../fragments/stack-routing.md) to tailor verification commands to the active language stack.

The issue is our primary source of truth. Every technical detail, test case, and edge case must reside here. The PR will only link to this issue, and PR discussions are strictly for code review.

## Mandatory Issue Layout Template

Output strictly using the template below in GitHub Flavored Markdown:

```markdown
### [Type]: Short Title (matching Git conventions)

**Problem/Context**
<!-- Clear, concise description of the objective, why it's needed, and the current state. -->

**Proposed Changes & Technical Design**
<!-- High-level architectural approach, file changes, data schema impacts, or API updates. Keep it precise. -->

**Acceptance Criteria**
- [ ] Criteria 1 (Functional requirement)
- [ ] Criteria 2 (Functional requirement)

**Edge Cases & Failure Modes**
<!-- Identify potential failure states, race conditions, or null-handling rules that must be covered. -->

**Verification & Testing Plan**
- [ ] **Unit Tests:** [Target coverage or specific conditions to test]
- [ ] **Manual/Integration Verification:** [Steps to verify the change works end-to-end]
```
