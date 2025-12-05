#!/bin/bash

# Script to create a CMake project with build issues for interviews

echo "Creating CMake Build Scenario..."

DIR_NAME="cmake-challenge"

if [ -d "$DIR_NAME" ]; then
    echo "Directory $DIR_NAME already exists. Please remove it or run this script in a clean directory."
    exit 1
fi

mkdir $DIR_NAME
cd $DIR_NAME
git init

# Commit 1: Initial Setup with broken CMakeLists.txt
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(CMakeChallenge)

set(CMAKE_CXX_STANDARD 17)

add_library(math_lib math_lib.cpp)
add_executable(app main.cpp)
EOF

cat > math_lib.h << 'EOF'
#pragma once

namespace MathLib {
    int add(int a, int b);
    int multiply(int a, int b);
}
EOF

cat > math_lib.cpp << 'EOF'
#include "math_lib.h"

namespace MathLib {
    int add(int a, int b) {
        return a + b;
    }

    int multiply(int a, int b) {
        return a * b;
    }
}
EOF

cat > main.cpp << 'EOF'
#include <iostream>
#include "math_lib.h"

int main() {
    int a = 5;
    int b = 3;

    std::cout << "Addition: " << MathLib::add(a, b) << std::endl;
    std::cout << "Multiplication: " << MathLib::multiply(a, b) << std::endl;

    return 0;
}
EOF

git add .
git commit -m "Initial commit: Basic calculator app"

echo ""
echo "========================================="
echo "Scenario '$DIR_NAME' created."
echo "========================================="
echo "Task: Fix CMakeLists.txt to build successfully."
echo "Scenario ready at: $(pwd)/$DIR_NAME"
