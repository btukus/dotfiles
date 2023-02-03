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
  ipconfig getifaddr en0 | pbcopy;
}
