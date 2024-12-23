# Git
function gcp() { git add --all; git commit -m $1; git push; }

function gu() {
  source "$HOME/dotfiles/zsh/scripts/update-git-worktrees.zsh"
}

function gwa {
  git worktree add --checkout origin/$1 $1
  cd $1;
  git branch --set-upstream-to=origin/$1 $1
}
