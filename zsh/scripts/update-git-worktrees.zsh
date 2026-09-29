#!/bin/zsh

# Sourced by `gu` (05-git.zsh): use return, never exit (it would close the shell).
# Directories containing git worktrees: colon-separated $WORKTREE_ROOTS (set in the private overlay)
directories=(${(s.:.)WORKTREE_ROOTS})
(( $#directories )) || { echo "Set WORKTREE_ROOTS (colon-separated repo dirs) first"; return 1; }

current_dir=$(pwd)

# Function to check if a directory is a Git worktree
is_git_worktree() {
    local repo_dir=$1
    [[ -d "$repo_dir/worktrees" ]]
}

# Path of the worktree that has <branch> checked out, if any. Asking git keeps
# this independent of where the worktrees sit on disk (bare repos: <repo>/wt/).
worktree_of_branch() {
    git -C "$1" worktree list --porcelain |
        awk -v b="branch refs/heads/$2" '/^worktree /{w=substr($0,10)} $0==b{print w; exit}'
}

# Function to update a git repository
update_git_repo() {
    local repo_dir=$1 branch dir
    echo "Entering $repo_dir"

    # Check if it's a git worktree
    if is_git_worktree "$repo_dir"; then
        for branch in main master; do
            git -C "$repo_dir" show-ref -q --verify "refs/heads/$branch" || continue
            dir=$(worktree_of_branch "$repo_dir" "$branch")
            if [[ -z $dir ]]; then
                echo "No worktree checked out on $branch in $repo_dir, skipping."
                return
            fi
            git -C "$dir" pull --quiet --ff-only ||
                echo "Pull on $branch failed in $dir"
            return
        done
        echo "Neither main nor master branch found in $repo_dir, skipping."
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
