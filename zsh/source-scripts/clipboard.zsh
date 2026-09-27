# Clipboard shims: make pbcopy/pbpaste work on Linux.
# Over SSH we use OSC 52 so text lands in the Mac's clipboard.
# Locally, fall back to wl-copy / xclip / xsel.

if [[ $OSTYPE == linux* ]] && (( ! $+commands[pbcopy] )); then
  pbcopy() {
    local data
    data=$(cat)
    if [[ -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]]; then
      local b64
      b64=$(printf '%s' "$data" | base64 | tr -d '\n')
      # Plain OSC 52 also works inside Zellij, which forwards it to the outer terminal
      printf '\e]52;c;%s\a' "$b64"
    elif command -v wl-copy &>/dev/null; then
      printf '%s' "$data" | wl-copy
    elif command -v xclip &>/dev/null; then
      printf '%s' "$data" | xclip -selection clipboard
    elif command -v xsel &>/dev/null; then
      printf '%s' "$data" | xsel --clipboard --input
    else
      printf '%s' "$data"
    fi
  }

  pbpaste() {
    if command -v wl-paste &>/dev/null; then
      wl-paste
    elif command -v xclip &>/dev/null; then
      xclip -selection clipboard -o
    elif command -v xsel &>/dev/null; then
      xsel --clipboard --output
    fi
  }
fi
