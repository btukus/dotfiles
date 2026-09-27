# Start Zellij first (Ghostty, SSH): must run before instant prompt, which redirects stdin (see the file)
[[ -o interactive ]] && source "$ZDOTDIR/source-scripts/zellij-autostart.zsh"

# Enable Powerlevel10k instant prompt. Keep close to the top of .zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zmodload zsh/zprof

# Load environment variables (API keys, etc.) from .env, auto-exporting them
[[ -f "$ZDOTDIR/.env" ]] && () { setopt localoptions allexport; source "$ZDOTDIR/.env" }

source "$ZDOTDIR/source-scripts/load-paths.zsh"

source "$ZDOTDIR/source-scripts/load-options.zsh"

source "$ZDOTDIR/source-scripts/load-history-settings.zsh"

source "$ZDOTDIR/source-scripts/plugin-settings.zsh"

# plugin completion dirs -> compinit (load-completions.zsh) -> plugins
source "$ZDOTDIR/source-scripts/antidote.zsh"

source "$ZDOTDIR/source-scripts/keybindings.zsh"

source "$ZDOTDIR/source-scripts/clipboard.zsh"

source "$ZDOTDIR/source-scripts/functions.zsh"

source "$ZDOTDIR/source-scripts/load-aliases.zsh"

source "$ZDOTDIR/source-scripts/load-ssh-keys.zsh"

source "$ZDOTDIR/source-scripts/asdf.zsh"

source "$ZDOTDIR/.p10k.zsh"

# zprof

# Private overlay: work functions, abbreviations, hosts
for f in ~/dotfiles-private/zsh/*.zsh(N); do [[ ${f:t} == env.zsh ]] || source $f; done
