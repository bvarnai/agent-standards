# Model & effort recommendations

Detailed model picks and per-stage rationale for `agy` sessions. For the high-level 3-gear summary (**Think / Build / Mechanical**), see [README.md](../README.md#model--effort-mental-compass).

Choose the **model (`--model` / `/model`)** for its base instincts (**Gemini 4 Argon** for deep architectural synthesis vs. **Gemini 3.8** for surgical coding and fast tool loops) and **effort (`--effort`)** for per-turn thinking depth:

| Engineering goal | Lifecycle stages | Recommended model | Effort & mode | Why this combination works best |
| :--- | :--- | :--- | :--- | :--- |
| **System architecture, specs & cross-repo uplift** | `00-spec`<br>`06-harmonize` | **Gemini 4 Argon** | `--mode plan --effort high` | Deepest multi-file reasoning, legacy reverse-engineering, and interface/invariant synthesis before writing code. |
| **Pre-release readiness & cross-artifact audit** | `04-audit` | **Gemini 4 Argon** | `--effort high` | Holds Spec $\leftrightarrow$ Code $\leftrightarrow$ Docs $\leftrightarrow$ CI invariants in working memory simultaneously to catch subtle drift without false positives. |
| **Hands-on coding, TDD & tool execution loops** | `02-implement`<br>`01-issue` | **Gemini 3.8** | `--effort medium`<br>*(or `high` for race/concurrency bugs)* | Stronger coding instincts and surgical diffs; follows existing code style without over-abstraction and iterates faster across 10–20 edit/test steps. |
| **Documentation tone & accuracy review** | `03-docs` | **Gemini 3.8**<br>*(or **Gemini 4 Argon**)* | `--effort medium` | Verifies flags/examples against code while keeping developer prose direct, natural, and free of stiff AI phrasing. |
| **Mechanical release cut & changelog bump** | `05-release`<br>*(plus trivial `chore:`/`docs:` issues)* | **Gemini 3.8** *(or **Flash** / **Argon Low**)* | `--effort low` | Purely deterministic execution (SemVer bump, `CHANGELOG.md` move, Git tag staging); `low` prevents re-auditing and minimizes latency. |
