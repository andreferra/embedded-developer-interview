#!/bin/bash

# Script to create a C++ project with a race condition scenario for interviews

echo "Creating C++ Race Condition Scenario..."

DIR_NAME="cpp-race-condition"

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
project(RaceConditionScenario)

set(CMAKE_CXX_STANDARD 17)

find_package(Threads REQUIRED)

add_executable(main main.cpp)
target_link_libraries(main Threads::Threads)
EOF

cat > main.cpp << 'EOF'
#include <iostream>
#include <thread>
#include <vector>
#include <chrono>

struct Account {
    int balance = 0;
};

void deposit(Account& account, int amount) {
    // Processing...
    int current = account.balance;
    std::this_thread::sleep_for(std::chrono::milliseconds(1)); 
    account.balance = current + amount;
}

int main() {
    Account myAccount;
    std::vector<std::thread> threads;
    
    std::cout << "Starting balance: " << myAccount.balance << std::endl;

    // Launch 100 threads, each depositing 10
    for (int i = 0; i < 100; ++i) {
        threads.emplace_back(deposit, std::ref(myAccount), 10);
    }

    for (auto& t : threads) {
        t.join();
    }

    std::cout << "Final balance: " << myAccount.balance << std::endl;
    std::cout << "Expected balance: 1000" << std::endl;

    if (myAccount.balance != 1000) {
        std::cout << "RACE CONDITION DETECTED!" << std::endl;
    } else {
        std::cout << "Matches expected" << std::endl;
    }

    return 0;
}
EOF

git add .
git commit -m "Initial commit: Threaded bank account deposit simulation"

echo ""
echo "========================================="
echo "Scenario '$DIR_NAME' created."
echo "========================================="
echo "Problem: Multiple threads access shared data without synchronization."
echo "Goal: Fix the race condition to ensure the balance is always correct."
echo "Location: $(pwd)"
