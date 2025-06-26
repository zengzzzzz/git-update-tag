#!/bin/bash

# checkout master branch and discard all local changes
if git rev-parse --verify master >/dev/null 2>&1; then
    git checkout master
    git reset --hard
    git clean -fd
    echo "Switched to master branch and discarded all local changes."
else
    echo "Master branch does not exist. Please create it first."
    exit 1
fi

# Check if the current directory is a Git repository
if [ ! -d ".git" ]; then
  echo "The current directory is not a Git repository."
  exit 1
fi


# Pull the latest code from the remote repository
current_branch=$(git rev-parse --abbrev-ref HEAD)
remote_branch="origin/$current_branch"

echo "Fetching remote info..."
git fetch

local_commit=$(git rev-parse $current_branch)
remote_commit=$(git rev-parse $remote_branch)

if [[ "$local_commit" == "$remote_commit" ]]; then
  echo "no update no tag。"
  exit 0
else
  echo "update and fetching... "
  git pull
fi

# Determine the latest tag and calculate the new tag
latest_tag=$(git tag -l | grep -E '^v?[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -n 1)
if [[ -z "$latest_tag" ]]; then
    echo "No tags found. Using v0.0.1"
    major=0
    minor=0
    patch=1
    new_tag="v0.0.1"
else
    ver="${latest_tag#v}"
    IFS='.' read -r major minor patch <<< "$ver"
    # Increment the patch version
    patch=$((patch + 1))
    if [[ $patch -ge 100 ]]; then
        patch=0
        minor=$((minor + 1))
        # If minor version reaches 100, reset it and increment major version
        if [[ $minor -ge 100 ]]; then
            minor=0
            major=$((major + 1))
        fi
    fi
    new_tag="$major.$minor.$patch"
    [[ "$latest_tag" == v* ]] && new_tag="v$new_tag"
fi

echo "latest tag: $latest_tag"
echo "new tag: $(basename "$PWD") $new_tag"

# Ask for confirmation before pushing
read -p "Do you want to push the new tag '$new_tag' to the remote repository? (y/n): " confirm
if [ "$confirm" != "y" ]; then
  echo "Tag push canceled."
  exit 1
fi

# Create and push the new tag
git tag "$new_tag"
git push origin "$new_tag"

echo "pushed tag: $(basename "$PWD") $new_tag"