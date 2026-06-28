# Git functions

# Git commit and push
gcp() {
  if [[ -z "$1" ]]; then
    echo "Usage: gcp <commit message>"
    return 1
  fi
  git add --all
  if git commit -m "$1"; then
    git push
  else
    echo "Commit failed, not pushing"
    return 1
  fi
}

# Git update worktrees
gu() {
  source "$HOME/dotfiles/zsh/scripts/update-git-worktrees.zsh"
}

# Git worktree add with remote tracking
gwa() {
  if [[ -z "$1" ]]; then
    echo "Usage: gwa <branch>"
    return 1
  fi
  git rev-parse --git-dir >/dev/null 2>&1 || { echo "Not a git repository"; return 1; }
  git fetch origin "$1" || return 1
  git worktree add "$1" "$1" || git worktree add "$1" -b "$1" "origin/$1"
  cd "$1" || return 1
  git branch --set-upstream-to="origin/$1" "$1"
}

# Git worktree add (alternative)
gwag() {
  if [[ -z "$1" ]]; then
    echo "Usage: gwag <branch>"
    return 1
  fi

  local root_dir branch remote_branch

  if ! git pull; then
    echo "Warning: 'git pull' failed; continuing with worktree creation."
  fi
  root_dir=$(git rev-parse --show-toplevel 2>/dev/null)
  cd "$root_dir" || {
    echo "Failed to find the git root directory."
    return 1
  }

  branch=$1
  remote_branch=$(git ls-remote --heads origin "$branch")

  if [[ -z "$remote_branch" ]]; then
    git worktree add --checkout "../$branch" && cd "../$branch"
    echo "Worktree created for new branch: $branch"
  else
    git worktree add --track -b "$branch" "../$branch" "origin/$branch" && cd "../$branch"
    echo "Worktree created tracking origin/$branch"
  fi
}

# Git worktree add and open in cursor
gwc() {
  gwag "$@" || return 1
  cursor --reuse-window .
}

# Delete worktree and cleanup
gwd() {
  local root_worktree current_branch repo_root branch_dir delete_status

  root_worktree=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -z "$root_worktree" ]]; then
    echo "Not in a git repository"
    return 1
  fi

  current_branch=$(git branch --show-current)
  repo_root=$(dirname "$root_worktree")

  # Refuse to run without a clear, non-base branch to delete. This stops us from
  # ever running `git branch -D ""` or nuking a primary branch.
  if [[ -z "$current_branch" ]]; then
    echo "Could not determine current branch (detached HEAD?); aborting."
    return 1
  fi
  case "$current_branch" in
    dev|develop|main|master)
      echo "Refusing to delete base branch '$current_branch'."
      return 1
      ;;
  esac

  # Move out of the worktree first
  cd "$repo_root" || return 1

  # Remove worktree, fallback to manual removal if needed
  if ! git worktree remove -f "$root_worktree" 2>/dev/null; then
    echo "git worktree remove failed, forcing directory removal..."
    rm -rf "$root_worktree"
    git worktree prune
  fi

  # Verify the worktree directory is actually gone before touching the branch.
  # If files are still held open (e.g. a running dev server), bail out so we do
  # NOT delete the branch for a worktree that only got partially removed.
  if [[ -d "$root_worktree" ]]; then
    echo "Worktree dir still present (files in use? stop dev servers): $root_worktree"
    return 1
  fi

  # Find a base branch to switch to
  for base_branch in dev develop main master; do
    branch_dir="$repo_root/$base_branch"
    if [[ -d "$branch_dir" ]]; then
      cd "$branch_dir" || continue
      # Refresh the base branch, but a failed pull (e.g. offline) must not abort
      # cleanup nor be mistaken for success — warn loudly and continue.
      if ! git pull; then
        echo "Warning: 'git pull' on '$base_branch' failed; continuing with branch deletion anyway."
      fi
      # Worktree is confirmed gone, so it is now safe to delete the branch.
      # Report the actual exit status instead of swallowing it.
      git branch -D "$current_branch"
      delete_status=$?
      if [[ $delete_status -ne 0 ]]; then
        echo "Failed to delete branch '$current_branch' (git branch -D exit $delete_status)."
        return $delete_status
      fi
      echo "Deleted branch '$current_branch'."
      return 0
    fi
  done

  echo "Neither 'develop', 'main', nor 'master' branch found."
  return 1
}

