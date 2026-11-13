---
name: 05-release
description: Calculate the next semantic version, prepare CHANGELOG.md and version manifests via the project's branch/PR flow, and tag the updated default branch. Activate when preparing a release or running /05-release.
metadata:
  lifecycle_stage: "05-release"
  mode: "interactive"
  recommended_flags: "--effort low"
---

# 05 — Release

## Constraints & execution scope
- **Permission:** Edit `CHANGELOG.md` and version strings in build manifests in CWD.
1. **No re-auditing**: Assume `/04-audit` is complete and all `P0` blockers are resolved. Do **not** re-audit documentation, CI workflows, governance files, or code quality.
2. **Tone**: Follow [strict-technical-tone.md](../../fragments/strict-technical-tone.md).
3. **Verification gate**: Never commit on or push the default branch. Never execute `git commit`, `git tag`, or `git push` without explicit user confirmation.

## Execution steps

### 1. Pre-flight & SemVer calculation
- Verify a clean working tree (`git status --porcelain` is empty) and run `git fetch`.
- Inspect the latest tag with `git describe --tags --abbrev=0`:
  - **No tags yet (first release):** Use the version provided as an argument, or propose `0.1.0`.
  - **Non-SemVer tag** (does not match `vX.Y.Z`, e.g., `release-3`): Ask the user for the target version instead of guessing.
- Otherwise inspect commits from `<last-tag>..HEAD` and calculate the next `X.Y.Z` Semantic Version (unless passed as an argument):
  - `MAJOR`: Breaking CLI, API, schema, or behavioral changes (while `MAJOR` is `0`, breaking changes bump `MINOR` instead).
  - `MINOR`: Backwards-compatible new features or subcommands.
  - `PATCH`: Backwards-compatible bug fixes, performance improvements, or security patches.

### 2. Release readiness check & artifact updates
Inspect `CHANGELOG.md` and project manifests (`pom.xml`, `build.gradle`, `package.json`, `Cargo.toml`, `pyproject.toml`, `CMakeLists.txt`). For Go CLIs injecting version via `-ldflags` / `debug.ReadBuildInfo()`, leave the `"dev"` fallback untouched.

- **If release artifacts need updating** (`CHANGELOG.md` does not yet have `## [X.Y.Z]` or still has entries under `## [Unreleased]`, or a manifest has an older hardcoded version):
  1. Run `date +%F` for `YYYY-MM-DD` (never infer the date).
  2. Update hardcoded manifest version strings to `X.Y.Z` (and lockfiles if required by the toolchain).
  3. Update `CHANGELOG.md` following [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) (creating it with `## [Unreleased]` and `## [X.Y.Z] - YYYY-MM-DD` if it does not exist):
     - Move entries under `## [Unreleased]` (or compile notable user-facing changes since the last tag, preserving `` (`#<id>`) `` references) into `## [X.Y.Z] - YYYY-MM-DD`, leaving an empty `## [Unreleased]` heading above it.
     - Group entries under `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`.
     - Update reference compare links at the bottom only if existing reference links are already present, matching their host and URL format. Leave compare links out if none exist or if this is a first release.
  4. **Stop without proposing a tag.** Output the calculated version and modified files, and instruct the user to:
     - Commit (`chore(release): prepare vX.Y.Z`) and merge via the project's branch/PR flow (if on the default branch, branch first via `git-brx` or the project's convention).
     - Update the default branch and re-run `/05-release`.

- **If already ready** (`## [X.Y.Z]` already exists in `CHANGELOG.md` with an empty `## [Unreleased]`—even if the PR date differs from today—and manifests match `X.Y.Z`, or the repository has no hardcoded manifest versions or `CHANGELOG.md` to update):
  1. Do not treat `chore(release): prepare vX.Y.Z` as unreleased work.
  2. Verify the working tree is on the default branch and `HEAD` matches `origin/<default>`. If behind or diverged, stop and tell the user to update the default branch before tagging.

## Output contract & verification gate (tag-ready state)
Before executing any mutating Git commands, output:
1. **Calculated version:** `vX.Y.Z` (with a 1-sentence technical justification based on the commit log).
2. **Target commit:** Exact `HEAD` commit from `git log -1 --oneline` so the user can verify what is being tagged.
3. **Proposed commands:**
   ```bash
   git tag -a vX.Y.Z -m "Release vX.Y.Z"
   git push origin vX.Y.Z
   ```

Wait for explicit confirmation before executing `git tag` or `git push`. Publishing a release on a Git host is up to the user.
