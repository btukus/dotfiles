# Source all .zsh files in aliases directory (using zsh globbing for performance)
local directory="${1:-$ZDOTDIR/aliases}"
if [[ -d "$directory" ]]; then
  for file in "$directory"/**/*.zsh(N); do
    source "$file"
  done
else
  echo "Directory $directory does not exist."
fi
