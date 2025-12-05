# C++ Technical Interview Questions
 
This page contains scenarios and questions for C++ technical interviews.

## Theoretical Questions

### Junior Level

#### 1. Reference vs Pointer
**Question:** What is the difference between a pointer and a reference? When would you use one over the other?

**Solution:**
*   **Nullability:** Pointers can be `nullptr`; references must always be bound to a valid object upon initialization.
*   **Reassignment:** Pointers can be reassigned to point to different objects; references are bound for their lifetime to the original object.
*   **Syntax:** Pointers need dereferencing (`*` or `->`); references use object syntax (`.`).
*   **Usage:** Use references by default for function parameters (pass-by-reference) and when null is not a valid state. Use pointers when you need to represent "optional" objects (can be null), when you need to re-seat the reference, or for pointer arithmetic.

#### 2. `const` usage
**Question:** Explain the difference between `const int* p`, `int* const p`, and `const int* const p`.

**Solution:**
*   `const int* p`: Pointer to a **constant integer**. The integer value cannot be changed through this pointer, but the pointer itself can be changed to point elsewhere. (Read backwards: "pointer to int constant").
*   `int* const p`: **Constant pointer** to an integer. The pointer cannot be changed (cannot point elsewhere), but the integer value it points to can be modified.
*   `const int* const p`: Constant pointer to a constant integer. Neither the pointer nor the value can be changed.

#### 3. Static Keyword
**Question:** What does `static` mean in: 
- a) global scope
- b) inside a function
- c) inside a class

**Solution:**
*   **Global/Namespace Scope:** The variable/function has **internal linkage**. It is only visible within the translation unit (source file) where it is defined.
*   **Function Scope:** The variable has **static storage duration**. It is initialized only once the first time the function is called and retains its value between function calls.
*   **Class Scope:** The member belongs to the **class itself**, not to any specific instance (object). There is only one copy of a static member variable shared by all instances.

#### 4. `volatile` Keyword
**Question:** What does the `volatile` keyword do? Why is it crucial in embedded systems?

**Solution:**
*   **Meaning:** It tells the compiler that the variable's value may change at any time, outside the control of the code (e.g., by hardware or an ISR).
*   **Effect:** It prevents the compiler from optimizing reads/writes to that variable (e.g., caching the value in a register). Every access in the code must result in a real memory access.
*   **Usage:** Essential for:
    1.  Memory-mapped hardware registers.
    2.  Global variables shared between an ISR (Interrupt Service Routine) and the main code.

### Mid Level

#### 1. Virtual Functions and VTable
**Question:** How does dynamic dispatch work in C++? Explain the concept of the VTable.

**Solution:**
*   **VTable (Virtual Table):** When a class has virtual functions, the compiler creates a static table (VTable) containing function pointers to the virtual functions for that class.
*   **VPTR (Virtual Pointer):** Each object of that class contains a hidden pointer (VPTR) that points to the VTable of its actual class type.
*   **Dispatch:** When a virtual function is called through a base pointer/reference, the program follows the object's VPTR to the VTable and looks up the correct function address to call at runtime. This allows the derived class's version to be executed even when accessed via a base interface.

#### 2. RAII and Smart Pointers
**Question:** Explain `std::unique_ptr` vs `std::shared_ptr`. Why should you generally avoid raw `new`/`delete`?

**Solution:**
*   **RAII (Resource Acquisition Is Initialization):** A pattern where resource management (memory, locks, handles) is tied to object lifetime. When the object goes out of scope, its destructor releases the resource.
*   **`std::unique_ptr`:** Represents **exclusive ownership**. It cannot be copied (only moved). It is lightweight and has zero overhead compared to a raw pointer. Use this by default.
*   **`std::shared_ptr`:** Represents **shared ownership**. It uses reference counting. The resource is deleted only when the last `shared_ptr` pointing to it is destroyed. It has overhead (atomic reference counter).
*   **Avoiding raw `new`/`delete`:** Manual memory management is error-prone (memory leaks, double frees, exception safety issues). Smart pointers handle cleanup automatically.

#### 3. Move Semantics
**Question:** What is the difference between `std::move` and `std::copy` (conceptually)? What are rvalues?

