function gwag() {
  if [ -z "$1" ]; then
    echo "Please provide a branch name."
    return 1
  fi

  git pull
  root_dir=$(git rev-parse --show-toplevel 2> /dev/null)
  cd $root_dir || { echo "Failed to find the git root directory."; return 1; }

  branch=$1
  remote_branch=$(git ls-remote --heads origin $branch)

  if [ -z "$remote_branch" ]; then
    git worktree add --checkout ../$branch && cd ../$branch; 
  else
    git worktree add --track -b $branch ../$branch origin/$branch && cd ../$branch
    echo "Worktree created and branch name copied to clipboard."
  fi
}

function gwd() {
  current_worktree=$(git rev-parse --show-toplevel 2> /dev/null)
  current_branch=$(git branch --show-current)
  cd $current_worktree
  cd ../
  git worktree remove -f "$current_worktree"

  if git rev-parse --verify --quiet origin/develop; then
    cd develop
    git pull
    git branch -D $current_branch
  elif git show-ref --verify --quiet refs/heads/main; then
    cd main
    git pull
    git branch -D $current_branch
  elif git show-ref --verify --quiet refs/heads/master; then
    cd master
    git pull
    git branch -D $current_branch
  else
    echo "Neither 'main' nor 'master' branch found."
  fi
}

