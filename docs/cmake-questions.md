# CMake Technical Interview Questions

This page contains scenarios and questions for CMake and build system technical interviews.

## Theoretical Questions

### Junior Level

#### 1. What is CMake?
**Question:** Explain what CMake is and how it differs from Make.

**Solution:**
*   **CMake:** A cross-platform build system **generator**. It reads `CMakeLists.txt` and generates platform-specific build files (e.g., `Makefile` for Unix, `.sln` for Visual Studio, `Ninja` files).
*   **Make:** A build tool that interprets a `Makefile` to build the project.
*   **Key Difference:** CMake generates the build files; Make (or Ninja/MSBuild) executes them.

#### 2. Out-of-source Builds
**Question:** What is an "out-of-source" build and why is it recommended?

**Solution:**
*   **Definition:** Building the project in a separate directory (e.g., `build/`) rather than in the source tree.
*   **Why:** Keeps the source directory clean. Easy to clean up (just delete `build/`). Allows multiple builds (Debug, Release) from the same source.

### Mid Level

#### 1. Public, Private, Interface
**Question:** Explain the difference between `PUBLIC`, `PRIVATE`, and `INTERFACE` when using `target_link_libraries` or `target_include_directories`.

**Solution:**
*   **PRIVATE:** The dependency is used *only* by the target itself. It does not propagate to consumers.
*   **INTERFACE:** The dependency is *not* used by the target itself, but is required by anything that links to this target (e.g., header-only library dependencies).
*   **PUBLIC:** The dependency is used by *both* the target and its consumers. (Functionally `PRIVATE` + `INTERFACE`).

#### 2. Modern CMake (Target-based)
**Question:** What is "Modern CMake" compared to the old variable-based approach?

**Solution:**
*   **Old Style:** Relied on global variables (`include_directories`, `link_libraries`) and manipulating paths directly. Hard to manage scope and dependencies.
*   **Modern Style (3.0+):** Focuses on **Targets** (executables, libraries). Usage requirements (includes, definitions, flags) are attached to targets and propagated automatically via `target_link_libraries`.
*   **Benefit:** Modular, transitive dependencies handled automatically, cleaner scope.

---

## Scenario 1: CMake Challenge

### Setup
Run the setup script:
```bash
./scripts/cmake/cmake-setup.sh
```
This creates a `cmake-challenge` directory with a broken CMake project.

<div style="
    background: #ffffff;
    padding: 20px 24px;
    border: 2px solid #e5e7eb;
    border-left: 6px solid #8b5cf6;
    margin-bottom: 24px;
    border-radius: 6px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
">
    <p style="margin: 0; font-weight: 600; color: #1f2937; font-size: 16px; letter-spacing: -0.01em;">
        💡 Hint for Interviewer
    </p>
    <p style="margin: 10px 0 0; color: #6b7280; font-size: 14px; line-height: 1.7;">
        The project fails to link because the <code>app</code> executable depends on <code>math_lib</code> symbols, but the CMake configuration in <code>CMakeLists.txt</code> does not link the <code>math_lib</code> library to the executable. It also might be missing include path propagation if not set up correctly.
    </p>
</div>

### Problem Description
You are given a simple calculator project with a `main.cpp` and a math library `math_lib`.
The project fails to build or link.

### Exercises

#### 1. Fix the Build
**Question:** Run `cmake -S . -B build` and `cmake --build build` (or mkdir build, cd build, cmake .., make). Identify the error and fix `CMakeLists.txt`.

**Solution:**
The `CMakeLists.txt` has:
```cmake
add_library(math_lib math_lib.cpp)
add_executable(app main.cpp)
```
It is missing the link step. The linker doesn't know where to find `MathLib::add` and `MathLib::multiply`.

**Fix:**
Add `target_link_libraries` to link `app` with `math_lib`.

```cmake
add_library(math_lib math_lib.cpp)

# OPTIONAL BUT GOOD: Add include directory to target
target_include_directories(math_lib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

add_executable(app main.cpp)

# REQUIRED FIX:
target_link_libraries(app PRIVATE math_lib)
```

**Follow-up:** Why `PRIVATE`?
*   Because `main.cpp` uses `math_lib`, but `app` is an executable, so it doesn't expose an interface to anyone else. `PUBLIC` would also work but `PRIVATE` is semantic for executables.
