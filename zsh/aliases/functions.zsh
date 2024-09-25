#!/bin/bash

b() {
  cmd=""
  for i in $(seq $1); do
    cmd="${cmd}../"
  done

  cd $cmd
}

ip() {
  if [ -z "$1" ]; then
    if command -v ipconfig &>/dev/null; then
      ipconfig getifaddr en0 | pbcopy
    else
      ifconfig en0 | grep "inet " | awk '{print $2}' | pbcopy
    fi
  else
    if command -v ipconfig &>/dev/null; then
      ipconfig getifaddr "en$1" | pbcopy
    else
      ifconfig "en$1" | grep "inet " | awk '{print $2}' | pbcopy
    fi
  fi
}

cpp() {
    if [[ -z "$1" ]]; then
        echo "Usage: cpp <file>"
        return 1
    fi

    # Get the absolute path of the file
    local file_path="$(realpath "$1")"

    if [[ ! -f "$file_path" ]]; then
        echo "File not found: $1"
        return 1
    fi

    # Copy to clipboard based on OS
    if [[ "$(uname)" == "Darwin" ]]; then
        echo -n "$file_path" | pbcopy   # macOS
    elif [[ "$(uname)" == "Linux" ]]; then
        echo -n "$file_path" | xclip -selection clipboard   # Linux
    else
        echo "Unsupported OS"
        return 1
    fi

    echo "File path copied: $file_path"
}
