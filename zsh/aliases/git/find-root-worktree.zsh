git_root_cd() {
  local dir
  dir=$(git rev-parse --show-toplevel 2> /dev/null)
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
