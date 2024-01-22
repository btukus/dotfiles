#!/bin/sh

b () {
  cmd="" 
  for i in $(seq $1); do
    cmd="${cmd}../" 
  done
  
  cd $cmd;
}

ip () {
  if [ -z "$1" ]; then
    if command -v ipconfig &> /dev/null; then
      ipconfig getifaddr en0 | pbcopy;
    else
      ifconfig en0 | grep "inet " | awk '{print $2}' | pbcopy;
    fi
  else
    if command -v ipconfig &> /dev/null; then
      ipconfig getifaddr "en$1" | pbcopy;
    else
      ifconfig "en$1" | grep "inet " | awk '{print $2}' | pbcopy;
    fi
  fi
}

# Git
function gcp() { git add --all; git commit -m $1; git push; }
function gwag() { 
  git worktree add --checkout ../$1 && cd ../$1; 
  echo $1 | pbcopy;
}

function gu() {
  source "$HOME/dotfiles/zsh/scripts/update_git_worktrees.zsh"
}

pat() {
  # Extract the original URL and the value for the switch
  local original_url="$1"
  local switch_value="$2"
  local new_username="${3:-btukus}"  # Default to "btukus" if no input is provided

  # Determine new_text based on the switch_value
  local new_text=""
  case "$switch_value" in
    1)
      new_text="${ENECO_1:-default_value}"  # Use the value of KEY or "default_value" if KEY is not set
      ;;
    2)
      new_text="${ENECO_2:-default_value}"
      ;;
    *)
      echo "Invalid switch value. Please provide 1 or 2."
      return 1
      ;;
  esac

  # Replace the username in the URL
  local modified_url=$(echo "$original_url" | awk -v user="$new_username" -v text="$new_text" -F'//' 'BEGIN{OFS="//"} {split($2,a,"@"); split(a[1],b,":"); sub(b[1],user":"text,a[1]); print $1, a[1]"@"a[2]}')

  # Output the modified URL
  echo "$modified_url" | pbcopy
}
