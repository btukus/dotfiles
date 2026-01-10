# Complex aliases converted to functions

# Proxy connections
nsproxy() {
  sshpass -p "$CMC_PASSWORD" ssh -f -N -q ns-m-ssh001.tux.m.ns.lan
}

enproxy() {
  sshpass -p "$ENECO_PASSWORD" ssh -D 1080 -f -N -q eneco-m-ssh001.tux.m.eneco.lan
}

nscheck() {
  ps aux | grep "ssh -f -N -q ns-m-ssh001.tux.m.ns.lan"
}

# Kubernetes busybox
busy() {
  kubectl apply -f "${HOME}/drive/mac/development/k8s_resources/busybox.yaml"
}

# Directory temp storage
GD() {
  temp=$(pwd)
}

cdt() {
  cd "$temp"
}

# File picker with fzf
ff() {
  local file
  file=$(fzf --preview "bat --style=grid --color=always {}")
  [[ -n "$file" ]] && nvim "$file"
}

# List with grep
lg() {
  eza -la --group-directories-first --git | grep "$1"
}

# Show PATH entries
path() {
  echo "$PATH" | tr ':' '\n'
}

# Brew export
brew-export-mac() {
  brew bundle dump --file=~/dotfiles/brew/Brewfile.macos --force
  sed -i "" "/^vscode/d" ~/dotfiles/brew/Brewfile.macos
}

brew-export-linux() {
  brew bundle dump --file=~/dotfiles/brew/Brewfile.linux --force
  sed -i "" "/^vscode/d" ~/dotfiles/brew/Brewfile.linux
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

# Reload shell
su() {
  source "$ZDOTDIR/.zshrc"
}

# Copy utilities
treec() {
  tree | pbcopy
}

pwdc() {
  pwd | pbcopy
}

# Simple aliases that should stay as aliases (not abbreviations)
alias vim='vim -u ~/.config/vim/vimrc'
alias fs='nvim --startuptime /tmp/nvim-startuptime'
