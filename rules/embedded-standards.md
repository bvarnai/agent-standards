# Embedded C/C++ Engineering Standards

These standards apply to microcontroller firmware, RTOS, and bare-metal environments whenever `CMakeLists.txt`, `platformio.ini`, `Kconfig`, `*.ld`, or embedded `Makefile` markers are present in the workspace.

## Architectural Principles & Hardware Layering
1. **HAL & Driver Separation**:
   - Strictly separate application business logic from Hardware Abstraction Layers (HAL) and register-level drivers.
   - Use clean abstract interfaces / function pointer structs for peripheral drivers so logic can be compiled and unit-tested on the host machine without hardware.
2. **Deterministic Memory**:
   - **No dynamic memory allocation** (`malloc`, `free`, `new`, `delete`) in steady-state operation or inside ISRs. Pre-allocate buffers statically or at system initialization.
   - Guard against stack overflow: avoid large local stack buffers and recursive functions.

## Concurrency & Interrupt Safety (ISR)
1. **Minimal ISR Work**:
   - Keep Interrupt Service Routines as short as possible: clear interrupt flags, buffer raw data into a lock-free ring buffer, signal a task / semaphore, and exit. Never perform I/O, heavy math, or blocking operations in an ISR.
2. **Volatile & Atomic Operations**:
   - Variables shared between an ISR and normal execution threads must be declared `volatile` and accessed atomically or within a critical section (`portENTER_CRITICAL` / disable interrupts).
3. **Deterministic State Machines**:
   - Model asynchronous communication (UART, SPI, I2C, BLE, CAN) using explicit, finite state machines with state transition bounds and timeout guards.

## Verification & Build Standards
1. **Host-Side Unit Tests**:
   - Decouple algorithms (e.g. packet decoding, checksum calculations, PID controllers) into pure functions and test them using a host-based test runner (e.g. Unity, CppUTest, or GoogleTest via `ctest`).
2. **Compiler Warning Hygiene**:
   - Compile with `-Wall -Wextra -Werror -Wconversion -Wstrict-prototypes` (for C) and enforce zero compiler warnings.
