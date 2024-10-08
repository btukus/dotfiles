# ~/.zshenv should only be a one-liner that sources this file
# echo ". ~/dotfiles/zsh/.zshenv" > ~/.zshenv

export ZDOTDIR=${ZDOTDIR:-~/dotfiles/zsh}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-~/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-~/.local/share}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-~/.xdg}
