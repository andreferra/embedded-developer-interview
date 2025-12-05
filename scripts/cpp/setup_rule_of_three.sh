#!/bin/bash

# Script to create a C++ project with a Rule of Three violation (Double Free)

echo "Creating C++ Rule of Three Scenario..."

DIR_NAME="cpp-rule-of-three"

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
project(RuleOfThreeScenario)

set(CMAKE_CXX_STANDARD 17)

add_executable(app main.cpp)
EOF

cat > main.cpp << 'EOF'
#include <iostream>
#include <cstring>
#include <vector>

class MyString {
public:
    MyString(const char* str) {
        if (str) {
            size = std::strlen(str);
            data = new char[size + 1];
            std::strcpy(data, str);
        } else {
            size = 0;
            data = new char[1];
            data[0] = '\0';
        }
        std::cout << "Constructed: " << data << std::endl;
    }

    ~MyString() {
        std::cout << "Destructing: " << (data ? data : "null") << std::endl;
        delete[] data;
    }

    void print() const {
        std::cout << data << std::endl;
    }

private:
    char* data;
    size_t size;
};

int main() {
    std::vector<MyString> strings;
    
    std::cout << "Pushing first string..." << std::endl;
    strings.push_back(MyString("Hello")); // Temporary created, then copied into vector

    std::cout << "Pushing second string..." << std::endl;
    strings.push_back(MyString("World")); 
    std::cout << "Exiting main..." << std::endl;
    return 0;
}
EOF

git add .
git commit -m "Initial commit: MyString implementation"

echo ""
echo "========================================="
echo "Scenario '$DIR_NAME' created."
echo "========================================="
echo "Scenario ready at: $(pwd)"
