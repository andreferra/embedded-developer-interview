# Embedded Developer Interview Scripts

This repository provides a complete toolkit for preparing and running technical interviews for Embedded C++ Developer roles.

## Overview

The project offers resources for both interviewers and candidates, covering theoretical concepts and hands-on embedded development exercises.

### Key Contents

* **Practical C++ Tests**: Real code exercises (e.g., `cpp-race-condition`) to assess debugging and concurrency skills.
* **Technical Questions**: Collections focused on C++, memory management, pointers, and Git.
* **Automation**: Scripts that spin up interview environments quickly.
* **Documentation**: Detailed guides available through [GitHub Pages](https://andreferra.github.io/embedded-developer-interview/) or the `docs/` directory.

## Repository Structure

- `docs/`: Source files for the static documentation site.
- `scripts/`: Utility scripts that automate interview setup tasks.
- `cpp-race-condition/`: C++ source used for practical take-home or live exercises.
- `.github/workflows/`: CI/CD pipelines that deploy the documentation and enforce quality checks.

## Usage

To start running the scripts or preparing the environment, read the [Setup Guide](docs/setup.md).

## Git Interview Playgrounds

Use the level-specific Git scripts under `scripts/git/` to spin up repositories that match the candidate's seniority:

- `setup_git_junior.sh` – creates `git-playground-junior` with a short commit history suited for basic log/branch/diff drills.
- `setup_git_mid.sh` – provisions `git-playground-mid`, complete with a `feature/division` branch, commit-message typo, and unstaged docs edits that encourage interactive rebases and stashing.
- `setup_git_senior.sh` – builds `git-playground-senior`, featuring tagged releases, cherry-pick targets on `feature/audit-log`, and merge conflicts on `feature/conflict`.

Run any script with `./scripts/git/<script-name> [custom-directory]` to override the destination folder.

## Verifying Scripts

Run the automated smoke suite to make sure every setup script still works after making changes:

```bash
npm run smoke
```

The command generates each playground inside temporary directories, checks that the expected Git repositories exist, and then cleans up automatically.

## Local Checks

Install [pre-commit](https://pre-commit.com/) and enable the hooks to catch whitespace, YAML/JSON formatting, and large files before committing:

```bash
pip install pre-commit  # or brew install pre-commit
pre-commit install
pre-commit run --all-files
```

The configuration lives in `.pre-commit-config.yaml`. Some hooks (like `include-what-you-use`) require extra tooling:

- Install IWYU: `brew install include-what-you-use` or `pip install include-what-you-use`.
- Generate `build/compile_commands.json` once via `cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON` so the hook knows how to compile C++ files.
