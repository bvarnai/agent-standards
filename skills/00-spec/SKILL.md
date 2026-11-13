---
name: 00-spec
description: Author or update authoritative technical specifications under docs/spec/ (global.md for system-wide architecture/invariants and <unit>.md for subcommands or modules) before writing implementation code. Activate when planning architecture, reverse-engineering legacy code, or running /00-spec.
metadata:
  lifecycle_stage: "00-spec"
  mode: "interactive"
  recommended_flags: "--mode plan --effort high"
---

# 00 — Technical specification authoring

## Constraints
- Read and enforce [strict-technical-tone.md](../../fragments/strict-technical-tone.md).
- **Permission:** Create and edit files under `docs/spec/` in CWD.

## Domain template routing
Select and read the specification template matching the target system's domain before drafting:

| Project domain | Template to load | Topology |
| :--- | :--- | :--- |
| **CLI application / Shell toolkit** (Go, Shell/Bash, Rust, Python, C/C++) | [templates/cli.md](./templates/cli.md) | `docs/spec/global.md` + `docs/spec/<subcommand>.md` (or `global.md` only for single-command tools) |
| **Other domains** (Library, service, firmware) | Fallback outline below (until a domain template is added under `templates/`) | `docs/spec/global.md` + optional `docs/spec/<module>.md` |

## Core authoring directives
1. **Strict global alignment (DRY)**:
   - `docs/spec/global.md` is the single source of truth for cross-cutting concerns, shared flags/options, configuration schemas, error codes, external execution boundaries, package layout, and shared domain models.
   - `docs/spec/<unit>.md` must reference `global.md` and never redefine global flags, shared structs, or global error sentinels.
   - Do not overengineer topology: split into `<unit>.md` files only when the project has multiple distinct subcommands or modules.
2. **Incremental spec evolution (Day-2 updates)**:
   - When updating existing specifications in `docs/spec/` for a new feature or issue, preserve unrelated sections verbatim and update both `global.md` (if shared flags, schemas, subcommand registries, or exit codes change) and the affected `<unit>.md`.
3. **Decoupled testability boundary**:
   - Specify narrow execution/runner interfaces (`Runner`, `Inspector`, `Manager`, `HAL`) in `global.md` so domain logic in `<unit>.md` can be unit-tested in isolation from CLI/transport/hardware layers.
4. **Legacy reverse-engineering mode (when `/legacy` or reference code exists)**:
   - Abstract away source-language mechanics (e.g., Bash subshells, `awk`/`sed` pipelines, unquoted globals) into idiomatic target-stack contracts and stdlib equivalents.
   - Clean-break modernization: fix fragile legacy behaviors (race conditions, non-atomic writes, localized porcelain parsing) rather than preserving bugs, and include the conditional **Legacy discrepancies & modernization decisions** section in `global.md`.
5. **Pre-flight ambiguity check**:
   - Inspect `README.md`, build markers, existing `docs/spec/` files, and any `/legacy` sources first. If critical architectural decisions remain ambiguous, ask concise clarifying questions before generating the spec.

## Fallback outline for non-CLI domains
When authoring specifications for non-CLI domains without a dedicated file in `templates/`, structure `docs/spec/global.md` (and optional `docs/spec/<module>.md`) covering:
1. **System overview & public interface / protocol conventions**
2. **Runtime environment, dependencies & configuration schema**
3. **Error taxonomy & fault / status code matrix**
4. **Execution boundaries, concurrency & resource/ISR safety**
5. **Package / module architecture & shared domain models**
6. **Module registry & verification plan**
