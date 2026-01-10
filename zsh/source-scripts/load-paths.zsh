# Homebrew environment (cached for performance)
BREW_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/brew-shellenv"
if [[ -f "$BREW_CACHE" ]]; then
  source "$BREW_CACHE"
elif [[ -f /opt/homebrew/bin/brew ]]; then
  mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}"
  /opt/homebrew/bin/brew shellenv > "$BREW_CACHE"
  source "$BREW_CACHE"
elif [[ -f /usr/local/bin/brew ]]; then
  mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}"
  /usr/local/bin/brew shellenv > "$BREW_CACHE"
  source "$BREW_CACHE"
fi

export EDITOR=nvim
export VISUAL=nvim

export COLORTERM=truecolor

if [ "$TERM_PROGRAM" = "Alacritty" ] || [ "$TERM" = "alacritty" ]; then
  export TERM=xterm-256color

  if [ -z "$TMUX" ] && [ -t 0 ] && command -v tmux &>/dev/null; then
    tmux new-session -A -s sensey && exit
  fi
fi

export PATH="$HOME/.local/bin:$PATH"
