# Exercises and Questions by Level

This page categorizes the interview questions and exercises based on the expected seniority level of the candidate (Junior, Mid, Senior). Use the checkboxes to track which key concepts the candidate successfully covered.

## Junior Level

Focus: Basic syntax, standard definitions, basic git usage, and simple debugging.

### C++
*   **Theoretical Types**
    *   [Reference vs Pointer](cpp-questions.md?id=_1-reference-vs-pointer)
        - [ ] Explains Nullability (Pointers can be null, References cannot)
        - [ ] Explains Reassignment (Pointers can change target, References are bound)
        - [ ] Mentions Syntax differences (* vs &)
        - [ ] Correct Usage (Ref by default, Ptr for optional/arithmetic)
    *   [`const` usage](cpp-questions.md?id=_2-const-usage)
        - [ ] Identifies `const int*` (Pointer to constant data)
        - [ ] Identifies `int* const` (Constant pointer)
        - [ ] Identifies `const int* const` (Constant pointer to constant data)
    *   [`static` keyword](cpp-questions.md?id=_3-static-keyword)
        - [ ] Global/Namespace: Internal Linkage (file scope)
        - [ ] Function: Persistence between calls (single initialization)
        - [ ] Class: Shared by all instances (belongs to class)
*   **Embedded Basics**
    *   [`volatile` keyword](cpp-questions.md?id=_4-volatile-keyword)
        - [ ] Prevents compiler optimization (caching in registers)
        - [ ] Essential for Memory-Mapped Registers (Hardware)
        - [ ] Essential for variables shared with ISRs
    *   [Struct vs Class](cpp-questions.md?id=_5-struct-vs-class)
        - [ ] Struct members refer public by default
        - [ ] Class members refer private by default
        - [ ] Base inheritance defaults (public vs private)
*   **Debugging Scenario**
    *   [Buffer Overflow](cpp-questions.md?id=scenario-3-buffer-overflow-junior)
        - [ ] Identifies loop condition error (`<=` instead of `<`)
        - [ ] Identifies fixed-size buffer limitation
        - [ ] Suggests `std::vector` or correct bounds check as fix

### Git
*Setup script:* `scripts/git/setup_git_junior.sh`
*   **Basics**
    *   [View History](git-questions.md?id=_1-view-the-commit-history)
        - [ ] Uses `git log` (or equivalent)
    *   [Create Branch](git-questions.md?id=_3-create-a-new-branch-for-division-feature)
        - [ ] Uses `git checkout -b` or `git switch -c`
    *   [Commit Changes](git-questions.md?id=_4-add-division-method-on-the-new-branch)
        - [ ] Stages files (`git add`)
        - [ ] Commits with message (`git commit -m`)
    *   [View Diffs](git-questions.md?id=_7-view-the-difference-between-commits)
        - [ ] Uses `git diff` correctly
    *   [Merge Branch with Merge Commit](git-questions.md?id=_11-merge-feature-branch-without-fast-forward)
        - [ ] Switches back to `main`
        - [ ] Uses `git merge --no-ff` (records merge commit)
*Rubric:* Strong juniors narrate each Git step, keep commits scoped, and review diffs before merging. Watch for copy-pasting commands without understanding flags or merging fast-forward by accident.

### CMake
*   **Basics**
    *   [What is CMake?](cmake-questions.md?id=_1-what-is-cmake)
        - [ ] Defines it as a Build System Generator (not the builder itself)
        - [ ] Mentions `CMakeLists.txt`
    *   [Out-of-source Builds](cmake-questions.md?id=_2-out-of-source-builds)
        - [ ] Explains separation of build directory from source
        - [ ] Explains benefits (cleanliness, multiple build types)
*   **Practical**
    *   [Fixing a basic build](cmake-questions.md?id=scenario-1-cmake-challenge)
        - [ ] Identifies missing `target_link_libraries`
        - [ ] Links `math_lib` to `app` target
        - [ ] Understands public/private visibility (basic)

---

## Mid Level

Focus: Memory management, object lifecycles, history manipulation, and modularity.

### C++
*   **Core Mechanics**
    *   [Virtual Functions & VTable](cpp-questions.md?id=_1-virtual-functions-and-vtable)
        - [ ] Mentions VTable (static table of function pointers)
        - [ ] Mentions VPTR (hidden pointer in object)
        - [ ] Explains runtime lookup/dispatch mechanism
*   **Memory Management**
    *   [RAII & Smart Pointers](cpp-questions.md?id=_2-raii-and-smart-pointers)
        - [ ] Defines RAII (Resource tied to object lifetime)
        - [ ] `unique_ptr`: Exclusive ownership, no copy
        - [ ] `shared_ptr`: Reference counting, shared ownership
    *   [Move Semantics](cpp-questions.md?id=_3-move-semantics)
        - [ ] Distinguishes Move (transfer) vs Copy (duplicate)
        - [ ] Explains `std::move` (cast to rvalue reference)
        - [ ] Mentions efficiency (stealing resources)
*   **Containers**
    *   [Vector reserve vs resize](cpp-questions.md?id=_4-stdvectorreserve-vs-resize)
        - [ ] Knows `reserve` grows capacity only
        - [ ] Knows `resize` changes size and constructs/destroys elements
        - [ ] Avoids writing past `size()` after only reserving
*   **Modern Features**
    *   [Lambdas](cpp-questions.md?id=_5-lambdas-and-captures)
        - [ ] Explains syntax `[](){}`
        - [ ] Capture by value `[=]` (copy)
        - [ ] Capture by reference `[&]` (danger of dangling)
