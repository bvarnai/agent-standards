# Git & branching conventions

## Branching model & history hygiene
- **Trunk-based workflow (`main`)**: `main` is the single integration branch and must always remain releasable. Create short-lived topic branches directly off `main`.
- **Branch naming**: Format topic branches as `<type>/<issue-id>-<kebab-slug>` (or `<type>/<kebab-slug>` when no issue ID exists), matching the commit type prefix (e.g., `feat/42-add-cache`, `fix/18-nil-pointer`).
- **Linear history**: Rebase topic branches onto `main` (`git fetch origin && git rebase origin/main`) rather than merging `main` into topic branches. Integrate pull requests via squash-merge or fast-forward.
- **Branch safety**: Never force-push (`--force` / `--force-with-lease`) to `main`. On topic branches, use `--force-with-lease` only after rebasing.

## Commit message conventions
- **Conventional commits**: Format all commit headers as `<type>(<scope>): <description>` (or `<type>: <description>` when scope is global) in lowercase imperative mood, under 72 characters, with no trailing period.
- **Allowed types**: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `ci`, `build`, `chore`.
- **Breaking changes**: Append `!` after the type/scope (`feat(cli)!: ...`) and include a `BREAKING CHANGE: <details>` footer when introducing backwards-incompatible changes.
- **Issue traceability**: Reference the source issue in the commit body or footer (`Closes #<id>` for completing an issue, `Refs #<id>` for partial/related work).

## Pull requests, tags & submodules
- **Minimal PR descriptions**: Link directly to the primary Git issue (`Closes #<id>`) and affected `docs/spec/` file(s) without duplicating the issue body.
- **Release tags**: Use annotated semantic version tags (`git tag -a vX.Y.Z -m "Release vX.Y.Z"`).
- **Submodules**: Commit submodule pointer updates in isolated, explicit commits (`chore(submodule): bump <name>`) only after the referenced commit has been pushed to the submodule remote.
