alias gg='lazygit'

# Git worktree
alias gwa='git worktree add --checkout'                                   # Track remote worktree
alias gwab='git worktree add --checkout -b'                               # Create new local worktree
alias gwr='git worktree remove -f'                                        # Remove worktree

# alias gcbr=
# Git aliases

# Git add aliases
alias ga='git add'                                                        # Git stage files
alias gaa='git add --all'                                                 # Stage all files in the repository

# Git branch
alias gb='git branch'                                                     # Show local branches
alias gbr='git branch -r'                                                  # Show remote branches
alias gbd='git branch -d'
alias gbD='git branch -D'

# Git checkout 
alias gc='git checkout'                                                # Remove changes
alias gcb='git checkout -b'

# Git commit
alias gcm='git commit -m'
alias gcam='git commit -a -m'

# Git clone 
alias gcr='git clone'

# Git fetch
alias gf='git fetch' 

# Git diff
alias gd='git diff'

# Git merge
alias gm='git merge'
alias gmm='git merge origin/$(git_main_branch)'
alias gmom='git merge origin/$(git_develop_branch)'
alias gma='git merge --abort'

# Git rebase
alias grb='git rebase'
alias grbm='git rebase $(git_main_branch)'
alias grbom='git rebase origin/$(git_main_branch)'

# Git pull and push
alias gl='git pull'
alias gp='git push'

# Git reset 
alias grh='git reset'
alias grhh='git reset --hard'

# Git status
alias gs='git status'
alias grm='git rm'

# Git stash
alias gS='git stash'

alias gg='lazygit'
alias gref='git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*" && git fetch'
alias grefg='git config --global remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*" && git fetch'
alias grv='git remote -v'
alias grs='git remote set-url origin'

# Git
function gcp() { git add --all; git commit -m $1; git push; }

function gwam() {
  if [ -z "$1" ]; then
    git worktree add --checkout main
  else
    git worktree add --checkout $1
  fi
}

function gwag() {
  if [ -z "$1" ]; then
    echo "Please provide a branch name."
    return 1
  fi

  root_dir=$(git rev-parse --show-toplevel 2> /dev/null)
  cd $root_dir || { echo "Failed to find the git root directory."; return 1; }

  branch=$1
  remote_branch=$(git ls-remote --heads origin $branch)

  if [ -z "$remote_branch" ]; then
    git worktree add --checkout ../$branch && cd ../$branch; 
    echo "here"
  else
    git worktree add --track -b $branch ../$branch origin/$branch && cd ../$branch
    echo "Worktree created and branch name copied to clipboard."
  fi
}

function gwage() {
  gwag $1
  code .
}

function gwd() {
  current_worktree=$(git rev-parse --show-toplevel 2> /dev/null)
  current_branch=$(git branch --show-current)
  cd $current_worktree
  cd ../
  git worktree remove -f "$current_worktree"

  if git show-ref --verify --quiet refs/heads/main; then
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

function gu() {
  source "$HOME/dotfiles/zsh/scripts/update-git-worktrees.zsh"
}

git_root_cd() {
  local dir
  dir=$(git rev-parse --show-toplevel 2> /dev/null)
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
