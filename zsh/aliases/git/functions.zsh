# Git
function gcp() { git add --all; git commit -m $1; git push; }

function gu() {
  source "$HOME/dotfiles/zsh/scripts/update-git-worktrees.zsh"
}
