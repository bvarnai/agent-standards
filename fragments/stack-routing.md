# Stack detection & domain rule routing contract

When executing lifecycle skills in a target workspace, inspect the current working directory (`CWD`) and load the domain-specific rule matching the project's build and dependency markers.

| Marker in CWD / Root | Language / Domain | Rule to Read & Enforce | Verification Commands |
| :--- | :--- | :--- | :--- |
| `go.mod` | Go CLI / Backend | [go-cli-standards.md](../rules/go-cli-standards.md) | `go test -race ./...`, `go vet ./...` |
| `pom.xml`, `build.gradle`, `build.gradle.kts` | Java (JVM) | [java-standards.md](../rules/java-standards.md) | `./mvnw test` / `./gradlew check` |
| `CMakeLists.txt`, `platformio.ini`, `Kconfig`, `*.ld`, `Makefile` (firmware) | Embedded C / C++ | [embedded-standards.md](../rules/embedded-standards.md) | Target/host unit test runner, compiler zero-warning check |
| `*.sh`, `*.bats`, `.bashrc.d/`, `bin/` (shell scripts) | Shell / Bash | [shell-standards.md](../rules/shell-standards.md) | `shellcheck <files>`, `bats <tests>` |

## Multi-stack projects & auxiliary scripts
1. **Subdirectory scoping:** If a project contains multiple primary stack markers (e.g., a Go backend with embedded C firmware in a subdirectory), scope the domain rule to the specific component being modified.
2. **Primary stack vs. helper scripts:** When a Go, Java, or Embedded repository also contains auxiliary shell scripts (`scripts/*.sh`, `bin/*`), the primary build marker (`go.mod`, `pom.xml`, `CMakeLists.txt`) governs overall project architecture, while [shell-standards.md](../rules/shell-standards.md) additionally applies whenever authoring, editing, or auditing shell scripts and `.bats` tests.

## Unmatched stacks
If no known marker matches, follow the universal [spec-driven-core.md](../rules/spec-driven-core.md) principles and prompt the user for the primary test runner and linting commands before editing code.
