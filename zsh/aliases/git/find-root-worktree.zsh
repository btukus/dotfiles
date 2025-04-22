git_root_cd() {
  local dir
  dir=$(git rev-parse --show-toplevel 2>/dev/null)
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

gmd() {
  local current_location=$(git rev-parse --show-toplevel)
  echo "Current location: $current_location"
  cd ../ || return 1

  cd dev || cd develop || return 1
  git pull

  cd "$current_location" || return 1
  git merge dev || git merge develop
}

# gmm() {
#   local current_location=$(pwd)
#   ghdd

#   cd main || cd master || return 1
#   git pull

#   cd "$current_location" || return 1
#   git merge main || git merge master
# }