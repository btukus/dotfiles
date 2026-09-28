# ~/.zshenv should only be a one-liner that sources this file
# echo ". ~/dotfiles/zsh/.zshenv" > ~/.zshenv

export ZDOTDIR=${ZDOTDIR:-~/dotfiles/zsh}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-~/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-~/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-~/.local/state}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-~/.xdg}

# Whether stdin is the terminal, recorded here because p10k's instant prompt points stdin at
# /dev/null while .zshrc loads, and zellij-autostart (which runs after it) still needs to know.
[[ -t 0 ]] && ZSH_STDIN_IS_TTY=1

# Don't let macOS Terminal write per-session history into $ZDOTDIR/.zsh_sessions
export SHELL_SESSIONS_DISABLE=1
# Ubuntu's /etc/zsh/zshrc runs compinit before ours; skip it (we run it once, cached)
skip_global_compinit=1

# Private overlay (~/dotfiles-private, cloned by the `private` Ansible role when you have access)
[[ -r ~/dotfiles-private/zsh/env.zsh ]] && . ~/dotfiles-private/zsh/env.zsh
