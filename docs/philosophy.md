# Engineering philosophy: Why this workflow exists

## The shift: Where did the thinking time go?

Before AI coding agents, writing syntax took most of the time. Typing out structs, error handling, and boilerplate took hours—and **during those hours, design happened in the background**. While writing code line by line, your mind naturally turned the problem over and caught edge cases along the way:
- *"What if this file is a broken symlink?"*
- *"What if the user is offline?"*
- *"What exit code should this return?"*

With an LLM, 3 hours of syntax is generated in 10 seconds. The hidden thinking time that used to be blended into coding is gone—and the design work has surfaced to the front.

An LLM is like a very fast, very literal developer who cannot read your mind. If you don't specify how the code should behave, it doesn't pause to ask—it silently guesses using statistical averages and buries those assumptions inside hundreds of lines of plausible-looking code. Without planning and writing down what the code should do first, you don't save those 3 hours; you just spend them debugging subtle assumptions in code you didn't write.

---

## Takeaways

### 1. This workflow is a pacing mechanism, not bureaucracy
`agy-standards` and `git-brx` exist to put a deliberate pause for human engineering judgment right before the AI hits the gas pedal:
- **`docs/spec/` (The living contract)**: Defines what the system *is*—interfaces, flags, exit codes, and invariants. Without a spec, an agent reading existing code cannot tell the difference between an intended invariant and an accidental bug.
- **Issues (The bounded delta)**: Defines what changes next, which edge cases matter, and how to verify it.
- **`git-brx` (The mechanical rails)**: Automates branch creation, syncing, and PR hygiene so the discipline costs almost zero keystrokes.

### 2. How to keep specs from feeling too verbose
Specs become a chore when they turn into walls of AI-generated prose or try to describe internal helper functions in English.
- **Don't write the spec alone—use `--mode plan` as an interview**: Give a rough 2-sentence idea and ask `agy` to challenge the edge cases and trade-offs. Answering 4 sharp questions triggers the same design discovery that used to happen while coding by hand. Let `/00-spec` or `/01-issue` draft the Markdown from your answers.
- **Prefer tables and invariants over paragraphs**: Document boundaries (CLI flags, state transitions, error matrices, and *"Always/Never"* invariants). Leave internal line-by-line logic to the code.
- **Spike when you don't know the design yet**: Sometimes you can't know the right design in words until you see a rough prototype. Spin up a `<type>/<slug>` branch, let the AI prototype it, see what works, and then lock the real design into `docs/spec/`.
- **Skip the ceremony for trivial fixes**: A 2-line bug fix, doc tweak, or dependency bump doesn't need an issue draft—use the fast-path and ship it.
