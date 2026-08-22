---
name: git
description: Perform Git operations: commit, push, pull, branch, merge, rebase, and resolve conflicts. Use when managing version control, creating branches, reviewing diffs, or collaborating on code.
license: MIT
compatibility: Requires git 2.0+ installed
metadata:
  author: opencode
  version: "1.0"
allowed-tools: Bash(git:*) Read Write
---

# Git Skill

Perform Git version control operations.

## Core Commands

### Status & Info
```bash
git status                    # Working tree status
git log --oneline -10         # Last 10 commits
git diff                      # Unstaged changes
git diff --staged             # Staged changes
git branch -a                 # List all branches
```

### Staging & Committing
```bash
git add <file>                # Stage specific file
git add -A                    # Stage all changes
git commit -m "message"       # Commit with message
git commit --amend            # Amend last commit
```

### Branching
```bash
git branch <name>             # Create branch
git checkout <name>           # Switch branch
git checkout -b <name>        # Create and switch
git branch -d <name>          # Delete branch
git branch -D <name>          # Force delete
```

### Remote Operations
```bash
git remote add origin <url>   # Add remote
git push origin <branch>      # Push to remote
git push -u origin <branch>   # Push and set upstream
git pull                      # Fetch and merge
git fetch                     # Fetch without merge
```

### Merging & Rebasing
```bash
git merge <branch>            # Merge branch
git rebase <branch>           # Rebase onto branch
git rebase --abort            # Abort rebase
git merge --abort             # Abort merge
```

### Undoing Changes
```bash
git reset HEAD <file>         # Unstage file
git checkout -- <file>        # Discard changes
git revert <commit>           # Revert commit
git reset --soft HEAD~1       # Undo last commit (keep changes)
git reset --hard HEAD~1       # Undo last commit (discard changes)
```

### Stashing
```bash
git stash                     # Stash changes
git stash pop                 # Apply and remove stash
git stash list                # List stashes
git stash drop                # Remove stash
```

## Commit Message Convention

```
<type>: <description>

Types:
- feat:     New feature
- fix:      Bug fix
- docs:     Documentation
- style:    Formatting
- refactor: Code restructuring
- test:     Adding tests
- chore:    Maintenance
```

**Example:**
```bash
git commit -m "feat: add user authentication module"
git commit -m "fix: resolve connection timeout issue"
```

## Workflow: Feature Branch

```bash
git checkout main
git pull
git checkout -b feature/new-feature
# ... make changes ...
git add -A
git commit -m "feat: add new feature"
git push -u origin feature/new-feature
# Create PR on GitHub
```

## Conflict Resolution

1. Open conflicted files
2. Look for conflict markers:
   ```
   <<<<<<< HEAD
   your changes
   =======
   incoming changes
   >>>>>>> branch-name
   ```
3. Edit to resolve, remove markers
4. `git add <file>`
5. `git commit`

## Useful Aliases

Add to `~/.gitconfig`:
```ini
[alias]
    s = status
    l = log --oneline -10
    d = diff
    co = checkout
    br = branch
    cm = commit -m
```
