# Platform environment & execution baseline

@[Spec-driven core](./spec-driven-core.md)

## Issue drafting trigger
Whenever the user asks you to write, draft, or generate an "issue" (e.g. using prefix `feat:`, `fix:`, `refactor:`, `perf:`, `docs:`, `test:`, `ci:`, `build:`, `chore:`), activate the `00-issue-generation` skill, output the mandatory issue layout template, and write the raw Markdown directly to `.issue-draft.md` in `CWD` (`Overwrite: true`, pre-authorized without requiring an extra confirmation prompt).

## Git commit & branch hygiene
- **Conventional commits:** Format all commit messages as `<type>(<scope>): <description>` in lowercase imperative mood (`feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `ci`, `build`, `chore`), referencing the source issue (`Closes #<id>` or `Refs #<id>`) in the commit body or footer when applicable.
- **Branch naming:** Use `<type>/<issue-id>-<kebab-slug>` (or `<type>/<kebab-slug>` when no issue ID exists).
- **Pull requests:** Keep PR descriptions minimal—link directly to the primary Git issue and `docs/spec/` file(s) without duplicating the issue body.

## Platform environment assumptions
- **Windows:** Assume `agy` is running in a Git Bash environment. The `agy` executable is launched from a Git Bash shell directly.
- **Linux:** Assume it is a WSL-based Ubuntu instance. The `agy` executable is launched from a Bash shell directly.

## Line endings & Markdown formatting
- **LF line endings:** Always use Unix-style (`LF`) line endings when generating or modifying files, even when operating on Windows.
- **Sentence-case headings:** Always use sentence case for Markdown headings and titles (e.g., `## Multi-stack domain rule routing`, not `## Multi-Stack Domain Rule Routing`). Capitalize only the first word and proper nouns, acronyms, or exact code identifiers (`Git`, `CLI`, `POSIX`, `Go`, `Java`, `WSL`, `CWD`).

## Tool policy & execution guidelines
To ensure maximum execution speed, avoid unnecessary shell process prompts, and maintain safety across all projects:

### 1. Preferred native inspection tools (zero friction)
Always prioritize native structured tools for repository exploration, search, and inspection:
- Use native file reading tools (`read_file` / `view_file`) to read files, transcripts, or documentation (instead of `cat`, `head`, or `tail`).
- Use native directory listing, filename search, and grep tools when exposed in the active environment; when running in a CLI session where only `read_file` and `run_command` are exposed, immediately use the auto-approved safe inspection shell commands below.

### 2. Auto-approved safe inspection (when shell is required)
When bash execution is necessary for read-only inspection or git queries, non-destructive commands are safe:
- **Non-mutating inspection:** `ls`, `tree`, `find`, `grep`, `sort`, `cat`, `head`, `tail`, `wc`, `diff`, `file`, `stat`, `which`, `type`, `pwd`, `printenv`, `uname`, `realpath`, `readlink`, `dirname`, `basename`, `jq`, `shellcheck`.
- **Safe git inspection:** `git status`, `git log`, `git diff`, `git show`, `git branch`, `git tag -l`, `git rev-parse`, `git describe`, `git remote -v`.
- **Zero-prompt command formatting (prefix allowlist compliance):**
  - **No compound operators:** Never chain read-only commands with pipes (`|`), logical operators (`&&`, `||`, `;`), subshells (`$(...)`), or redirects (`>`, `2>&1`). Execute a single command per `run_command` call (use parallel tool calls if multiple queries are needed).
  - **No redundant `git -C`:** Never use `git -C <path>` when inspecting the active `CWD` repository; run `git status`, `git log`, `git diff` directly so `agy`'s command-prefix cache matches.
  - **Relative paths inside `CWD`:** Always use `.` or relative subdirectory paths (e.g. `find . -maxdepth 3`, `grep -rn "pattern" .`) rather than absolute paths when inspecting the current workspace.

### 3. Actions requiring explicit user prompt / confirmation
The agent must request explicit user approval or wait for explicit instruction before executing:
- Modifying existing project files (`edit_file` / `replace_file_content`) or creating new project files (`write_file` / `write_to_file`), unless pre-authorized by an explicitly invoked skill contract (such as writing `.issue-draft.md` in `/00-issue-generation`).
- Deleting, moving, or renaming files (`rm`, `mv`).
- Mutating git actions (`git add`, `git commit`, `git push`, `git tag`, `git checkout`, `git reset`, `git rebase`, `git clean`).
- Network operations or package installations (`curl`, `wget`, `pip`, `npm`, `apt`, `mvn`, `go install`).
