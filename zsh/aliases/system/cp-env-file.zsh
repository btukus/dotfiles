cenv() {
  local parent_dir=$(dirname "$(pwd)")
  local develop_dir="$parent_dir/dev"

  # Check if develop directory exists
  if [[ ! -d "$develop_dir" ]]; then
    echo "The directory $develop_dir does not exist."
    return 1
  fi

  # Copy the first available .env file
  for file in ".env" ".env.local"; do
    if [[ -f "$develop_dir/$file" ]]; then
      cp "$develop_dir/$file" "./$file"
      echo "Copied $file to the current directory."
      return 0
    fi
  done

  echo "No .env or .env.local file found in the develop directory."
  return 1
}
