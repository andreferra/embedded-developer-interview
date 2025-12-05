# C++ Technical Interview Questions
 
This page contains scenarios and questions for C++ technical interviews.
 
## Scenario 1: Memory Leak
 
### Setup
Run the setup script:
```bash
./scripts/cpp/setup_memory_leak.sh
```
This creates a `cpp-memory-leak` directory with a CMake project.

<div style="
    background: #ffffff;
    padding: 20px 24px;
    border: 2px solid #e5e7eb;
    border-left: 6px solid #8b5cf6;
    margin-bottom: 24px;
    border-radius: 6px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
">
    <p style="margin: 0; font-weight: 600; color: #1f2937; font-size: 16px; letter-spacing: -0.01em;">
        💡 Hint for Interviewer
    </p>
    <p style="margin: 10px 0 0; color: #6b7280; font-size: 14px; line-height: 1.7;">
        The memory leak is caused by the <code style="background: #f3f4f6; padding: 2px 6px; border-radius: 3px; font-size: 13px; color: #4b5563;">ResourceManager</code> storing pointers to <code style="background: #f3f4f6; padding: 2px 6px; border-radius: 3px; font-size: 13px; color: #4b5563;">Resource</code> objects (allocated with <code style="background: #f3f4f6; padding: 2px 6px; border-radius: 3px; font-size: 13px; color: #4b5563;">new</code>) but never deleting them. Additionally, <code style="background: #f3f4f6; padding: 2px 6px; border-radius: 3px; font-size: 13px; color: #4b5563;">Resource</code> allocates an array in its constructor but its destructor is never called due to the missing cleanup in <code style="background: #f3f4f6; padding: 2px 6px; border-radius: 3px; font-size: 13px; color: #4b5563;">ResourceManager</code>.
    </p>
</div>

### Problem Description
The `ResourceManager` class manages a collection of `Resource` objects. However, after running the simulation, it seems that memory is not being released correctly.
 
### Exercises
 
#### 1. Identify the Leak
**Question:** Run the program (or use Valgrind/ASan if available) and inspect the code to identify why memory is leaking.
 
**Solution:**
The `ResourceManager::addResource` method uses `new` to allocate `Resource` objects and stores pointers in a `std::vector<Resource*>`. However, `ResourceManager` does not have a destructor that deletes these pointers.
Additionally, `Resource` allocates an array `data = new int[100]` but the destructor `delete[] data` is never called because the `Resource` objects themselves are never deleted.
 
#### 2. Fix the Leak (Modern C++)
**Question:** Refactor the code to use smart pointers (`std::unique_ptr` or `std::shared_ptr`) to automatically manage the memory.
 
**Solution:**
Change `std::vector<Resource*> resources` to `std::vector<std::unique_ptr<Resource>> resources`.
Update `addResource` to use `std::make_unique`.
 
*Modified `resource.h`:*
```cpp
#include <memory>
// ...
std::vector<std::unique_ptr<Resource>> resources;
```
 
*Modified `resource.cpp`:*
```cpp
void ResourceManager::addResource(int id) {
    resources.push_back(std::make_unique<Resource>(id));
}
```
With this change, the `vector` destructor will destroy the `unique_ptr`s, which will call the `Resource` destructor, which will `delete[]` the raw array.
 
---
 
## Scenario 2: Race Condition
 
### Setup
Run the setup script:
```bash
./scripts/cpp/setup_race_condition.sh
```
This creates a `cpp-race-condition` directory.

<div style="
    background: #ffffff;
    padding: 20px 24px;
    border: 2px solid #e5e7eb;
    border-left: 6px solid #8b5cf6;
    margin-bottom: 24px;
    border-radius: 6px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
">
    <p style="margin: 0; font-weight: 600; color: #1f2937; font-size: 16px; letter-spacing: -0.01em;">
        💡 Hint for Interviewer
    </p>
    <p style="margin: 10px 0 0; color: #6b7280; font-size: 14px; line-height: 1.7;">
        The code simulates a race condition by introducing an artificial delay <code style="background: #f3f4f6; padding: 2px 6px; border-radius: 3px; font-size: 13px; color: #4b5563;">std::this_thread::sleep_for</code> comfortably inside the "read-modify-write" sequence of the <code style="background: #f3f4f6; padding: 2px 6px; border-radius: 3px; font-size: 13px; color: #4b5563;">deposit</code> function, ensuring that threads overwrite each other's updates to the balance.
    </p>
</div>

### Problem Description
The program simulates multiple threads depositing money into a single bank account. However, the final balance is often incorrect (less than expected).
 
### Exercises
 
#### 1. Explain the Race Condition
**Question:** Why is the final balance incorrect?
 
**Solution:**
The operation `account.balance = current + amount;` (and the read before it) is not atomic. Multiple threads read the same `current` value, add to it, and write back, overwriting each other's updates. This is a classic "read-modify-write" race condition.
 
#### 2. Fix with Mutex
**Question:** Fix the race condition using `std::mutex`.
 
**Solution:**
Add a `std::mutex` to the `Account` struct (or global) and lock it during the critical section.
 
```cpp
#include <mutex>
 
struct Account {
    int balance = 0;
    std::mutex mtx; // Add mutex
};
 
void deposit(Account& account, int amount) {
    std::lock_guard<std::mutex> lock(account.mtx); // Lock
    int current = account.balance;
    std::this_thread::sleep_for(std::chrono::milliseconds(1)); 
    account.balance = current + amount;
}
// Note: thread creation loop needs to pass ref properly if mutex is not movable/copyable
```
 
#### 3. Fix with Atomics
**Question:** Fix the race condition using `std::atomic` (if the logic allows simple addition).
 
**Solution:**
Change `int balance` to `std::atomic<int> balance`.
 
```cpp
#include <atomic>
 
struct Account {
    std::atomic<int> balance{0};
};
 
void deposit(Account& account, int amount) {
    // No mutex needed for simple addition, assuming logic is just + amount
    // The previous "read, sleep, write" logic was artificial to force the race.
    // If we keep the logic structure strict, we need mutex. 
    // If we just want "atomic add":
    account.balance += amount; 
}
```
