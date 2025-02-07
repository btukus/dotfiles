# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

eval $(/opt/homebrew/bin/brew shellenv)

export EDITOR=nvim
export VISUAL=nvim

export TERM=alacritty
export COLORTERM=truecolor
if [ -z "$TMUX" ]; then
 exec tmux new-session -A -s personal
fi
