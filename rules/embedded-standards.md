# Embedded C/C++ engineering standards

These standards apply to microcontroller firmware, RTOS, and bare-metal environments whenever `CMakeLists.txt`, `platformio.ini`, `Kconfig`, `*.ld`, or embedded `Makefile` markers are present in the workspace.

## Architectural principles & hardware layering
1. **HAL & driver separation**:
   - Strictly separate application business logic from Hardware Abstraction Layers (HAL) and register-level drivers.
   - Use clean abstract interfaces / function pointer structs for peripheral drivers so logic can be compiled and unit-tested on the host machine without hardware.
2. **Deterministic memory & type safety**:
   - **No dynamic memory allocation** (`malloc`, `free`, `new`, `delete`) in steady-state operation or inside ISRs. Pre-allocate buffers statically or at system initialization.
   - Guard against stack overflow: avoid large local stack buffers and recursive functions.
   - Use fixed-width integer types (`<stdint.h>`: `uint8_t`, `uint16_t`, `uint32_t`, `int32_t`, `size_t`) rather than platform-dependent primitive types (`int`, `short`, `long`, or unqualified `char`).
   - Require explicit length parameters (`size_t len`) on all buffer operations and forbid unbounded C functions (`strcpy`, `strcat`, `sprintf`, `gets`).

## Concurrency & interrupt safety (ISR)
1. **Minimal ISR work**:
   - Keep Interrupt Service Routines as short as possible: clear interrupt flags, buffer raw data into a lock-free ring buffer, signal a task / semaphore, and exit. Never perform I/O, heavy math, or blocking operations in an ISR.
2. **Volatile & atomic operations**:
   - Variables shared between an ISR and normal execution threads must be declared `volatile` and accessed atomically or within a critical section (`portENTER_CRITICAL` / disable interrupts).
3. **Deterministic state machines**:
   - Model asynchronous communication (UART, SPI, I2C, BLE, CAN) using explicit, finite state machines with state transition bounds and timeout guards.

## Verification & build standards
1. **Host-side unit tests**:
   - Decouple algorithms (e.g. packet decoding, checksum calculations, PID controllers) into pure functions and test them using a host-based test runner (e.g. Unity, CppUTest, or GoogleTest via `ctest`).
2. **Compiler warning & footprint hygiene**:
   - Compile with `-Wall -Wextra -Werror -Wconversion -Wstrict-prototypes` (for C) and enforce zero compiler warnings.
   - Run static analysis (`cppcheck` / `clang-tidy` when configured) and verify Flash/RAM section budgets (`size <elf>`) on target builds.
