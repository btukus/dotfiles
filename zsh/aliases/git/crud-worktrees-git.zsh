function gwag() {
  if [ -z "$1" ]; then
    echo "Please provide a branch name."
    return 1
  fi

  git pull
  root_dir=$(git rev-parse --show-toplevel 2>/dev/null)
  cd $root_dir || {
    echo "Failed to find the git root directory."
    return 1
  }

  branch=$1
  remote_branch=$(git ls-remote --heads origin $branch)

  if [ -z "$remote_branch" ]; then
    git worktree add --checkout ../$branch && cd ../$branch
  else
    git worktree add --track -b $branch ../$branch origin/$branch && cd ../$branch
    echo "Worktree created and branch name copied to clipboard."
  fi
}

function gwd() {
  root_worktree=$(git rev-parse --show-toplevel 2>/dev/null)
  current_branch=$(git branch --show-current)
  repo_root=$(dirname "$root_worktree")
  
  # Move to root of worktree, then go to repo root, delete worktree
  cd $root_worktree
  cd ../
  git worktree remove -f "$root_worktree"

  # Define potential base branches
  for base_branch in dev develop main master; do
    branch_dir="$repo_root/$base_branch"

    if [[ -d "$branch_dir" ]]; then
      cd "$branch_dir"
      git pull
      git branch -D "$current_branch"
      return
    fi
  done

  echo "Neither 'develop', 'main', nor 'master' branch found."
}
