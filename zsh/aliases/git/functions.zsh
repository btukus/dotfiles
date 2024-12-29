# Git
function gcp() { git add --all; git commit -m $1; git push; }

function gu() {
  source "$HOME/dotfiles/zsh/scripts/update-git-worktrees.zsh"
}

function gwa {
  git fetch origin $1 # Fetch the branch from the remote
  git worktree add $1 $1 || git worktree add $1 -b $1 origin/$1
  cd $1
  git branch --set-upstream-to=origin/$1 $1
}
