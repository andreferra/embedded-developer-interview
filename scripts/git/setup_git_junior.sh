#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR=${1:-git-playground-junior}

if [ -d "$TARGET_DIR" ]; then
  echo "Directory '$TARGET_DIR' already exists. Remove it or pass a new path." >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

git init -b main >/dev/null

mkdir -p src include

cat > README.md <<'EOT'
# Junior Git Playground

This mini calculator project is intentionally simple so candidates can practice core Git commands without distractions.
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
    std::cout << "Result: " << calc.add(2, 3) << std::endl;
    return 0;
}
EOT

git add README.md include/calculator.h src/calculator.cpp src/main.cpp
git commit -m "feat: bootstrap calculator app" >/dev/null

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
    std::cout << "Adds: " << calc.add(7, 5) << std::endl;
    std::cout << "Subtracts: " << calc.subtract(10, 4) << std::endl;
    return 0;
}
EOT

git add include/calculator.h src/calculator.cpp src/main.cpp
git commit -m "feat: add subtraction support" >/dev/null

cat > EXERCISE.md <<'EOT'
# Junior-Level Git Checklist

1. Inspect the history with `git log --oneline` and note how the calculator evolved.
2. Create a branch named `feature/multiply` and add a `multiply` method in both `include/calculator.h` and `src/calculator.cpp`.
3. Stage and commit your implementation with a clear message (e.g., `feat: add multiply support`).
4. Use `git diff` (or `git show`) to review the commit before sharing it with the interviewer.
5. Merge `feature/multiply` back into `main` without fast-forward to practice merge commits.
EOT

git add EXERCISE.md
git commit -m "docs: add junior exercise checklist" >/dev/null

cat <<'EOT'
✅ Junior playground ready.
Location: $(pwd)
Suggested next step: open EXERCISE.md and begin working through the checklist.
EOT
