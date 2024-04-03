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
    exit 1
  fi

  # local trimmed_url=$(trim_git_suffix "$repo_url")
  echo "Trimmed URL: $trimmed_url"
  local repo_name=$(basename "$trimmed_url")
  # echo "Repository name: $repo_name"

  echo "Creating bare repository for: $repo_url"
  git clone --bare "$repo_url" "${repo_name}"
  cd "${repo_name}"

  # Check for main or master branch
  if git rev-parse --verify --quiet main; then
      git worktree add --checkout main
      cd main
  elif git rev-parse --verify --quiet master; then
      git worktree add --checkout master
      cd master
  else
      echo "Neither main nor master branch found in $repo_dir, skipping."
  fi
}
