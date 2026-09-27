#!/bin/zsh

# Function to replace .yml with .yaml
replace_yml_with_yaml() {
  local dir=$1

  # Check if directory exists
  if [ ! -d "$dir" ]; then
    echo "Error: Directory '$dir' does not exist."
    return 1
  fi

  # Find all .yml files and loop through them
  find "$dir" -type f -name "*.yml" | while read -r file; do
    # Define the new filename by replacing .yml with .yaml
    new_file="${file%.yml}.yaml"
    
    # Rename the file
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
replace_yml_with_yaml "$1"