**Solution:**
*   **Move vs Copy:** Copying duplicates the data (expensive deep copy). Moving transfers ownership of the resources (e.g., internal pointers) from one object to another, leaving the source in a valid but unspecified (usually empty) state. This is highly efficient.
*   **`std::move`:** It is just a cast. It casts an object to an **rvalue reference** (`T&&`), enabling the compiler to select the move constructor or move assignment operator.
*   **Rvalues:** Temporary objects (e.g., return value of a function, `x + y`, literal `5`) that do not have a persistent name or address identifiable by the programmer. They are candidates for moving.

#### 4. Memory Segments
**Question:** Where do local variables, global variables, and `new` objects go in memory?

**Solution:**
*   **Stack:** Local variables, function parameters, return addresses. Managed automatically (LIFO).
*   **Heap:** Dynamic memory allocated via `new`/`malloc`. Managed manually (or via smart pointers).
*   **Data Segment:** specific section for initialized global and static variables.
*   **BSS Segment:** specific section for uninitialized global and static variables (initialized to 0 by default).
*   **Text/Code Segment:** The executable machine code and constant data (read-only).

### Senior Level

#### 1. Race Conditions & Memory Order
**Question:** Explain `std::memory_order_acquire` / `release` vs `seq_cst`. When might you need relaxed ordering?

**Solution:**
*   **`seq_cst` (Sequential Consistency):** The default stronger ordering. Guarantees a total global ordering of all atomic operations. It mimics the behavior where all threads execute instructions one by one in some global interleaving.
*   **Acquire/Release:** Used for synchronization.
    *   **Release:** A store operation. Ensures that all memory writes *before* this store are visible to the thread that performs the matching Acquire.
    *   **Acquire:** A load operation. Ensures that all memory reads *after* this load see the data written before the matching Release.
    *   *Usage:* Validating that a data structure is fully initialized before another thread reads it (Lock-free structures).
*   **Relaxed:** No synchronization or ordering guarantees, only atomicity. Used for counters or statistics where order vs other memory operations doesn't matter.

#### 2. ISR Safety
**Question:** What are the restricted operations inside an Interrupt Service Routine (ISR)?

**Solution:**
*   **No Blocking:** Cannot use mutexes, semaphores, or sleep functions, as this could deadlock the system or violate real-time constraints.
*   **No Dynamic Memory:** Avoid `new`/`malloc` as heap allocation is non-deterministic and often not thread-safe/reentrant.
*   **No I/O:** Avoid `printf` or file I/O (often blocking and slow).
*   **Speed:** Keep ISRs extremely short. Set a flag or push data to a lock-free queue and defer processing to the main loop `volatile` variables must be used for shared flags.

#### 3. Template Metaprogramming
**Question:** How can templates be used to reduce runtime overhead? (CRTP pattern).

**Solution:**
*   **Compile-time Polymorphism:** Unlike virtual functions (runtime dispatch), templates resolve types at compile time.
*   **CRTP (Curiously Recurring Template Pattern):** A technique where a derived class inherits from a base class template parameterized by the derived class itself: `class Derived : public Base<Derived>`.
    *   *Benefit:* `Base` can cast `this` to `Derived*` and call `Derived` methods statically. This mimics polymorphism (static interfaces) without the overhead of the vtable/virtual pointers.

#### 4. Object Slicing
**Question:** What is object slicing and how do you prevent it?

**Solution:**
*   **Slicing:** Occurs when you assign a derived class *object* to a base class *variable* (by value). The "derived" part of the object (extra member variables) is "sliced off," leaving only the base part.
*   **Prevention:** Always use pointers or references when dealing with polymorphic objects (`Base*` or `Base&`) so that the full object is preserved. Alternatively, delete copy constructors in base classes intended for polymorphism to prevent accidental slicing.

---
 
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

When changing to `std::unique_ptr`, you must iterate over the vector by reference:

```cpp
for (auto res : resources) 
{ 
    // Error: tries to copy unique_ptr
}
```    

`std::unique_ptr` cannot be copied. You must iterate by reference:

```cpp
for (const auto& res : resources) 
{
  // Correct: access by reference
  res->process();
}
```

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
