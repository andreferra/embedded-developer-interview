# Scripts

The scripts are split into categories:

- `git`: Scripts for git questions.
- `cmake`: Scripts for cmake questions.
- `cpp`: Scripts for C++ questions.

## Git

### Setup Interview Repo
- **Script:** `scripts/git/setup_interview_repo.sh`
- **Description:** Creates a `cpp-interview-practice` repository with a simulated commit history containing bugs, typos, and merge conflicts.
- **Usage:**
  ```bash
  ./scripts/git/setup_interview_repo.sh
  ```

## C++

### Memory Leak Scenario
- **Script:** `scripts/cpp/setup_memory_leak.sh`
- **Description:** Creates a `cpp-memory-leak` project where a `ResourceManager` fails to clean up memory.
- **Usage:**
  ```bash
  ./scripts/cpp/setup_memory_leak.sh
  ```

### Race Condition Scenario
- **Script:** `scripts/cpp/setup_race_condition.sh`
- **Description:** Creates a `cpp-race-condition` project demonstrating data races in a multi-threaded bank account simulation.
- **Usage:**
  ```bash
  ./scripts/cpp/setup_race_condition.sh
  ```
