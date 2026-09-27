# Start Zellij in place of the login shell:
#   Ghostty window -> session $ZELLIJ_MAIN_SESSION (default "main");  SSH login -> session "main"
#
# Sourced first in .zshrc, before p10k's instant prompt: instant prompt points stdin at
# /dev/null while the rest of .zshrc loads, so a later `-t 0` check fails and Zellij silently
# doesn't start. PATH may not be set up yet either, so look for the binary in the usual places.
# Detaching or quitting Zellij closes the window / SSH connection; if Zellij fails, or isn't
# installed on this host, you keep a plain shell.
if [[ -z $ZELLIJ && -t 0 ]] && [[ $TERM_PROGRAM == ghostty || -n $SSH_TTY ]]; then
  () {
    local session=$1 zellij_bin
    for zellij_bin in $commands[zellij] $HOME/.local/bin/zellij /opt/homebrew/bin/zellij /home/linuxbrew/.linuxbrew/bin/zellij /usr/local/bin/zellij /usr/bin/zellij; do
      [[ -x $zellij_bin ]] && break
    done
    [[ -x $zellij_bin ]] || return 0
    $zellij_bin attach --create $session && exit
    print -P "%F{yellow}zellij exited with status $?; staying in a plain shell. Retry with: zellij attach -c $session%f"
  } ${${SSH_TTY:+main}:-${ZELLIJ_MAIN_SESSION:-main}}
fi

# Inside Zellij: name the tab like tmux's automatic-rename - the running command, or the
# folder at the prompt. Only the tab's focused pane renames it; runs in the background so the
# prompt never waits on zellij.
if [[ -n $ZELLIJ && -n $ZELLIJ_PANE_ID ]] && (( $+commands[jq] )); then
  _zellij_tab_title() {
    local name=$1
    {
      local tab=$(zellij action list-panes --tab --state --json 2>/dev/null |
        jq -r --argjson id $ZELLIJ_PANE_ID \
          '.[] | select(.is_plugin == false and .id == $id and .is_focused and (.is_floating | not)) | .tab_id')
      [[ -n $tab ]] && zellij action rename-tab-by-id $tab $name
    } &>/dev/null &!
  }
  _zellij_tab_title_precmd()  { _zellij_tab_title ${${PWD/#$HOME/\~}:t} }
  _zellij_tab_title_preexec() { local cmd=${${(z)1}[1]}; _zellij_tab_title ${cmd:t} }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _zellij_tab_title_precmd
  add-zsh-hook preexec _zellij_tab_title_preexec
fi
