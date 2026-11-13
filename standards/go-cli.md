# Go CLI engineering standards

These standards apply to Go CLI applications and services whenever `go.mod` is present in the workspace.

## Architectural principles
1. **Entry point separation**:
   - `main.go` / `cmd/<tool>/main.go` must remain minimal: parse environment/flags, call an `app.Run(ctx, args, stdout, stderr)` function, and call `os.Exit(code)`.
   - Keep business logic in `internal/` to avoid polluting the public module API unless package reusability is explicitly required.
2. **Standard I/O streams**:
   - Always accept `io.Writer` for `stdout` and `stderr` rather than writing directly to `os.Stdout` / `os.Stderr` to make commands easily testable.
   - Structured output (JSON, YAML) and standard logs must not mix on `stdout`; write diagnostic logs to `stderr`.
3. **Build-time version injection**:
   - Inject release versions at build time via `-ldflags` or `runtime/debug.ReadBuildInfo()`, keeping a `"dev"` fallback in source (e.g., `internal/version/version.go`) rather than hardcoding release numbers in Go files.

## Error handling & context
1. **Explicit wrapping & inspection**:
   - Wrap errors with contextual verbs using `fmt.Errorf("reading config %s: %w", path, err)`.
   - Inspect sentinel and structured errors using `errors.Is` and `errors.As` rather than string matching or direct equality (`==`).
   - Never discard errors (`_ = ...`) without an explicit inline comment explaining why it is safe.
2. **Context propagation & signal handling**:
   - Accept `context.Context` as the first argument in all network, filesystem, subprocess (`exec.CommandContext`), or long-running operations.
   - Wire `signal.NotifyContext(ctx, os.Interrupt, syscall.SIGTERM)` at the CLI root and respect context cancellation in loops and goroutines (`select { case <-ctx.Done(): return ctx.Err() ... }`).

## Exit codes & POSIX conventions
- `0`: Success.
- `1`: General application / runtime error.
- `2`: Command line usage / flag syntax error.
- `130`: Process interrupted (`SIGINT` / `SIGTERM` context cancellation).

## Verification & testing standards
1. **Table-driven tests**:
   - Use table-driven tests (`tests := []struct{ name string; ... }`) with `t.Run(tt.name, func(t *testing.T) { ... })`.
2. **Race detection & static analysis**:
   - All tests and static checks must pass with `go test -race ./...` and `go vet ./...` (plus `golangci-lint run` when configured in the repository).
3. **No flaky tests**:
   - Use real synchronization primitives (`sync.WaitGroup`, channels) instead of `time.Sleep` in tests.
