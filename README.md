# Git Auto Tagging Script

This Bash script automates the process of checking out the `master` branch, discarding all local changes, pulling the latest remote code, and creating a new semantic version tag.

## Features

- Switches to `master` branch and discards all local changes
- Ensures you are working inside a git repository
- Pulls the latest code from the remote repository
- Automatically determines and applies the next semantic tag (`vMAJOR.MINOR.PATCH`)
- Asks for confirmation before creating and pushing a new tag

## Prerequisites

- Bash shell (Linux/macOS or Git Bash/WSL for Windows)
- [Git](https://git-scm.com/)

## How to Use

1. **Copy the script** to your project root folder (e.g. save as `release.sh`).

2. **Give execute permission** to your script:
    ```sh
    chmod +x release.sh
    ```

3. **Navigate to your git repository root**:
    ```sh
    cd your-git-project
    ```

4. **Run the script**:
    ```sh
    ./release.sh
    ```

5. **Confirm to push the new tag** when prompted.

## What the Script Does

1. Checks if `master` branch exists and switches to it, resetting and cleaning all uncommitted and untracked changes.
2. Verifies if current directory is a Git repository.
3. Fetches from remote, compares local and remote commits, and pulls latest changes if necessary.
4. Scans all tags, finds the latest semantic version, and increments the patch number (handles overflow to minor/major versions).
5. Prints information about the latest and proposed new tag.
6. Asks for confirmation before tagging and pushing.
7. Tags and pushes the new version tag to the remote repo.

## Versioning Rules

- Tags must match `vMAJOR.MINOR.PATCH` or `MAJOR.MINOR.PATCH` (like `v1.2.3`)
- If no tag exists, starts from `v0.0.1`
- Increments the patch version by default
- If patch reaches 100, resets to 0 and increments minor
- If minor reaches 100, resets to 0 and increments major

## Warnings

> **⚠️ This script will remove all local changes and untracked files!**  
> Make sure to commit or stash your work before using it.

## License

MIT License