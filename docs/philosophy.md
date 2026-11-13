# Engineering philosophy: Why this workflow exists

This document is for people deciding whether `agy-standards` fits how they work, or trying to understand why it behaves the way it does. It isn't loaded into the agent's context.

## The shift: Where did the thinking time go?

Before AI coding agents, writing syntax took most of the time. Typing out structs, error handling, and boilerplate took hours—and **during those hours, design happened in the background**. While writing code line by line, your mind turned the problem over and caught edge cases along the way:
- *"What if this file is a broken symlink?"*
- *"What if the user is offline?"*
- *"What exit code should this return?"*

With an LLM, 3 hours of syntax is generated in 10 seconds. The hidden thinking time that used to be blended into coding is gone—and the design work has surfaced to the front.

An LLM is like a very fast, very literal developer who cannot read your mind. If you don't specify how the code should behave, it doesn't pause to ask—it silently guesses using statistical averages and buries those assumptions inside hundreds of lines of plausible-looking code. Without planning and writing down what the code should do first, you don't save those 3 hours; you just spend them debugging subtle assumptions in code you didn't write.

---

## What this plugin is

`agy-standards` is a **pacing mechanism, not bureaucracy**. It puts a deliberate pause for human judgment right before the agent starts generating code, and keeps the mechanical parts (branching, syncing, PR hygiene) out of the way.

The workflow rests on the two artifacts described in the [README](../README.md#approach): specs and issues. Specs matter more with an agent than with a human teammate, because an agent reading existing code can't tell an intended invariant from an accidental bug. Only the spec can tell it which is which.

## Who decides what

The split is intentional: you own intent and irreversible actions, the agent owns the labor.

| You decide | The agent does |
| :--- | :--- |
| What the system should do (`docs/spec/`) | Interviews you about edge cases and drafts the spec |
| What changes next and what "done" means (issue, acceptance criteria) | Drafts the issue from your answers |
| Whether a change is ready to ship | Builds it and shows the evidence: passing tests and linters, and any spec ↔ code ↔ docs drift |
| Every commit, push, tag, and deletion | Proposes the exact commands and waits for confirmation |

If the agent hits a design question the spec doesn't answer, the intended behavior is to stop and ask, not to guess.

## How it's built, and why

| Layer | Loaded | Purpose | Why it's separate |
| :--- | :--- | :--- | :--- |
| **Rules** (`rules/`) | Always | Workflow, commit conventions, tool and approval policy | Kept small because they cost context on every turn |
| **Skills** (`skills/`) | When invoked (`/00-spec` … `/07-models`) | One lifecycle step each | Each step runs in its own session with its own effort level |
| **Standards** (`standards/`) | When a stack marker matches (`go.mod`, `pom.xml`, …) | Language-specific idioms and verification commands | A Go project doesn't need Java rules in context |
| **Fragments** (`fragments/`) | Referenced by skills | Shared constraints such as tone | Written once, reused everywhere |

[`git-brx`](https://github.com/bvarnai/git-brx) is a separate, optional companion for your side of the workflow. It brings its own branching conventions and turns them into concrete commands, so you don't have to speak fluent Git. Without it, the agent follows the project's own conventions.

Commits and branches are separate concerns. A commit records one piece of work, and it's usually written by the agent. A branch collects those pieces and decides how they're synced and merged. Which branch a piece of work belongs on is a human call, which is why `git brx create` asks for the branch type explicitly.

## Write it down first

This is an old habit, not a new process: before writing code, take a sheet of A4 paper and write down what the code should do—the inputs, the outputs, and what happens when things go wrong. It isn't about being slow or cautious. Writing it down is how you find out whether you actually understand the problem.

With an agent, that sheet matters more than ever, because it's the only place the design thinking still happens before the code appears. `docs/spec/` is the same sheet, kept in the repository so it outlives the session.

Keep it in the A4 spirit: boundaries, not internals. Flags, state transitions, error matrices, and *"always/never"* invariants, preferably as tables. Line-by-line logic belongs in the code. If a spec has grown into pages of prose, it has stopped being the sheet of paper.

Not every change needs one. A 2-line fix, a doc tweak, or a dependency bump goes straight to implementation without an issue.

## When it's not a good fit

- Throwaway scripts and one-off experiments, where there's no future reader to protect.
- Early exploration, when you can't describe the design yet. Build a rough, throwaway prototype first, then write down what you learned.
- Repositories without automated tests. The workflow treats passing tests as the definition of done, so without them it loses its main check.

For how to run the workflow day to day, see [Working effectively](../README.md#working-effectively).
