# Deduplicate $path so re-sourcing this file (or re-execing zsh with our /opt
# entries already present) doesn't stack duplicates.
typeset -U path

# Entware (Synology / OpenWrt): expose /opt tools before system BusyBox equivalents.
[[ -d /opt/bin ]]  && path=(/opt/bin  $path)
[[ -d /opt/sbin ]] && path=(/opt/sbin $path)

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

# On SSH: attach to (or create) a single per-host tmux session so every new
# connection lands in the same place. `-A` = attach if exists, create otherwise.
# `exec` replaces the shell so `exit` from tmux closes the SSH connection.
if [ -n "$SSH_TTY" ] && [ -z "$TMUX" ] && [ -t 0 ] && command -v tmux &>/dev/null; then
  exec tmux new-session -A -s main
fi

path=($HOME/.local/bin $path)

# Android SDK (for local Expo/React Native builds)
export ANDROID_HOME="$HOME/Library/Android/sdk"
path=($path $ANDROID_HOME/platform-tools $ANDROID_HOME/emulator $ANDROID_HOME/cmdline-tools/latest/bin)
