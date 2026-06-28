# Package management / Brew export functions

brew-export-mac() {
  brew bundle dump --file=~/dotfiles/brew/Brewfile.macos --force || return 1
  sed -i "" "/^vscode/d" ~/dotfiles/brew/Brewfile.macos || return 1
}

brew-export-linux() {
  brew bundle dump --file=~/dotfiles/brew/Brewfile.linux --force || return 1
  sed -i "/^vscode/d" ~/dotfiles/brew/Brewfile.linux || return 1
}
