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
