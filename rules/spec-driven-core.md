# Spec-Driven Core Engineering Principles

The specification or issue is our primary source of truth. Every technical detail, test case, and edge case must reside here before modifying implementation code.

## Core Rules

1. **Issue & Spec Primacy**: Pull Requests and commit diffs must trace directly to an approved specification in `docs/spec/` or a Git issue. PR descriptions and reviews are strictly for verifying code quality against the specification.
2. **Acceptance Criteria Verification**: Code cannot be marked complete until every acceptance criterion has a corresponding automated test (or documented manual verification step).
3. **Atomic Changes**: Changes must be isolated, logically grouped, and bisectable. Avoid mixing refactors with functional additions or dependency updates.
4. **Documentation Integrity**: Preserve existing comments, docstrings, and architectural invariants unless explicitly instructed to update them.
5. **No Spec Drift**: If implementation reveals unforeseen technical blockers, update the specification or issue first before proceeding with divergent code.
