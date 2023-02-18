#!/bin/sh

b () {
  cmd="" 
  for i in $(seq $1); do
    cmd="${cmd}../" 
  done
  
  cd $cmd;
}

zns () {
    
  z conn;
  ns;

}

ip () {
  if [[ -z "$1" ]] then
    ipconfig getifaddr en0 | pbcopy;
  else
    ipconfig getifaddr "en$1" | pbcopy;
  fi

}
