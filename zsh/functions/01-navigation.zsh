# Navigation functions

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
  [[ -d "$_MARKD_SAVED_DIR" ]] || { echo "Directory no longer exists: $_MARKD_SAVED_DIR"; return 1; }
  cd "$_MARKD_SAVED_DIR" || return 1
}

# Fuzzy-cd into a directory under $CODE_ROOT (4 levels deep: <group>/<repo>/wt/<branch>)
cdc() {
  local d
  d=$(fd -t d -d 4 . "${CODE_ROOT:-$HOME/code}" | fzf --height 40% --query "$*") && cd "$d"
}

# Fuzzy-cd into a zsh-z frecent directory
zf() {
  local d
  d=$(zshz -l 2>&1 | fzf --tac --height 40% --query "$*" | awk '{print $2}') && cd "${d/#\~/$HOME}"
}

# Rename the Zellij tab (default: current directory name)
tw() {
  zellij action rename-tab "${1:-${PWD:t}}"
}

# Jump to a project's Zellij session (fzf picker without an argument); see scripts/zellij-sessionizer
tj() {
  "${ZDOTDIR:h}/scripts/zellij-sessionizer" "$@"
}
