eval $(/opt/homebrew/bin/brew shellenv)

export EDITOR=nvim
export VISUAL=nvim

export COLORTERM=truecolor

if [ "$TERM_PROGRAM" = "Alacritty" ] || [ "$TERM" = "alacritty" ]; then
  export TERM=alacritty

  if [ -z "$TMUX" ]; then
    exec tmux new-session -A -s sensey
  fi
fi

export PATH="$HOME/.local/bin:$PATH"
