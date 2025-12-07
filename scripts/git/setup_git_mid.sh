#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR=${1:-git-playground-mid}

if [ -d "$TARGET_DIR" ]; then
  echo "Directory '$TARGET_DIR' already exists. Remove it or pass a new path." >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

git init -b main >/dev/null

mkdir -p src include notes

cat > README.md <<'EOT'
# Mid-Level Git Playground

A small calculator app with a slightly messy history that is perfect for practicing rebase, stash, and branching workflows.
EOT

cat > include/calculator.h <<'EOT'
#pragma once

class Calculator {
public:
    int add(int a, int b);
};
EOT

cat > src/calculator.cpp <<'EOT'
#include "../include/calculator.h"

int Calculator::add(int a, int b) {
    return a + b;
}
EOT

cat > src/main.cpp <<'EOT'
#include <iostream>
#include "../include/calculator.h"

int main() {
    Calculator calc;
    std::cout << calc.add(1, 2) << std::endl;
    return 0;
}
EOT

cat > notes/release-plan.md <<'EOT'
# Release Plan
- [ ] Prepare v0.1.0 notes
- [ ] Draft regression checklist
EOT

git add README.md include/calculator.h src/calculator.cpp src/main.cpp notes/release-plan.md
git commit -m "feat: seed project structure" >/dev/null

cat > include/calculator.h <<'EOT'
#pragma once

class Calculator {
public:
    int add(int a, int b);
    int subtract(int a, int b);
};
EOT

cat > src/calculator.cpp <<'EOT'
#include "../include/calculator.h"

int Calculator::add(int a, int b) {
    return a + b;
}

int Calculator::subtract(int a, int b) {
    return a - b;
}
EOT

cat > src/main.cpp <<'EOT'
#include <iostream>
#include "../include/calculator.h"

int main() {
    Calculator calc;
    std::cout << "Add: " << calc.add(3, 8) << std::endl;
    std::cout << "Subtract: " << calc.subtract(10, 4) << std::endl;
    return 0;
}
EOT

git add include/calculator.h src/calculator.cpp src/main.cpp
git commit -m "feat: add subtraction support" >/dev/null

cat > include/calculator.h <<'EOT'
#pragma once

class Calculator {
public:
    int add(int a, int b);
    int subtract(int a, int b);
    int multiply(int a, int b);
};
EOT

cat > src/calculator.cpp <<'EOT'
#include "../include/calculator.h"

int Calculator::add(int a, int b) {
    return a + b;
}

int Calculator::subtract(int a, int b) {
    return a - b;
}

int Calculator::multiply(int a, int b) {
    return a * b;
}
EOT

git add include/calculator.h src/calculator.cpp
git commit -m "feat: Add mutiply operation" >/dev/null

cat > EXERCISE.md <<'EOT'
# Mid-Level Git Objectives

- Fix the typo in the `mutiply` commit message using an interactive rebase.
- Finish the division feature on `feature/division` and commit it with tests/documentation.
- Rebase `feature/division` onto the updated `main` branch once docs change.
- Practice `git stash` with the README change that this script leaves uncommitted.
EOT

git add EXERCISE.md
git commit -m "docs: describe mid-level git exercise" >/dev/null

cat > notes/release-plan.md <<'EOT'
# Release Plan
- [x] Prepare v0.1.0 notes
- [ ] Draft regression checklist
- [ ] Document CLI usage
EOT

git add notes/release-plan.md
git commit -m "docs: log release checklist progress" >/dev/null

git checkout -b feature/division >/dev/null

cat > include/calculator.h <<'EOT'
#pragma once

class Calculator {
public:
    int add(int a, int b);
    int subtract(int a, int b);
    int multiply(int a, int b);
    int divide(int a, int b);
};
EOT

cat > src/calculator.cpp <<'EOT'
#include "../include/calculator.h"

int Calculator::add(int a, int b) {
    return a + b;
}

int Calculator::subtract(int a, int b) {
    return a - b;
}

int Calculator::multiply(int a, int b) {
    return a * b;
}

int Calculator::divide(int a, int b) {
    // TODO: handle divide-by-zero gracefully
    return a / b;
}
EOT

git add include/calculator.h src/calculator.cpp
git commit -m "feat: add experimental division" >/dev/null

cat > notes/release-plan.md <<'EOT'
# Release Plan
- [x] Prepare v0.1.0 notes
- [x] Draft regression checklist
- [ ] Document CLI usage
EOT

git add notes/release-plan.md
git commit -m "docs: capture QA checklist progress" >/dev/null

git checkout main >/dev/null

cat > README.md <<'EOT'
# Mid-Level Git Playground

Use this repo to demonstrate:
- Interactive rebases
- Branch rebases
- Basic stash workflows
- Small feature delivery with calculator.cpp

## Build
Use any C++17 compiler:
```bash
cmake -S . -B build
cmake --build build
```
EOT

git add README.md
git commit -m "docs: add build instructions" >/dev/null

cat > notes/release-plan.md <<'EOT'
# Release Plan
- [x] Prepare v0.1.0 notes
- [x] Draft regression checklist
- [x] Document CLI usage
EOT

git add notes/release-plan.md
git commit -m "docs: finalize release checklist" >/dev/null

git checkout feature/division >/dev/null

cat >> README.md <<'EOT'

> WIP: Document the exception guarantee for divide().
EOT

cat <<'EOT'
✅ Mid-level playground ready.
Current branch: feature/division
Unread README changes were left unstaged to encourage practicing `git stash`.
Location: $(pwd)
EOT
