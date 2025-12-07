#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR=${1:-git-playground-senior}

if [ -d "$TARGET_DIR" ]; then
  echo "Directory '$TARGET_DIR' already exists. Remove it or pass a new path." >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

git init -b main >/dev/null

mkdir -p src include docs

cat > README.md <<'EOT'
# Senior Git Playground

A calculator example that intentionally includes conflicting branches, history clean-up work, and feature branches for cherry-picking.
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
#include <string>
#include "../include/calculator.h"

int main() {
    Calculator calc;
    std::cout << "Add: " << calc.add(4, 9) << std::endl;
    return 0;
}
EOT

git add README.md include/calculator.h src/calculator.cpp src/main.cpp
git commit -m "feat: bootstrap calculator" >/dev/null

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
    std::cout << "Add: " << calc.add(4, 9) << std::endl;
    std::cout << "Subtract: " << calc.subtract(12, 5) << std::endl;
    return 0;
}
EOT

git add include/calculator.h src/calculator.cpp src/main.cpp
git commit -m "feat: add subtraction" >/dev/null

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
git commit -m "feat: Add mutiply method" >/dev/null

cat > README.md <<'EOT'
# Senior Git Playground

Use this repo to assess advanced Git skills.

## Current Features
- Addition
- Subtraction
- Multiplication
EOT

git add README.md
git commit -m "docs: expand project README" >/dev/null

cat > docs/release-notes.md <<'EOT'
# Release Notes

## v1.0.0
- Initial calculator with three operations
EOT

git add docs/release-notes.md
git commit -m "docs: add release notes" >/dev/null

git tag v1.0.0 >/dev/null

cat > EXERCISE.md <<'EOT'
# Senior-Level Git Objectives

1. Clean up history by fixing the misspelled "mutiply" commit message.
2. Cherry-pick the audit logging commit from `feature/audit-log` onto `main`.
3. Merge `feature/conflict` into `main` and resolve the conflict in `src/calculator.cpp`.
4. Squash the last two documentation commits on `main` into a single cohesive update.
5. Document your workflow (commands used, rationale) in `docs/release-notes.md` after completing the tasks.
EOT

git add EXERCISE.md
git commit -m "docs: outline senior-level git exercise" >/dev/null

cat > README.md <<'EOT'
# Senior Git Playground

Use this repo to assess advanced Git skills.

## Current Features
- Addition
- Subtraction
- Multiplication

## Interview Prompts
- Complex rebases
- Cherry-picking releases
- Conflict management
EOT

git add README.md
git commit -m "docs: add interview prompts" >/dev/null

# Branch for audit logging (to be cherry-picked).
git checkout -b feature/audit-log >/dev/null

cat > src/main.cpp <<'EOT'
#include <iostream>
#include "../include/calculator.h"

static void log_operation(const std::string &label, int result) {
    std::cout << "[AUDIT] " << label << " => " << result << std::endl;
}

int main() {
    Calculator calc;
    log_operation("Add", calc.add(4, 9));
    log_operation("Subtract", calc.subtract(12, 5));
    log_operation("Multiply", calc.multiply(3, 3));
    return 0;
}
EOT

cat > include/calculator.h <<'EOT'
#pragma once

class Calculator {
public:
    int add(int a, int b);
    int subtract(int a, int b);
    int multiply(int a, int b);
};
EOT

git add include/calculator.h src/main.cpp
git commit -m "feat: add audit logging helpers" >/dev/null

# Branch for conflict scenario.
git checkout main >/dev/null
git checkout -b feature/conflict >/dev/null

cat > src/calculator.cpp <<'EOT'
#include "../include/calculator.h"

int Calculator::add(int a, int b) {
    // Adds two numbers with simple overflow assumptions
    return a + b;
}

int Calculator::subtract(int a, int b) {
    return a - b;
}

int Calculator::multiply(int a, int b) {
    return a * b;
}
EOT

git add src/calculator.cpp
git commit -m "feat: annotate add implementation" >/dev/null

# Diverging change on main to produce conflict.
git checkout main >/dev/null

cat > src/calculator.cpp <<'EOT'
#include "../include/calculator.h"

int Calculator::add(int a, int b) {
    // Computes sum and assumes operands fit into int32
    return a + b;
}

int Calculator::subtract(int a, int b) {
    return a - b;
}

int Calculator::multiply(int a, int b) {
    return a * b;
}
EOT

git add src/calculator.cpp
git commit -m "refactor: clarify add guard rails" >/dev/null

# Docs commits to squash later.
cat >> README.md <<'EOT'

## Usage
1. Configure with CMake
2. Build and run `main`
EOT

git add README.md
git commit -m "docs: add usage steps" >/dev/null

cat >> README.md <<'EOT'
3. Package the binary for interview demos
4. Share git history with the candidate
EOT

git add README.md
git commit -m "docs: expand usage guide" >/dev/null

cat <<'EOT'
✅ Senior playground ready.
Branches available: main, feature/audit-log, feature/conflict
Tag created: v1.0.0
Location: $(pwd)
EOT
