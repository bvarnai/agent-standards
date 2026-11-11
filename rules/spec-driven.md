# Spec-driven engineering principles

Technical specifications (`docs/spec/`) define the living state of the system, and issues define every planned unit of change (delta). Every technical detail, test case, and edge case must be captured in the issue and reflected in `docs/spec/` before or during implementation.

## Core rules

1. **Plan $\rightarrow$ Issue $\rightarrow$ Spec & Code workflow**:
   - **System specifications (`docs/spec/`)**: Author or bootstrap system and module specifications via `/00-spec` when starting a new project, adding a new module, or documenting existing code.
   - **Change tracking (issues)**: Explore and align on new features, refactors, or fixes in Plan mode (`--mode plan` / `/plan`), then crystallize the agreed plan into an issue via `/01-issue` before writing implementation code. Self-contained trivial fixes (`docs:`, `chore:`, `ci:`, or minor bug fixes that do not alter specs or interfaces) may skip `/01-issue` and go directly to implementation on a `<type>/<slug>` branch.
   - **Implementation (`/02-implement`)**: Pull requests and commit diffs must trace directly to the target issue and `docs/spec/`; PR descriptions and reviews are strictly for verifying code quality against them.
2. **Living spec synchronization (no spec drift)**:
   - Implementing an issue that adds or modifies CLI flags, subcommands, public APIs, configuration schemas, exit codes, or execution flows **must** update `docs/spec/` first (or in the same atomic change) so `docs/spec/` never drifts behind closed issues.
   - If implementation reveals unforeseen technical blockers, update the specification and issue first before proceeding with divergent code.
3. **Acceptance criteria verification**: Code cannot be marked complete until every acceptance criterion has a corresponding automated test (or documented manual verification step).
4. **Atomic changes**: Changes must be isolated, logically grouped, and bisectable. Avoid mixing refactors with functional additions or dependency updates.
5. **Documentation integrity**: Preserve existing comments, docstrings, and architectural invariants unless explicitly instructed to update them.
