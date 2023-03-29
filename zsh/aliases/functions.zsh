#!/bin/sh

b () {
  cmd="" 
  for i in $(seq $1); do
    cmd="${cmd}../" 
  done
  
  cd $cmd;
}

ip () {
  if [[ -z "$1" ]] then
    ipconfig getifaddr en0 | pbcopy;
  else
    ipconfig getifaddr "en$1" | pbcopy;
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
