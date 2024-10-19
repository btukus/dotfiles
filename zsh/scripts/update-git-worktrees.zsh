#!/bin/zsh

# Array of directories containing git worktrees
directories=(
  "${HOME}/drive/mac/development/conclusion"
  "${HOME}/drive/mac/development/ringshard"
  "${HOME}/drive/mac/development/sensey"
)

current_dir=$(pwd)

# Function to check if a directory is a Git worktree
is_git_worktree() {
    local repo_dir=$1
    [[ -d "$repo_dir/worktrees" ]]
}

# Function to update a git repository
update_git_repo() {
    local repo_dir=$1
    echo "Entering $repo_dir"

    # Check if it's a git worktree
    if is_git_worktree "$repo_dir"; then
        cd "$repo_dir"

        # Check for main or master branch
        if git rev-parse --verify --quiet main; then
            cd main
            git checkout main --quiet
            git pull --quiet
            cd $repo_dir
        elif git rev-parse --verify --quiet master; then
            cd master
            git checkout master --quiet
            git pull --quiet
            cd $repo_dir
        else
            echo "Neither main nor master branch found in $repo_dir, skipping."
        fi
    else
        echo "Not a git worktree: $repo_dir"
    fi
}

# Iterate over each directory
for dir in $directories; do
    # Check if the directory exists
    if [[ -d $dir ]]; then
        # List all items in the directory
        for item in $dir/*; do
            # Proceed only if the item is a directory
            if [[ -d $item ]]; then
                update_git_repo "$item"
            fi
        done
    else
        echo "Directory not found: $dir"
    fi
done

cd $current_dir