*   **Scenario (Memory Leak)**
    *   [Finding leaks in ResourceManager](cpp-questions.md?id=scenario-1-memory-leak)
        - [ ] Identifies `new` without `delete` in vector
        - [ ] Identifies missing destructor in `Resource`
        - [ ] Fixes using `std::unique_ptr`
        - [ ] Fixes iteration (uses reference `const auto&`)
*   **Scenario (Rule of Three)**
    *   [Fixing Copy/Assign crashes](cpp-questions.md?id=scenario-4-rule-of-three-double-free-mid)
        - [ ] Identifies Double Free caused by shallow copy
        - [ ] Implements Copy Constructor (Deep Copy)
        - [ ] Implements Assignment Operator (Deep Copy + Self-assign check)
        - [ ] Implements Destructor

### Git
*Setup script:* `scripts/git/setup_git_mid.sh`
*   **History Editing**
    *   [Fixing Typo (Interactive Rebase)](git-questions.md?id=_2-fix-the-typo-in-commit-4)
        - [ ] Uses `git rebase -i`
        - [ ] Uses `reword` on correct commit
    *   [Rebase Branch](git-questions.md?id=_5-rebase-the-feature-branch-onto-main)
        - [ ] Rebased `feature` onto `main` successfully
*   **Workflow**
    *   [Stashing Changes](git-questions.md?id=_10-stash-changes)
        - [ ] Uses `git stash` to save local changes
        - [ ] Switches branches back and forth
        - [ ] Uses `git stash pop` to restore
*Rubric:* Strong mid-level candidates explain why they choose rebase vs merge, clean up commit messages, and protect work with stash/backup branches. Risk signals include force-pushing without explanation or leaving TODOs unresolved after rebases.

### CMake
*   **Dependency Management**
    *   [Public vs Private vs Interface](cmake-questions.md?id=_1-public-private-interface)
        - [ ] PRIVATE: Implementation only
        - [ ] INTERFACE: Consumers only
        - [ ] PUBLIC: Both
*   **Modern Patterns**
    *   [Target-based Modern CMake](cmake-questions.md?id=_2-modern-cmake-target-based)
        - [ ] Avoids global vars (`include_directories`)
        - [ ] Uses Target-centric commands (`target_...`)
        - [ ] Explains property propagation

---

## Senior Level

Focus: Concurrency, system design impact, advanced git flows, and compiler/optimization details.

### C++
*   **Concurrency**
    *   [Memory Order & Atomics](cpp-questions.md?id=_1-race-conditions-amp-memory-order)
        - [ ] Sequential Consistency (Global order)
        - [ ] Acquire/Release (Synchronizes-with relation)
        - [ ] Relaxed (Atomicity only, no ordering)
*   **Compile-time Computation**
    *   [`constexpr` vs `const` vs `consteval`](cpp-questions.md?id=_2-constexpr-vs-const-vs-consteval)
        - [ ] Distinguishes runtime `const` from compile-time `constexpr`
        - [ ] Explains when `consteval` is mandatory
        - [ ] Understands when evaluations occur at compile time vs runtime
*   **Advanced Templates**
    *   [Template Metaprogramming / CRTP](cpp-questions.md?id=_3-template-metaprogramming)
        - [ ] Explains Compile-time Polymorphism
        - [ ] Explains CRTP Pattern (`Derived : Base<Derived>`)
        - [ ] Benefits (Static dispatch, no vtable overhead)
*   **Object Model**
    *   [Object Slicing](cpp-questions.md?id=_4-object-slicing)
        - [ ] Explains Slicing (Assigning Derived to Base Value)
        - [ ] Prevention (Use Pointers/References)
*   **Scenario (Race Condition)**
    *   [Debugging concurrency issues](cpp-questions.md?id=scenario-2-race-condition)
        - [ ] Identifies Read-Modify-Write race
        - [ ] Fixes using `std::mutex` (Lock guard)
        - [ ] OR Fixes using `std::atomic` (if applicable)

### Git
*Setup script:* `scripts/git/setup_git_senior.sh`
*   **Advanced Operations**
    *   [Squashing Commits](git-questions.md?id=_6-squash-the-last-2-commits-on-main)
        - [ ] Uses `rebase -i`
        - [ ] Uses `squash` (or `fixup`) to combine commits
    *   [Cherry-picking](git-questions.md?id=_8-cherry-pick-a-specific-commit)
        - [ ] Successfully cherry-picked specific hash
    *   [Cherry-pick Audit Log Commit](git-questions.md?id=_12-cherry-pick-the-audit-logging-commit)
        - [ ] Targets `feature/audit-log` branch or hash
        - [ ] Applies onto `main` without merging whole branch
*   **Conflict Resolution**
    *   [Resolving Merge Conflicts](git-questions.md?id=_9-resolve-a-merge-conflict)
        - [ ] Identifies conflict markers
        - [ ] Manually edits code to resolve logic
        - [ ] Completes merge commit
*   **Troubleshooting**
    *   [Recover from Failed Rebase](git-questions.md?id=_13-recover-from-a-failed-rebase)
        - [ ] Uses `git rebase --abort` or reflog appropriately
        - [ ] Explains state cleanup before retrying
    *   [Reset Branch to Remote](git-questions.md?id=_14-reset-main-to-match-origin)
        - [ ] Fetches before resetting
        - [ ] Mentions safeguarding local work (stash/backup) before `reset --hard`
*Rubric:* Strong seniors verbalize the impact of history rewrites, use reflog/backups before destructive commands, and document fixes in release notes. Red flags include hard resets without backups, confusion about detached HEAD during recovery, or skipping verification after conflict resolution.
