#!/bin/bash

# Script to create a C++ project with a buffer overflow scenario

echo "Creating C++ Buffer Overflow Scenario..."

DIR_NAME="cpp-buffer-overflow"

if [ -d "$DIR_NAME" ]; then
    echo "Directory $DIR_NAME already exists. Please remove it or run this script in a clean directory."
    exit 1
fi

mkdir $DIR_NAME
cd $DIR_NAME
git init

# Commit 1: Initial Setup
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(BufferOverflowScenario)

set(CMAKE_CXX_STANDARD 17)

add_executable(app main.cpp)
EOF

cat > main.cpp << 'EOF'
#include <iostream>

void processData(int count) {
    int buffer[5];

    std::cout << "Processing " << count << " items..." << std::endl;

    for (int i = 0; i <= count; ++i) {
        buffer[i] = i * 10;
        std::cout << "Writing to index " << i << ": " << buffer[i] << std::endl;
    }
}

int main() {
    std::cout << "Starting application..." << std::endl;
    processData(6);
    std::cout << "Finished successfully (if you see this, you might have got lucky)." << std::endl;
    return 0;
}
EOF

git add .
git commit -m "Initial commit: Data processing logic"

echo ""
echo "========================================="
echo "Scenario '$DIR_NAME' created."
echo "========================================="
echo "Scenario ready at: $(pwd)"
