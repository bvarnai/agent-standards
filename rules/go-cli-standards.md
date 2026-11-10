# Go CLI Engineering Standards

These standards apply to Go CLI applications and services whenever `go.mod` is present in the workspace.

## Architectural Principles
1. **Entry Point Separation**:
   - `main.go` / `cmd/<tool>/main.go` must remain minimal: parse environment/flags, call an `app.Run(ctx, args, stdout, stderr)` function, and call `os.Exit(code)`.
   - Keep business logic in `internal/` to avoid polluting the public module API unless package reusability is explicitly required.
2. **Standard I/O Streams**:
   - Always accept `io.Writer` for `stdout` and `stderr` rather than writing directly to `os.Stdout` / `os.Stderr` to make commands easily testable.
   - Structured output (JSON, YAML) and standard logs must not mix on `stdout`; write diagnostic logs to `stderr`.

## Error Handling & Context
1. **Explicit Wrapping**:
   - Wrap errors with contextual verbs using `fmt.Errorf("reading config %s: %w", path, err)`.
   - Never discard errors (`_ = ...`) without an explicit inline comment explaining why it is safe.
2. **Context Propagation**:
   - Accept `context.Context` as the first argument in all network, filesystem, or long-running operations.
   - Respect context cancellation in loops and goroutines (`select { case <-ctx.Done(): return ctx.Err() ... }`).

## Exit Codes & POSIX Conventions
- `0`: Success.
- `1`: General application error.
- `2`: Command line usage / flag syntax error.

## Verification & Testing Standards
1. **Table-Driven Tests**:
   - Use table-driven tests (`tests := []struct{ name string; ... }`) with `t.Run(tt.name, func(t *testing.T) { ... })`.
2. **Race Detection**:
   - All tests must pass with `go test -race ./...`.
3. **No Flaky Tests**:
   - Use real synchronization primitives (`sync.WaitGroup`, channels) instead of `time.Sleep` in tests.
