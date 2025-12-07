# Scripts

The scripts are split into categories:

- `git`: Scripts for git questions.
- `cmake`: Scripts for cmake questions.
- `cpp`: Scripts for C++ questions.

> ✅ Use `npm run smoke` to generate each scenario in a temporary directory and verify that the scripts still execute successfully.

## Git

### Junior Git Playground
- **Script:** `scripts/git/setup_git_junior.sh`
- **Description:** Creates `git-playground-junior`, a lightweight calculator project with a short commit history for the basics (log, branching, diffs).
- **Usage:**
  ```bash
  ./scripts/git/setup_git_junior.sh [custom-directory]
  ```
- **Sample tree (`tree -L 2 git-playground-junior`):**
  ```text
  git-playground-junior
  ├── EXERCISE.md
  ├── README.md
  ├── include
  │   └── calculator.h
  └── src
      ├── calculator.cpp
      └── main.cpp
  ```
- **Sample history (`git -C git-playground-junior log --oneline`):**
  ```text
  7c6c207 docs: add junior exercise checklist
  5aa44fb feat: add subtraction support
  3b61fdd feat: bootstrap calculator app
  ```

### Mid-Level Git Playground
- **Script:** `scripts/git/setup_git_mid.sh`
- **Description:** Spins up `git-playground-mid` with an existing feature branch, a typo'd commit message, and unstaged README edits for practicing rebase + stash workflows.
- **Usage:**
  ```bash
  ./scripts/git/setup_git_mid.sh [custom-directory]
  ```
- **Sample tree (`tree -L 2 git-playground-mid`):**
  ```text
  git-playground-mid
  ├── EXERCISE.md
  ├── README.md
  ├── include
  │   └── calculator.h
  ├── notes
  │   └── release-plan.md
  └── src
      ├── calculator.cpp
      └── main.cpp
  ```
- **Sample history (`git -C git-playground-mid log --oneline --graph`):**
  ```text
  * 2f6716b docs: finalize release checklist
  * 7afcd1b docs: add build instructions
  | * f2f9a8e docs: capture QA checklist progress
  | * 4f13d63 feat: add experimental division
  |/
  * e1d987d docs: log release checklist progress
  * 0a4c6bf docs: describe mid-level git exercise
  * 2c5d1d9 feat: Add mutiply operation
  * 35f1f5c feat: add subtraction support
  * 7dcb2d8 feat: seed project structure
  ```

### Senior Git Playground
- **Script:** `scripts/git/setup_git_senior.sh`
- **Description:** Builds `git-playground-senior` complete with conflict branches, a cherry-pick-only audit log branch, and documentation commits meant to be squashed.
- **Usage:**
  ```bash
  ./scripts/git/setup_git_senior.sh [custom-directory]
  ```
- **Sample tree (`tree -L 2 git-playground-senior`):**
  ```text
  git-playground-senior
  ├── EXERCISE.md
  ├── README.md
  ├── docs
  │   └── release-notes.md
  ├── include
  │   └── calculator.h
  └── src
      ├── calculator.cpp
      └── main.cpp
  ```
- **Sample history (`git -C git-playground-senior log --oneline`):**
  ```text
  8f5a019 docs: expand usage guide
  2b7b6d8 docs: add usage steps
  927a499 refactor: clarify add guard rails
  621e1cf docs: add interview prompts
  3bf3aa2 docs: outline senior-level git exercise
  81c6aaa docs: add release notes
  56d53fe docs: expand project README
  3bee3b6 feat: Add mutiply method
  0edbc9d feat: add subtraction
  4f63d52 feat: bootstrap calculator
  ```

### Setup Interview Repo
- **Script:** `scripts/git/setup_interview_repo.sh`
- **Description:** Creates a `cpp-interview-practice` repository with a simulated commit history containing bugs, typos, and merge conflicts.
- **Usage:**
  ```bash
  ./scripts/git/setup_interview_repo.sh
  ```
