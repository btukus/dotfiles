# Function to recursively source all .zsh files in a directory
local directory="${1:-$ZDOTDIR/aliases}"
if [[ -d "$directory" ]]; then
  find "$directory" -type f -name "*.zsh" | while IFS= read -r file; do
    source "$file"
  done
else
  echo "Directory $directory does not exist."
fi
