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

source "$ZDOTDIR/source-scripts/private-overlay.zsh"

# Startup profiling (see .zshenv): log when .zshrc finished and when the first prompt was
# actually ready, which is what you feel when a pane opens.
if (( ${ZSH_PROFILE_T0:-0} )); then
  typeset -gF ZSH_PROFILE_RC=$(( (EPOCHREALTIME - ZSH_PROFILE_T0) * 1000 ))
  # Time each precmd hook, so a slow first prompt can be attributed to one of them
  typeset -gA ZSH_PROFILE_HOOKS=()
  () {
    local f
    for f in $precmd_functions; do
      (( $+functions[$f] )) || continue
      functions -c $f _zsh_prof__$f
      functions[$f]="
        local __s=\$EPOCHREALTIME
        _zsh_prof__$f \"\$@\"
        ZSH_PROFILE_HOOKS[$f]=\$(( \${ZSH_PROFILE_HOOKS[$f]:-0} + (EPOCHREALTIME - __s) * 1000 ))"
    done
  }
  _zsh_profile_done() {
    printf '%s  zshrc=%6.1fms  prompt=%6.1fms  instant=%-3s pane=%-3s %s\n' \
      "$(strftime '%H:%M:%S' $EPOCHSECONDS)" $ZSH_PROFILE_RC \
      $(( (EPOCHREALTIME - ZSH_PROFILE_T0) * 1000 )) "$ZSH_PROFILE_IP" "${ZELLIJ_PANE_ID:--}" "$PWD" \
      >>${XDG_CACHE_HOME:-$HOME/.cache}/zsh/startup.log
    # slowest hooks first, anything over 1ms
    local k out=
    for k in ${(k)ZSH_PROFILE_HOOKS}; do
      (( ZSH_PROFILE_HOOKS[$k] > 1 )) && out+=$(printf '%s=%.0fms ' ${k#_zsh_prof__} $ZSH_PROFILE_HOOKS[$k])
    done
    [[ -n $out ]] && print -r -- "            hooks: $out" >>${XDG_CACHE_HOME:-$HOME/.cache}/zsh/startup.log
    # Deep profile: what actually burned the time, inside p10k and everywhere else
    if (( $+builtins[zprof] )); then
      {
        print -r -- "            --- zprof (self time, top 12) ---"
        zprof | sed -n '3,16p' | sed 's/^/            /'
      } >>${XDG_CACHE_HOME:-$HOME/.cache}/zsh/startup.log 2>/dev/null
    fi
    add-zsh-hook -d precmd _zsh_profile_done
    unfunction _zsh_profile_done
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _zsh_profile_done
fi
