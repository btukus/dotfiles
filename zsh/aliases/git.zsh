function current_branch() {
  branch=$( git branch | grep \* | awk '{print $2}' )
  echo $branch;
}

function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return
    fi
  done
  echo master
}

# Check for develop and similarly named branches
function git_develop_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local branch
  for branch in dev devel development; do
    if command git show-ref -q --verify refs/heads/$branch; then
      echo $branch
      return
    fi
  done
  echo develop
}

function gcp() {
  git add --all;
  git commit -m $1;
  git push;
}

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
alias gbare='git clone --bare'

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
alias gpu='git push --set-upstream origin "$(current_branch)"'

# Git reset 
alias grh='git reset'
alias grhh='git reset --hard'

# Git status
alias gs='git status'
alias grm='git rm'

# Git stash
alias gS='git stash'

alias gg='lazygit'
