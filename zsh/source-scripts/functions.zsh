# Complex aliases converted to functions

# ============================================================
# Navigation
# ============================================================

# Go back N directories
b() {
  if [[ -z "$1" || ! "$1" =~ ^[0-9]+$ ]]; then
    echo "Usage: b <number>"
    return 1
  fi
  local cmd=""
  for i in $(seq "$1"); do
    cmd="${cmd}../"
  done
  cd "$cmd"
}

# Directory temp storage (save current dir, return with cdt)
markd() {
  _MARKD_SAVED_DIR=$(pwd)
  echo "Marked: $_MARKD_SAVED_DIR"
}

cdt() {
  if [[ -z "$_MARKD_SAVED_DIR" ]]; then
    echo "No directory marked. Use 'markd' first."
    return 1
  fi
  cd "$_MARKD_SAVED_DIR"
}

# ============================================================
# System utilities
# ============================================================

# Get IP address and copy to clipboard
myip() {
  local ip_addr
  if [ -z "$1" ]; then
    if command -v ipconfig &>/dev/null; then
      ip_addr=$(ipconfig getifaddr en0)
    else
      ip_addr=$(ifconfig en0 | grep "inet " | awk '{print $2}')
    fi
  else
    if command -v ipconfig &>/dev/null; then
      ip_addr=$(ipconfig getifaddr "en$1")
    else
      ip_addr=$(ifconfig "en$1" | grep "inet " | awk '{print $2}')
    fi
  fi
  if [[ -z "$ip_addr" ]]; then
    echo "Could not get IP address"
    return 1
  fi
  echo -n "$ip_addr" | pbcopy
  echo "Copied: $ip_addr"
}

# Copy file path to clipboard
cpp() {
  if [[ -z "$1" ]]; then
    echo "Usage: cpp <file>"
    return 1
  fi
  local file_path="$(realpath "$1")"
  if [[ ! -f "$file_path" ]]; then
    echo "File not found: $1"
    return 1
  fi
  if [[ "$(uname)" == "Darwin" ]]; then
    echo -n "$file_path" | pbcopy
  elif [[ "$(uname)" == "Linux" ]]; then
    echo -n "$file_path" | xclip -selection clipboard
  else
    echo "Unsupported OS"
    return 1
  fi
  echo "File path copied: $file_path"
}

# Show PATH entries
path() {
  echo "$PATH" | tr ':' '\n'
}

# List with grep
lg() {
  if [[ -z "$1" ]]; then
    echo "Usage: lg <pattern>"
    return 1
  fi
  eza -la --group-directories-first --git | grep "$1"
}

# File picker with fzf
ff() {
  local file
  file=$(fzf --preview "bat --style=grid --color=always {}")
  [[ -n "$file" ]] && nvim "$file"
}

# Copy utilities
treec() {
  tree | pbcopy
}

pwdc() {
  pwd | pbcopy
}

# Reload shell
reload() {
  source "$ZDOTDIR/.zshrc"
}

# ============================================================
# Proxy connections
# ============================================================

nsproxy() {
  SSHPASS="$CMC_PASSWORD" sshpass -e ssh -f -N -q ns-m-ssh001.tux.m.ns.lan
}

enproxy() {
  SSHPASS="$ENECO_PASSWORD" sshpass -e ssh -D 1080 -f -N -q eneco-m-ssh001.tux.m.eneco.lan
}

nscheck() {
  ps aux | grep "ssh -f -N -q ns-m-ssh001.tux.m.ns.lan"
}

# ============================================================
# Git functions
# ============================================================

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
  git fetch origin "$1"
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

  git pull
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
  gwag "$@"
  cursor --reuse-window .
}

# Delete worktree and cleanup
gwd() {
  local root_worktree current_branch repo_root branch_dir

  root_worktree=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -z "$root_worktree" ]]; then
    echo "Not in a git repository"
    return 1
  fi

  current_branch=$(git branch --show-current)
  repo_root=$(dirname "$root_worktree")

  # Move out of the worktree first
  cd "$repo_root" || return 1

  # Remove worktree, fallback to manual removal if needed
  if ! git worktree remove -f "$root_worktree" 2>/dev/null; then
    echo "git worktree remove failed, forcing directory removal..."
    rm -rf "$root_worktree"
    git worktree prune
  fi

  # Find a base branch to switch to
  for base_branch in dev develop main master; do
    branch_dir="$repo_root/$base_branch"
    if [[ -d "$branch_dir" ]]; then
      cd "$branch_dir" || continue
      git pull
      git branch -D "$current_branch" 2>/dev/null
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
  local current_location=$(git rev-parse --show-toplevel)
  echo "Current location: $current_location"
  cd ../ || return 1
  cd dev || cd develop || return 1
  git pull
  cd "$current_location" || return 1
  git merge dev || git merge develop
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
  git clone --bare "$repo_url" "${repo_name}"
  cd "${repo_name}" || return 1
  git config --add remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  git fetch --all
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

