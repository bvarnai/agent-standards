# Spec-driven core engineering principles

The specification or issue is our primary source of truth. Every technical detail, test case, and edge case must reside here before modifying implementation code.

## Core rules

1. **Issue & spec primacy**: Pull requests and commit diffs must trace directly to an approved specification in `docs/spec/` or a Git issue. PR descriptions and reviews are strictly for verifying code quality against the specification.
2. **Living spec synchronization (no spec drift)**:
   - In repositories that maintain `docs/spec/`, implementing an issue that adds or modifies CLI flags, subcommands, public APIs, configuration schemas, exit codes, or execution flows **must** update `docs/spec/` first (or in the same atomic change) so `docs/spec/` never drifts behind closed issues.
   - If implementation reveals unforeseen technical blockers, update the specification or issue first before proceeding with divergent code.
3. **Acceptance criteria verification**: Code cannot be marked complete until every acceptance criterion has a corresponding automated test (or documented manual verification step).
4. **Atomic changes**: Changes must be isolated, logically grouped, and bisectable. Avoid mixing refactors with functional additions or dependency updates.
5. **Documentation integrity**: Preserve existing comments, docstrings, and architectural invariants unless explicitly instructed to update them.
