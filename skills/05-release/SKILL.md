---
name: 05-release
description: Calculate the next semantic version, update version manifests and CHANGELOG.md, and stage the release commit and annotated Git tag. Activate when preparing a release or running /05-release.
metadata:
  lifecycle_stage: "05-release"
  mode: "interactive"
  recommended_flags: "--effort low"
---

# 05 — Release

## Constraints & execution scope
1. **No re-auditing**: Assume `/04-pre-release-audit` is complete and all `P0` blockers are resolved. Do **not** re-audit documentation, CI workflows, governance files, or code quality.
2. **Tone**: Follow [strict-technical-tone.md](../../fragments/strict-technical-tone.md).
3. **Verification gate**: Never execute `git commit`, `git tag`, or `git push` without explicit user confirmation.

## Execution steps

### 1. Commit history analysis & SemVer calculation
- Inspect existing tags and commit history since the latest semantic version tag (`git describe --tags --abbrev=0` to `HEAD`).
- If the target version was not explicitly provided as an argument, calculate the next `X.Y.Z` Semantic Version:
  - `MAJOR`: Breaking CLI, API, schema, or behavioral changes.
  - `MINOR`: Backwards-compatible new features or subcommands.
  - `PATCH`: Backwards-compatible bug fixes, performance improvements, or security patches.

### 2. Manifest & version string update
- Inspect project manifests (`pom.xml`, `build.gradle`, `package.json`, `Cargo.toml`, `pyproject.toml`, `CMakeLists.txt`).
- Update hardcoded version strings to `X.Y.Z` (and lockfiles if required by the toolchain).
- **Note for Go CLIs**: If `internal/version/version.go` injects the version at build time via `-ldflags` / `debug.ReadBuildInfo()`, leave the default `"dev"` fallback untouched.

### 3. Changelog finalization (`CHANGELOG.md`)
- Update `CHANGELOG.md` following [Keep a Changelog](https://keepachangelog.com/en/1.1.0/):
  - Move entries under `## [Unreleased]` (or compile notable user-facing changes since the last tag, preserving `` (`#<id>`) `` issue/PR references) into `## [X.Y.Z] - YYYY-MM-DD` (leaving an empty `## [Unreleased]` heading above it).
  - Group entries strictly under relevant headers (`Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`). Exclude trivial internal commits unless they impact end-users.
  - Update the bottom reference compare links:
    ```markdown
    [Unreleased]: https://github.com/<owner>/<repo>/compare/vX.Y.Z...HEAD
    [X.Y.Z]: https://github.com/<owner>/<repo>/compare/v<prev>...vX.Y.Z
    ```

## Output contract & verification gate (stop before tagging)
Before executing any mutating Git commands, output:
1. **Calculated Version:** `vX.Y.Z` (with a 1-sentence technical justification based on the commit log).
2. **Modified Files:** List of updated manifests and the `CHANGELOG.md` diff.
3. **Proposed Commands:** The exact commands to run upon user approval:
   ```bash
   git add CHANGELOG.md <modified-manifests>
   git commit -m "chore(release): cut vX.Y.Z"
   git tag -a vX.Y.Z -m "Release vX.Y.Z"
   git push origin main --follow-tags
   ```

Wait for explicit confirmation before executing the Git commit, tag, or push commands.
