#!/bin/bash

# Script to create a C++ project with a memory leak scenario for interviews

echo "Creating C++ Memory Leak Scenario..."

DIR_NAME="cpp-memory-leak"

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
project(MemoryLeakScenario)

set(CMAKE_CXX_STANDARD 17)

add_executable(main main.cpp resource.cpp)
EOF

cat > resource.h << 'EOF'
#pragma once
#include <iostream>
#include <vector>

class Resource {
public:
    Resource(int id);
    ~Resource();
    void process();

private:
    int id;
    int* data;
};

class ResourceManager {
public:
    void addResource(int id);
    void processAll();

private:
    std::vector<Resource*> resources;
};
EOF

cat > resource.cpp << 'EOF'
#include "resource.h"

Resource::Resource(int id) : id(id) {
    data = new int[100];
    std::cout << "Resource " << id << " created." << std::endl;
}

Resource::~Resource() {
    delete[] data;
    std::cout << "Resource " << id << " destroyed." << std::endl;
}

void Resource::process() {
    std::cout << "Processing resource " << id << std::endl;
}

void ResourceManager::addResource(int id) {
    resources.push_back(new Resource(id));
}

void ResourceManager::processAll() {
    for (auto res : resources) {
        res->process();
    }
}
EOF

cat > main.cpp << 'EOF'
#include <iostream>
#include "resource.h"

void runSimulation() {
    ResourceManager manager;
    manager.addResource(1);
    manager.addResource(2);
    manager.addResource(3);
    manager.processAll();
    // Simulation end
}

int main() {
    std::cout << "Starting Memory Leak Simulation..." << std::endl;
    runSimulation();
    std::cout << "Simulation finished." << std::endl;
    return 0;
}
EOF

git add .
git commit -m "Initial commit: ResourceManager implementation"

echo ""
echo "========================================="
echo "Scenario '$DIR_NAME' created."
echo "========================================="
echo "Scenario ready at: $(pwd)"