# Delete worktree and open cursor
gwdc() {
  gwd && cursor --reuse-window .
}

# Find merge conflict files
gfm() {
  git ls-files -u | awk '{print $4}' | sort | uniq
}

# Go to git root
git_root_cd() {
  local dir
  dir=$(git rev-parse --show-toplevel 2>/dev/null)
  if [ -n "$dir" ]; then
    cd "$dir" || return 1
    return 0
  else
    echo "Not a git repository"
    return 1
  fi
}

ghd() {
  git_root_cd
}

ghdd() {
  if git_root_cd; then
    cd ../ || return 1
  fi
}

# Merge dev into current branch
gmd() {
  local current_location
  current_location=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -z "$current_location" ]]; then
    echo "Not in a git repository"
    return 1
  fi
  echo "Current location: $current_location"
  cd ../ || return 1
  cd dev || cd develop || return 1
  if ! git pull; then
    echo "Warning: 'git pull' on base branch failed; merging stale local base."
  fi
  cd "$current_location" || return 1
  git merge dev || git merge develop || return 1
}

# Rebase main and push to dev
grmd() {
  if ! git rebase main; then
    echo "Rebase failed. Resolve conflicts and run 'git rebase --continue'"
    return 1
  fi
  echo "About to force push to dev. Continue? [y/N]"
  read -r confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    git push -f origin dev:dev
  else
    echo "Push cancelled"
  fi
}

# Clone bare repo with worktrees
trim_git_suffix() {
  local url="$1"
  [[ $url =~ \.git$ ]] && url=${url%\.git}
  echo "$url"
}

gbare() {
  local repo_url="$1"
  if [[ -z "$repo_url" ]]; then
    echo "Error: No repository URL provided."
    return 1
  fi
  local trimmed_url=$(trim_git_suffix "$repo_url")
  local repo_name=$(basename "$trimmed_url")
  git clone --bare "$repo_url" "${repo_name}" || return 1
  cd "${repo_name}" || return 1
  git config --add remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  git fetch --all || return 1
  if git rev-parse --verify --quiet origin/main; then
    git worktree add --checkout main origin/main
    cd main || return 1
    git checkout main
    git push --set-upstream origin main
    cd ..
  elif git rev-parse --verify --quiet origin/master; then
    git worktree add --checkout master origin/master
    cd master || return 1
    git checkout master
    git push --set-upstream origin master
    cd ..
  else
    echo "Neither main nor master branch found, skipping."
  fi
  if git rev-parse --verify --quiet origin/dev; then
    git worktree add --checkout dev origin/dev
    cd dev || return 1
    git checkout dev
    git push --set-upstream origin dev
    echo "Worktree created and checked out for develop branch."
  else
    echo "Develop branch not found, skipping."
  fi
}

# Reset to commit SHA and force push
greset() {
  if [[ -z "$1" ]]; then
    echo "Usage: greset <commit-sha> <branch>"
    return 1
  fi
  if [[ -z "$2" ]]; then
    echo "Usage: greset <commit-sha> <branch>"
    return 1
  fi

  local commit=$1
  local branch=$2

  echo "WARNING: This will reset to $commit and force push to $branch"
  echo "Continue? [y/N]"
  read -r confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    git reset --hard "$commit"
    git push origin "$branch" --force
  else
    echo "Reset cancelled"
  fi
}

# Git remote fetch fix
gref() {
  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  git fetch
}

grefg() {
  git config --global remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  git fetch
}
