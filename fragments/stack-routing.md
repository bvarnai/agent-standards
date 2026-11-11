# Stack detection & domain rule routing contract

When executing lifecycle skills in a target workspace, inspect the current working directory (`CWD`) and load the domain-specific rule matching the project's build and dependency markers.

| Marker in CWD / root | Language / domain | Rule to read & enforce | Verification commands |
| :--- | :--- | :--- | :--- |
| `go.mod` | Go CLI / backend | [go-cli.md](../standards/go-cli.md) | `go test -race ./...`, `go vet ./...` |
| `pom.xml`, `build.gradle`, `build.gradle.kts` | Java (JVM) | [java.md](../standards/java.md) | `./mvnw test` / `./gradlew check` |
| `CMakeLists.txt`, `platformio.ini`, `Kconfig`, `*.ld`, `Makefile` (firmware) | Embedded C / C++ | [embedded.md](../standards/embedded.md) | Target/host unit test runner, compiler zero-warning check |
| `*.sh`, `*.bats`, `.bashrc.d/`, `bin/` (shell scripts) | Shell / Bash | [shell.md](../standards/shell.md) | `shellcheck <files>`, `bats <tests>` |

## Multi-stack projects & auxiliary scripts
1. **Subdirectory scoping:** If a project contains multiple primary stack markers (e.g., a Go backend with embedded C firmware in a subdirectory), scope the domain rule to the specific component being modified.
2. **Primary stack vs. helper scripts:** When a Go, Java, or Embedded repository also contains auxiliary shell scripts (`scripts/*.sh`, `bin/*`), the primary build marker (`go.mod`, `pom.xml`, `CMakeLists.txt`) governs overall project architecture, while [shell.md](../standards/shell.md) additionally applies whenever authoring, editing, or auditing shell scripts and `.bats` tests.

## Unmatched stacks
If no known marker matches, follow the universal [spec-driven.md](../rules/spec-driven.md) principles and prompt the user for the primary test runner and linting commands before editing code.
