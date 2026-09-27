# Deduplicate $path so re-sourcing this file (or re-execing zsh with our /opt
# entries already present) doesn't stack duplicates.
typeset -U path

# Entware (Synology / OpenWrt): expose /opt tools before system BusyBox equivalents.
[[ -d /opt/bin ]]  && path=(/opt/bin  $path)
[[ -d /opt/sbin ]] && path=(/opt/sbin $path)

# Homebrew environment (cached for performance)
BREW_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/brew-shellenv"
# Regenerate when brew itself is newer than the cache (brew upgrade changes shellenv)
if [[ -f "$BREW_CACHE" && ! /opt/homebrew/bin/brew -nt "$BREW_CACHE" && ! /home/linuxbrew/.linuxbrew/bin/brew -nt "$BREW_CACHE" ]]; then
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

# All code lives here (used by scripts/repos, cdc)
export CODE_ROOT=$HOME/code

export EDITOR=nvim
export VISUAL=nvim

export COLORTERM=truecolor

path=($HOME/.local/bin $path)

# Android SDK (for local Expo/React Native builds)
export ANDROID_HOME="$HOME/Library/Android/sdk"
[[ -d $ANDROID_HOME ]] && path+=($ANDROID_HOME/{platform-tools,emulator,cmdline-tools/latest/bin})
