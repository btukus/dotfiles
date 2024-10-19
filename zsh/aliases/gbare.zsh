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
  else
    local trimmed_url=$(trim_git_suffix "$repo_url")
    # echo "Trimmed URL: $trimmed_url"
    local repo_name=$(basename "$trimmed_url")
    # echo "Repository name: $repo_name"

    git clone --bare "$repo_url" "${repo_name}"
    cd "${repo_name}"

    # Check for main or master branch
    if git rev-parse --verify --quiet main; then
      git config --add remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
      git worktree add --checkout main
      cd main
      git push --set-upstream origin main
    elif git rev-parse --verify --quiet master; then
      git config --add remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
      git worktree add --checkout master
      cd master
      git push --set-upstream origin main
    else
      echo "Neither main nor master branch found in $repo_dir, skipping."
    fi

  fi

}
