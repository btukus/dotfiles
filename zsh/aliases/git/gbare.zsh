#!/bin/sh
#

trim_git_suffix() {
  local url="$1"
  [[ $url =~ \.git$ ]] && url=${url%\.git}
  echo $url
}

gbare() {
  local repo_url="$1"
  if [[ -z "$repo_url" ]]; then
    echo "Error: No repository URL provided."
    return 1
  fi

  local trimmed_url=$(trim_git_suffix "$repo_url")
  local repo_name=$(basename "$trimmed_url")

  git clone --bare "$repo_url" "${repo_name}"
  cd "${repo_name}" || return 1

  # Ensure the remote references are fetched
  git config --add remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  git fetch --all

  # Check for main or master branch
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

  # Check for develop branch
  if git rev-parse --verify --quiet origin/develop; then
    git worktree add --checkout develop origin/develop
    cd develop || return 1
    git checkout develop
    git push --set-upstream origin develop
    echo "Worktree created and checked out for develop branch."
  else
    echo "Develop branch not found, skipping."
  fi
}
