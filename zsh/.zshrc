# Enable Powerlevel10k instant prompt. Keep close to the top of .zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zmodload zsh/zprof

# Load environment variables (API keys, etc.) from .env, auto-exporting them
[[ -f "$ZDOTDIR/.env" ]] && set -a && source "$ZDOTDIR/.env" && set +a

source "$ZDOTDIR/source-scripts/load-paths.zsh"

source "$ZDOTDIR/source-scripts/load-completions.zsh"

source "$ZDOTDIR/source-scripts/load-history-settings.zsh"

source "$ZDOTDIR/source-scripts/antidote.zsh"

source "$ZDOTDIR/source-scripts/clipboard.zsh"

source "$ZDOTDIR/source-scripts/functions.zsh"

source "$ZDOTDIR/source-scripts/load-aliases.zsh"

source "$ZDOTDIR/source-scripts/load-ssh-keys.zsh"

source "$ZDOTDIR/source-scripts/asdf.zsh"

source "$ZDOTDIR/.p10k.zsh"

# zprof
