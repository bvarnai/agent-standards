# Stack detection & domain rule routing

Whenever planning (`--mode plan` / `/plan`), designing, drafting issues or specs, implementing, or auditing code in a workspace, inspect the current working directory (`CWD`) and read the matching domain standard(s) before proceeding:

| Marker in CWD / root | Language / domain | Standard to read & enforce | Verification commands |
| :--- | :--- | :--- | :--- |
| `go.mod` | Go CLI / backend | [`standards/go-cli.md`](../standards/go-cli.md) | `go test -race ./...`, `go vet ./...` |
| `pom.xml`, `build.gradle`, `build.gradle.kts` | Java (JVM) | [`standards/java.md`](../standards/java.md) | `./mvnw test` / `./gradlew check` |
| `CMakeLists.txt`, `platformio.ini`, `Kconfig`, `*.ld`, `Makefile` (firmware) | Embedded C / C++ | [`standards/embedded.md`](../standards/embedded.md) | Target/host unit test runner, compiler zero-warning check |
| `*.sh`, `*.bats`, `.bashrc.d/`, `bin/` (shell scripts) | Shell / Bash | [`standards/shell.md`](../standards/shell.md) | `shellcheck <files>`, `bats <tests>` |

## Multi-stack projects & auxiliary scripts
1. **Subdirectory scoping**: If a project contains multiple primary stack markers (e.g., a Go backend with embedded C firmware in a subdirectory), scope the domain standard to the specific component being modified.
2. **Primary stack vs. helper scripts**: When a Go, Java, or Embedded repository also contains auxiliary shell scripts (`scripts/*.sh`, `bin/*`), the primary build marker (`go.mod`, `pom.xml`, `CMakeLists.txt`) governs overall project architecture, while [`standards/shell.md`](../standards/shell.md) additionally applies whenever authoring, editing, or auditing shell scripts and `.bats` tests.
3. **Unmatched stacks**: If no known marker matches, follow [`spec-driven.md`](./spec-driven.md) and confirm the primary test runner and linting commands with the user before editing code.
