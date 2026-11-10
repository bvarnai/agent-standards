---
name: 05-release-cut
description: Execute release preparation including version bump, changelog finalization, release commit staging, and tag verification. Activate when cutting a release or running /05-release-cut.
metadata:
  lifecycle_stage: "05-release"
  mode: "interactive"
  recommended_flags: "--effort high"
---

# 05 — Release Cut

## Constraints
1. Read and enforce [strict-technical-tone.md](../../fragments/strict-technical-tone.md).
2. Read and enforce [spec-driven-core.md](../../rules/spec-driven-core.md).
3. **Safety Gate**: Do not execute git tags or release commits without user approval. All git mutating commands require explicit user confirmation.

## Input Contract (Target Workspace CWD)
1. **Pre-Requisite**: The workspace must have passed `/04-pre-release-audit` with a **GO** verdict.
2. **User Input**: Target semantic version (e.g. `v1.2.0`). If omitted, inspect git tags and propose the next semver based on unreleased changelog changes.

## Execution Steps
1. **Changelog Finalization**:
   - Update `CHANGELOG.md`: move items from `## [Unreleased]` under `## [vX.Y.Z] - YYYY-MM-DD`.
   - Ensure categories are formatted clearly (`Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`).
2. **Version Bump**:
   - Update version strings in project manifest files (`package.json`, `pom.xml`, `version.go`, etc.).
3. **Final Sanity Build**:
   - Run the fast test suite to confirm version bumps did not introduce syntax or build errors.
4. **Draft Release Notes & Git Commands**:
   - Present the finalized changelog diff and exact git commands for user approval:
     ```bash
     git add CHANGELOG.md ...
     git commit -m "chore(release): cut vX.Y.Z"
     git tag -a vX.Y.Z -m "Release vX.Y.Z"
     ```
