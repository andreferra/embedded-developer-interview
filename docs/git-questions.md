# Git Technical Interview Questions

This file contains the questions and solutions for the Git technical interview.

## Setup
Run the Git setup script that matches the candidate's level:

- **Junior:** `scripts/git/setup_git_junior.sh` → creates `git-playground-junior`
- **Mid:** `scripts/git/setup_git_mid.sh` → creates `git-playground-mid`
- **Senior:** `scripts/git/setup_git_senior.sh` → creates `git-playground-senior`

For a generalized all-in-one repo you can still use `scripts/git/setup_interview_repo.sh`, which creates the `cpp-interview-practice` repository.

<div style="
    background: #ffffff;
    padding: 20px 24px;
    border: 2px solid #e5e7eb;
    border-left: 6px solid #6366f1;
    margin-bottom: 24px;
    border-radius: 6px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
">
    <p style="margin: 0; font-weight: 600; color: #1f2937; font-size: 16px; letter-spacing: -0.01em;">
        📝 Note
    </p>
    <p style="margin: 8px 0 0; color: #6b7280; font-size: 14px; line-height: 1.7;">
        Each level-specific script seeds its repository with targeted Git scenarios:
    </p>
    <ul style="margin: 10px 0 0 0; padding-left: 20px; color: #6b7280; font-size: 14px; line-height: 1.8;">
        <li><strong>Junior</strong>: short history that encourages branching, simple commits, and diff reviews.</li>
        <li><strong>Mid</strong>: includes an intentional commit-message typo plus a `feature/division` branch ready for rebasing and stashing practice.</li>
        <li><strong>Senior</strong>: provides an `feature/audit-log` cherry-pick target and a `feature/conflict` branch that triggers a merge conflict.</li>
    </ul>
</div>


## Exercises

### 1. View the commit history
**Question:** View the commit history of the repository to understand what has happened so far.
</br>
**Solution:**
```bash
git log --oneline
```

### 2. Fix the typo in commit 4
**Question:** There is a typo in the commit message of the 4th commit ("mutiply" instead of "multiply"). Fix this typo.
</br>
**Solution:**
```bash
git rebase -i HEAD~2
# Then change 'pick' to 'reword' for the commit with the typo
```

### 3. Create a new branch for division feature
**Question:** Create a new branch named `feature/division` to implement the division feature.
</br>
**Solution:**
```bash
git checkout -b feature/division
```

### 4. Add division method on the new branch
**Question:** Implement the division method in the `Calculator` class.
- Add `int divide(int a, int b);` to `calculator.h`
- Implement it in `calculator.cpp`
- Commit your changes with the message "Add division operation"

**Solution:**
</br>
*Edit calculator.h:*
```cpp
// Add to class Calculator:
int divide(int a, int b);
```

*Edit calculator.cpp:*
```cpp
// Add implementation:
int Calculator::divide(int a, int b) {
    if (b == 0) return 0; // Simple error handling for interview
    return a / b;
}
```

*Commit:*
```bash
git add calculator.h calculator.cpp
# or git add .
git commit -m "Add division operation"
```

### 5. Rebase the feature branch onto main
**Question:** Suppose that `main` has moved forward (you can simulate this or just explain). Rebase your `feature/division` branch onto `main`.
</br>
**Solution:**
```bash
git rebase main
```

### 6. Squash the last 2 commits on main
**Question:** Squash the last 2 commits on the `main` branch into a single commit.
</br>
**Solution:**
```bash
git checkout main
git rebase -i HEAD~2
# Then leave the first as 'pick' and change the second to 'squash' (or 's')
```

### 7. View the difference between commits
**Question:** Show the difference between the current commit and the previous one.
</br>
**Solution:**
```bash
git diff HEAD~1 HEAD
```

### 8. Cherry-pick a specific commit
**Question:** Cherry-pick a specific commit (e.g., the division commit) onto another branch.
</br>
**Solution:**
```bash
git checkout <target-branch>
git cherry-pick <commit-hash>
```

### 9. Resolve a Merge Conflict
**Question:** Merge the `feature/conflict` branch into `main`. You will encounter a merge conflict in `calculator.cpp`. Resolve it by keeping both comments (or choosing one, up to the interviewer) and complete the merge.
</br>
**Solution:**
```bash
git merge feature/conflict
# Conflict occurs
# Edit calculator.cpp to resolve markers <<<<<<< ======= >>>>>>>
git add calculator.cpp
git commit # Finishes the merge
```

### 10. Stash Changes
**Question:** You are working on `main` and have modified `calculator.cpp` but aren't ready to commit. You need to switch to `feature/division` to check something. Stash your changes, switch branches, then switch back and apply the stash.
</br>
**Solution:**
```bash
# Modify a file first if needed for the demo
git stash
git checkout feature/division
# ... do stuff ...
git checkout main
git stash pop
```

### 11. Merge feature branch without fast-forward
**Question:** Working inside `git-playground-junior`, you finished the `feature/multiply` branch and want the history to show an explicit merge commit. Merge the branch back into `main` without fast-forwarding.
</br>
**Solution:**
```bash
git checkout main
git merge --no-ff feature/multiply -m "Merge feature/multiply with multiply support"
```

### 12. Cherry-pick the audit logging commit
**Question:** In `git-playground-senior`, apply the audit logging change from the `feature/audit-log` branch onto `main` without merging the whole branch.
</br>
**Solution:**
```bash
git checkout main
git cherry-pick feature/audit-log
# Alternatively cherry-pick the specific hash shown by `git log feature/audit-log -1 --oneline`
```

### 13. Recover from a failed rebase
**Question:** While rebasing `feature/conflict` from `git-playground-senior` onto `main`, you hit a conflict in `src/calculator.cpp` and decide to abandon the attempt. Reset the repository back to the pre-rebase state.
</br>
**Solution:**
```bash
# If Git is still in the rebase state:
git rebase --abort

# If you already resolved conflicts but want to rewind further:
git reflog
git reset --hard HEAD@{1}   # pick the reflog entry prior to the rebase
```

### 14. Reset main to match origin
**Question:** In `git-playground-senior`, assume `main` has diverged locally and you need to force it to match `origin/main` (e.g., before restarting the merge exercises). How do you safely reset the branch?
</br>
**Solution:**
```bash
git fetch origin
git checkout main
git reset --hard origin/main
# If you had local work you care about, capture it first with `git branch backup/main-backup` or `git stash`
```
