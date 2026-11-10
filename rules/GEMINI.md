# Platform Environment & Execution Baseline

@[Spec-Driven Core](./spec-driven-core.md)

## Issue Drafting Trigger
Whenever the user asks you to write, draft, or generate an "issue" (e.g. using prefix `feat:`, `fix:`, `chore:`), activate the `00-issue-generation` skill, output the Mandatory Issue Layout Template, and write the raw Markdown directly to `.issue-draft.md` in `CWD` (`Overwrite: true`, pre-authorized without requiring an extra confirmation prompt).

## Platform Environment Assumptions
- **Windows:** Assume `agy` is running in a Git Bash environment. The `agy` executable is launched from a Git Bash shell directly.
- **Linux:** Assume it is a WSL-based Ubuntu instance. The `agy` executable is launched from a Bash shell directly.

## Line Endings
- **LF Line Endings:** Always use Unix-style (`LF`) line endings when generating or modifying files, even when operating on Windows.

## Tool Policy & Execution Guidelines
To ensure maximum execution speed, avoid unnecessary shell process prompts, and maintain safety across all projects:

### 1. Preferred Native Inspection Tools (Zero Friction)
Always prioritize native structured tools for repository exploration, search, and inspection:
- Use directory listing tools to inspect structures and folder contents (instead of `ls` via `run_command`).
- Use filename search tools to locate files and globs (instead of `find`).
- Use text search / grep tools to search patterns across the codebase (instead of `grep` or `ripgrep`).
- Use file reading tools to read files, transcripts, or documentation (instead of `cat`, `head`, or `tail`).

### 2. Auto-Approved Safe Inspection (When Shell is Required)
When bash execution is strictly necessary for read-only inspection or git queries, non-destructive commands are safe:
- Non-mutating inspection: `ls`, `find`, `grep`, `sort`, `cat`, `head`, `tail`, `wc`, `diff`, `file`, `stat`.
- Safe git inspection: `git status`, `git log`, `git diff`, `git show`, `git branch`, `git rev-parse`.

### 3. Actions Requiring Explicit User Prompt / Confirmation
The agent must request explicit user approval or wait for explicit instruction before executing:
- Modifying existing files or creating new project files.
- Deleting, moving, or renaming files (`rm`, `mv`).
- Mutating git actions (`git add`, `git commit`, `git push`, `git checkout`, `git reset`, `git rebase`, `git clean`).
- Network operations or package installations (`curl`, `wget`, `pip`, `npm`, `apt`, `mvn`, `go install`).
