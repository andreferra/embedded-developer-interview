#!/bin/bash

# Script to create a fake C++ repository for technical interview practice
# This simulates a real project history with multiple commits

echo "Creating C++ Interview Practice Repository..."

# Create and initialize repository
mkdir cpp-interview-practice
cd cpp-interview-practice
git init

# Commit 1: Initial project setup
cat > main.cpp << 'EOF'
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
EOF

cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(InterviewPractice)

set(CMAKE_CXX_STANDARD 17)

add_executable(main main.cpp)
EOF

git add .
git commit -m "Initial commit: Add basic C++ project structure"

# Commit 2: Add a simple calculator class
cat > calculator.h << 'EOF'
#pragma once

class Calculator {
public:
    int add(int a, int b);
    int subtract(int a, int b);
};

EOF

cat > calculator.cpp << 'EOF'
#include "calculator.h"

int Calculator::add(int a, int b) {
    return a + b;
}

int Calculator::subtract(int a, int b) {
    return a - b;
}
EOF

git add calculator.h calculator.cpp
git commit -m "Add Calculator class with basic operations"

# Commit 3: Update main to use calculator
cat > main.cpp << 'EOF'
#include <iostream>
#include "calculator.h"

int main() {
    Calculator calc;
    std::cout << "5 + 3 = " << calc.add(5, 3) << std::endl;
    std::cout << "5 - 3 = " << calc.subtract(5, 3) << std::endl;
    return 0;
}
EOF

cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(InterviewPractice)

set(CMAKE_CXX_STANDARD 17)

add_executable(main main.cpp calculator.cpp)
EOF

git add .
git commit -m "Update main.cpp to demonstrate Calculator usage"

# Commit 4: Add multiplication (with a typo in commit message)
cat > calculator.h << 'EOF'
#pragma once

class Calculator {
public:
    int add(int a, int b);
    int subtract(int a, int b);
    int multiply(int a, int b);
};

EOF

cat > calculator.cpp << 'EOF'
#include "calculator.h"

int Calculator::add(int a, int b) {
    return a + b;
}

int Calculator::subtract(int a, int b) {
    return a - b;
}

int Calculator::multiply(int a, int b) {
    return a * b;
}
EOF

git add .
git commit -m "Add mutiply method to Calculator"

# Commit 5: Add README
cat > README.md << 'EOF'
# C++ Calculator Project

A simple calculator implementation in C++ for demonstration purposes.

## Features
- Addition
- Subtraction
- Multiplication

## Building
```bash
mkdir build
cd build
cmake ..
make
```
EOF

git add README.md
git commit -m "Add README with project documentation"

# Commit 6: Create a conflict scenario
# Create a branch and modify a file
git checkout -b feature/conflict
cat > calculator.cpp << 'EOF'
#include "calculator.h"

int Calculator::add(int a, int b) {
    return a + b; // Basic addition
}

int Calculator::subtract(int a, int b) {
    return a - b;
}

int Calculator::multiply(int a, int b) {
    return a * b;
}
EOF
git commit -am "Improve add method comments"

# Go back to main and modify the same file differently
git checkout main
cat > calculator.cpp << 'EOF'
#include "calculator.h"

int Calculator::add(int a, int b) {
    return a + b; // Returns the sum
}

int Calculator::subtract(int a, int b) {
    return a - b;
}

int Calculator::multiply(int a, int b) {
    return a * b;
}
EOF
git commit -am "Update add method documentation"

echo ""
echo "========================================="
echo "Repository created successfully!"
echo "========================================="
echo ""
echo "Current location: $(pwd)"

