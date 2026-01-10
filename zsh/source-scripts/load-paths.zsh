eval $(/opt/homebrew/bin/brew shellenv)

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
