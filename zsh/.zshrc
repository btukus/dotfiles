# Powerlevel10k instant prompt. Must be the first thing that runs: until it takes the terminal,
# anything you type is echoed raw by the tty and then left behind as a stale line when the real
# prompt draws. It renders ~25ms in, so keep everything else below it - including Zellij, whose
# `attach` would otherwise hold that window open for its whole startup.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Start Zellij in place of this shell (Ghostty, SSH)
[[ -o interactive ]] && source "$ZDOTDIR/source-scripts/zellij-autostart.zsh"

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

# zsh-abbr cache (see plugin-settings.zsh). Last, so the private overlay's session
# abbreviations are part of the snapshot instead of being re-declared in every shell.
() {
  (( $+functions[abbr] )) || return
  local -a sets=(
    ABBR_REGULAR_USER_ABBREVIATIONS ABBR_GLOBAL_USER_ABBREVIATIONS
    ABBR_REGULAR_SESSION_ABBREVIATIONS ABBR_GLOBAL_SESSION_ABBREVIATIONS
  )
  if (( ABBR_CACHE_HIT )); then
    source $ABBR_CACHE
    ABBR_USER_ABBREVIATIONS_FILE=$ABBR_USER_ABBREVIATIONS_FILE_REAL
    # The expansion widget re-reads these dumps on every expansion, and the decoy load just
    # wrote them empty. Always rewrite them: they are shared between sessions, so leaving them
    # empty silently stops abbreviations expanding everywhere, not just in this shell.
    typeset -p ABBR_REGULAR_USER_ABBREVIATIONS >${_abbr_tmpdir}regular-user-abbreviations
    typeset -p ABBR_GLOBAL_USER_ABBREVIATIONS  >${_abbr_tmpdir}global-user-abbreviations
  else
    typeset -p $sets >$ABBR_CACHE.$$ 2>/dev/null && mv -f $ABBR_CACHE.$$ $ABBR_CACHE
  fi
}
