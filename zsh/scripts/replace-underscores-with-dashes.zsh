#!/bin/zsh

# Function to replace underscores with dashes in filenames
replace_underscores_with_dashes() {
  local dir=$1

  # Check if directory exists
  if [ ! -d "$dir" ]; then
    echo "Error: Directory '$dir' does not exist."
    return 1
  fi

  # Find all files and directories with underscores and loop through them
  find "$dir" -depth -name "*_*" | while read -r file; do
    # Define the new filename by replacing underscores with dashes
    new_file="${file//_/-}"
    
    # Rename the file or directory
    mv "$file" "$new_file"
    
    # Print the result
    echo "Renamed: $file -> $new_file"
  done
}

# Check if a directory argument was provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Call the function with the directory argument
replace_underscores_with_dashes "$1"
