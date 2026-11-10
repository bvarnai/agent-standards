# Stack Detection & Domain Rule Routing Contract

When executing lifecycle skills in a target workspace, inspect the current working directory (`CWD`) and load the domain-specific rule matching the project's build and dependency markers.

| Marker in CWD / Root | Language / Domain | Rule to Read & Enforce | Verification Commands |
| :--- | :--- | :--- | :--- |
| `go.mod` | Go CLI / Backend | [go-cli-standards.md](../rules/go-cli-standards.md) | `go test -race ./...`, `go vet ./...` |
| `pom.xml`, `build.gradle`, `build.gradle.kts` | Java (JVM) | [java-standards.md](../rules/java-standards.md) | `./mvnw test` / `./gradlew check` |
| `CMakeLists.txt`, `platformio.ini`, `Kconfig`, `*.ld`, `Makefile` (firmware) | Embedded C / C++ | [embedded-standards.md](../rules/embedded-standards.md) | Target/host unit test runner, compiler zero-warning check |

## Multi-Stack Projects
If a project contains multiple markers (e.g. Go backend with embedded C firmware components in a subdirectory), scope the domain rule to the specific subdirectory being modified.

## Unmatched Stacks
If no known marker matches, follow the universal [spec-driven-core.md](../rules/spec-driven-core.md) principles and prompt the user for the primary test runner and linting commands before editing code.
