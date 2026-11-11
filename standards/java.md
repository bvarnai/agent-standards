# Java engineering standards

These standards apply to JVM-based applications whenever `pom.xml`, `build.gradle`, or `build.gradle.kts` is present in the workspace.

## Architectural principles
1. **Modern language idioms**:
   - Prefer Java 17+ or Java 21 LTS constructs: records for immutable DTOs, pattern matching for `instanceof` and `switch`, sealed interfaces, and text blocks.
   - Favor composition over inheritance; make classes `final` unless explicitly designed for extension.
2. **Immutability & null safety**:
   - Make fields `private final` by default.
   - Never return `null` for collections or optional values; return `Optional<T>`, `List.of()`, or `Collections.emptyList()`.
   - Validate method preconditions explicitly (`Objects.requireNonNull(...)`).

## Concurrency, error handling & resource management
1. **Resource lifecycle**:
   - Always manage I/O streams, database connections, and sockets using `try-with-resources`.
2. **Virtual threads / concurrency**:
   - For Java 21+, use structured concurrency or virtual threads where appropriate; avoid manual thread pooling for simple short-lived tasks.
   - Guard shared state using thread-safe data structures (`ConcurrentHashMap`, atomic primitives) rather than broad `synchronized` blocks.
3. **Exceptions & logging**:
   - Never swallow exceptions silently or catch raw `Exception` / `Throwable` without contextual wrapping (`throw new DomainException("...", cause)`) or explicit recovery.
   - Use parameterized SLF4J logging (`log.error("Failed for {}", id, ex)`) instead of `System.out` / `printStackTrace()`.

## Verification & testing standards
1. **Testing framework**:
   - Use JUnit 5 (`@Test`, `@ParameterizedTest`, `@Nested`) with AssertJ or Hamcrest assertions for readable failure messages.
2. **Build tool hygiene**:
   - Verification must execute via `./mvnw test` (Maven) or `./gradlew check` (Gradle).
   - Ensure zero compiler warnings and zero checkstyle/spotbugs violations before completing work.
