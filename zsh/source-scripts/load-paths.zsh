# Homebrew environment (cached for performance)
BREW_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/brew-shellenv"
if [[ -f "$BREW_CACHE" ]]; then
  source "$BREW_CACHE"
else
  for _brew_bin in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$_brew_bin" ]]; then
      mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}"
      "$_brew_bin" shellenv > "$BREW_CACHE"
      source "$BREW_CACHE"
      break
    fi
  done
  unset _brew_bin
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

export PATH="$HOME/.asdf/installs/nodejs/24.0.2/bin:$PATH"
