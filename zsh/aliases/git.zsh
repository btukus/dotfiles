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