# ============================================================
# Kubernetes functions
# ============================================================

# Kubernetes busybox
busy() {
  kubectl apply -f "${HOME}/drive/mac/development/k8s_resources/busybox.yaml"
}

# Helm show values
hsv() {
  if [ -n "$2" ]; then
    helm show values "$1" > "$2"
  else
    helm show values "$1"
  fi
}

# k9s with context switching
ks() {
  if [ "$1" = "d" ]; then
    kubectl config use-context sensey-dev-aks && k9s
  elif [ "$1" = "p" ]; then
    kubectl config use-context sensey-prod-aks && k9s
  else
    k9s
  fi
}

ksns() {
  if [ "$1" = "t" ]; then
    kubectl config use-context AKS20AKSINFOPLUS300-T && k9s
  elif [ "$1" = "a" ]; then
    kubectl config use-context AKS20AKSINFOPLUS200-A && k9s
  elif [ "$1" = "p" ]; then
    kubectl config use-context AKS20AKSINFOPLUS200-P && k9s
  elif [ "$1" = "ht" ]; then
    kubectl config use-context AKS20REISINFO100-T && k9s
  elif [ "$1" = "ha" ]; then
    kubectl config use-context AKS20REISINFO100-A && k9s
  elif [ "$1" = "hp" ]; then
    kubectl config use-context AKS20REISINFO100-P && k9s
  else
    k9s
  fi
}

# ============================================================
# Azure functions
# ============================================================

akslogin() {
  az aks get-credentials --resource-group "$1" --name "$2"
}

kvs() {
  az keyvault secret set --vault-name "sensey-${1}-kv" --name "$2" --file "$3"
}

kvc() {
  az keyvault certificate import --vault-name "sensey-${1}-kv" --name "$2" --file "$3"
}

# ============================================================
# Docker functions
# ============================================================

# Docker exec into container
de() {
  if [[ -z "$1" ]]; then
    echo "Usage: de <container>"
    return 1
  fi
  docker exec -it "$1" /bin/bash || docker exec -it "$1" /bin/sh
}

# Get IP address of container
dip() {
  docker inspect "$1" | grep IPAddress
}

# Docker network inspect
dni() {
  docker network inspect "$1"
}

# Docker build and run
dbr() {
  app_name="$1"
  local_port="${2:-8080}"
  exposed_port="${3:-8080}"
  if [ -z "$app_name" ]; then
    echo "Error: app_name is required."
    echo "Usage: dbr <app_name> [local_port] [exposed_port]"
    return 1
  fi
  if docker ps -a --format '{{.Names}}' | grep -w "$app_name" >/dev/null 2>&1; then
    echo "Stopping and removing existing container: $app_name"
    docker stop "$app_name" >/dev/null 2>&1
    docker rm "$app_name" >/dev/null 2>&1
  fi
  echo "Building image $app_name:latest..."
  docker buildx build --load -t "${app_name}:latest" .
  echo "Running container $app_name on ${local_port}:${exposed_port}..."
  docker run -d --name "$app_name" -p "${local_port}:${exposed_port}" "${app_name}:latest"
}

# ============================================================
# Node/Development functions
# ============================================================

# npm install, copy env, and run dev
nid() {
  npm install
  cenv
  npm run dev
}

# Copy .env file from dev worktree
cenv() {
  local parent_dir=$(dirname "$(pwd)")
  local develop_dir="$parent_dir/dev"
  if [[ ! -d "$develop_dir" ]]; then
    echo "The directory $develop_dir does not exist."
    return 1
  fi
  for file in ".env" ".env.local"; do
    if [[ -f "$develop_dir/$file" ]]; then
      cp "$develop_dir/$file" "./$file"
      echo "Copied $file to the current directory."
      return 0
    fi
  done
  echo "No .env or .env.local file found in the develop directory."
  return 1
}

# JWT decoder
jwt() {
  node ~/dotfiles/scripts/check-jwt.js "$1"
}

# ============================================================
# Brew export
# ============================================================

brew-export-mac() {
  brew bundle dump --file=~/dotfiles/brew/Brewfile.macos --force
  sed -i "" "/^vscode/d" ~/dotfiles/brew/Brewfile.macos
}

brew-export-linux() {
  brew bundle dump --file=~/dotfiles/brew/Brewfile.linux --force
  sed -i "" "/^vscode/d" ~/dotfiles/brew/Brewfile.linux
}