- **Sample tree (`tree -L 2 cpp-interview-practice`):**
  ```text
  cpp-interview-practice
  ├── CMakeLists.txt
  ├── README.md
  ├── calculator.cpp
  ├── calculator.h
  └── main.cpp
  ```
- **Sample history (`git -C cpp-interview-practice log --oneline --decorate --graph`):**
  ```text
  * a5a42e1 (HEAD -> main) Update add method documentation
  * 4c9a0a5 Add README with project documentation
  * 8b6af9f Add mutiply method to Calculator
  * 6ea399a Update main.cpp to demonstrate Calculator usage
  * 25f9dd0 Add Calculator class with basic operations
  * 91ab3a8 Initial commit: Add basic C++ project structure
  ```

## C++

### Memory Leak Scenario
- **Script:** `scripts/cpp/setup_memory_leak.sh`
- **Description:** Creates a `cpp-memory-leak` project where a `ResourceManager` fails to clean up memory.
- **Usage:**
  ```bash
  ./scripts/cpp/setup_memory_leak.sh
  ```
- **Sample tree (`tree -L 2 cpp-memory-leak`):**
  ```text
  cpp-memory-leak
  ├── CMakeLists.txt
  ├── main.cpp
  ├── resource.cpp
  └── resource.h
  ```
- **Sample history (`git -C cpp-memory-leak log --oneline`):**
  ```text
  5a06f91 Initial commit: ResourceManager implementation
  ```

### Race Condition Scenario
- **Script:** `scripts/cpp/setup_race_condition.sh`
- **Description:** Creates a `cpp-race-condition` project demonstrating data races in a multi-threaded bank account simulation.
- **Usage:**
  ```bash
  ./scripts/cpp/setup_race_condition.sh
  ```
- **Sample tree (`tree -L 2 cpp-race-condition`):**
  ```text
  cpp-race-condition
  ├── CMakeLists.txt
  └── main.cpp
  ```
- **Sample history (`git -C cpp-race-condition log --oneline`):**
  ```text
  c1a5a0c Initial commit: Threaded bank account deposit simulation
  ```

### Buffer Overflow Scenario
- **Script:** `scripts/cpp/setup_buffer_overflow.sh`
- **Description:** Creates a `cpp-buffer-overflow` project with a classic buffer overflow bug.
- **Usage:**
  ```bash
  ./scripts/cpp/setup_buffer_overflow.sh
  ```
- **Sample tree (`tree -L 2 cpp-buffer-overflow`):**
  ```text
  cpp-buffer-overflow
  ├── CMakeLists.txt
  └── main.cpp
  ```
- **Sample history (`git -C cpp-buffer-overflow log --oneline`):**
  ```text
  8c98996 Initial commit: Data processing logic
  ```

### Rule of Three Scenario
- **Script:** `scripts/cpp/setup_rule_of_three.sh`
- **Description:** Creates a `cpp-rule-of-three` project with a double-free bug caused by missing copy semantics.
- **Usage:**
  ```bash
  ./scripts/cpp/setup_rule_of_three.sh
  ```
- **Sample tree (`tree -L 2 cpp-rule-of-three`):**
  ```text
  cpp-rule-of-three
  ├── CMakeLists.txt
  └── main.cpp
  ```
- **Sample history (`git -C cpp-rule-of-three log --oneline`):**
  ```text
  2e27b38 Initial commit: MyString implementation
  ```

## CMake

### CMake Build Challenge
- **Script:** `scripts/cmake/cmake-setup.sh`
- **Description:** Generates `cmake-challenge`, a calculator library/app with a broken `CMakeLists.txt` that candidates must fix.
- **Usage:**
  ```bash
  ./scripts/cmake/cmake-setup.sh
  ```
- **Sample tree (`tree -L 2 cmake-challenge`):**
  ```text
  cmake-challenge
  ├── CMakeLists.txt
  ├── main.cpp
  ├── math_lib.cpp
  └── math_lib.h
  ```
- **Sample history (`git -C cmake-challenge log --oneline`):**
  ```text
  4d5afac Initial commit: Basic calculator app
  ```
