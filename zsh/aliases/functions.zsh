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

function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return
    fi
  done
  echo master
}

# Check for develop and similarly named branches
function git_develop_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local branch
  for branch in dev devel development; do
    if command git show-ref -q --verify refs/heads/$branch; then
      echo $branch
      return
    fi
  done
  echo develop
}

pat() {
  # Extract the original URL and new username and text
  local original_url="$1"
  local new_text="$2"
  local new_username="${3:-btukus}"  # Default to "btukus" if no input is provided

  # Replace the username in the URL
  local modified_url=$(echo "$original_url" | awk -v user="$new_username" -v text="$new_text" -F'//' 'BEGIN{OFS="//"} {split($2,a,"@"); split(a[1],b,":"); sub(b[1],user":"text,a[1]); print $1, a[1]"@"a[2]}')

  # Output the modified URL
  echo "$modified_url" | pbcopy
}
