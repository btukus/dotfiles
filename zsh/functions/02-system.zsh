# System utility functions

# Copy stdin to the system clipboard (macOS pbcopy / Linux xclip).
# Returns 1 with a clear message if no clipboard utility is available.
_clip() {
  if command -v pbcopy >/dev/null 2>&1; then
    pbcopy
  elif command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard
  else
    echo "No clipboard utility available (need pbcopy or xclip)" >&2
    return 1
  fi
}

# Get IP address and copy to clipboard
myip() {
  local ip_addr
  if [ -z "$1" ]; then
    if command -v ipconfig &>/dev/null; then
      ip_addr=$(ipconfig getifaddr en0)
    else
      ip_addr=$(ifconfig en0 | grep "inet " | awk '{print $2}')
    fi
  else
    if command -v ipconfig &>/dev/null; then
      ip_addr=$(ipconfig getifaddr "en$1")
    else
      ip_addr=$(ifconfig "en$1" | grep "inet " | awk '{print $2}')
    fi
  fi
  if [[ -z "$ip_addr" ]]; then
    echo "Could not get IP address"
    return 1
  fi
  echo -n "$ip_addr" | _clip || { echo "clipboard copy failed"; return 1; }
  echo "Copied: $ip_addr"
}

# Copy file path to clipboard
cpp() {
  if [[ -z "$1" ]]; then
    echo "Usage: cpp <file>"
    return 1
  fi
  local file_path="$(realpath "$1")"
  if [[ ! -f "$file_path" ]]; then
    echo "File not found: $1"
    return 1
  fi
  echo -n "$file_path" | _clip || { echo "clipboard copy failed"; return 1; }
  echo "File path copied: $file_path"
}

# Show PATH entries
path() {
  echo "$PATH" | tr ':' '\n'
}

# List with grep
lg() {
  if [[ -z "$1" ]]; then
    echo "Usage: lg <pattern>"
    return 1
  fi
  eza -la --group-directories-first --git | grep "$1"
}

# File picker with fzf
ff() {
  local file
  file=$(fzf --preview "bat --style=grid --color=always {}")
  [[ -n "$file" ]] && nvim "$file"
}

# Copy utilities
treec() {
  tree | _clip || { echo "clipboard copy failed"; return 1; }
}

pwdc() {
  pwd | _clip || { echo "clipboard copy failed"; return 1; }
}

# Reload shell
reload() {
  source "${ZDOTDIR:-$HOME/dotfiles/zsh}/.zshrc"
}
