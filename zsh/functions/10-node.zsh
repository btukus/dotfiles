# Node/Development functions

# Copy .env file from dev worktree
cenv() {
  local parent_dir=$(dirname "$(pwd)")
  local develop_dir="$parent_dir/dev"
  if [[ ! -d "$develop_dir" ]]; then
    echo "The directory $develop_dir does not exist."
    return 1
  fi
  for file in ".env" ".env.local"; do
    if [[ -f "$develop_dir/$file" ]]; then
      cp "$develop_dir/$file" "./$file" || { echo "Failed to copy env file"; return 1; }
      echo "Copied $file to the current directory."
      return 0
    fi
  done
  echo "No .env or .env.local file found in the develop directory."
  return 1
}

# npm install, copy env, and run dev
nid() {
  npm install || { echo "npm install failed"; return 1; }
  cenv || return 1
  npm run dev
}

# JWT decoder
jwt() {
  [[ -z "$1" ]] && { echo "Usage: jwt <token>"; return 1; }
  local jwt_script="$HOME/dotfiles/scripts/check-jwt.js"
  if [[ ! -f "$jwt_script" ]]; then
    echo "Helper script not found: $jwt_script"
    return 1
  fi
  node "$jwt_script" "$1"
}
