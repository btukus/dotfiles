# Start tmux in place of the login shell:
#   Ghostty window -> session $TMUX_MAIN_SESSION (default "main");  SSH login -> session "main"
#
# Sourced right after p10k's instant prompt, so the prompt is already on screen (and the tty
# quiet) while tmux starts. Instant prompt points stdin at /dev/null for the rest of .zshrc,
# and stdout/stderr at a capture file, so this can't test `-t 0` itself (.zshenv recorded it)
# and has to hand tmux the terminal explicitly on all three.
# PATH isn't set up yet either, so look for the binary in the usual places.
# Detaching closes the window / SSH connection; if tmux fails, or isn't installed on this host,
# you keep a plain shell.
if [[ -z $TMUX && -n $ZSH_STDIN_IS_TTY && -n $TTY ]] && [[ $TERM_PROGRAM == ghostty || -n $SSH_TTY ]]; then
  () {
    local session=$1 tmux_bin
    local -a args
    for tmux_bin in $commands[tmux] $HOME/.local/bin/tmux /opt/homebrew/bin/tmux /home/linuxbrew/.linuxbrew/bin/tmux /opt/bin/tmux /usr/local/bin/tmux /usr/bin/tmux; do
      [[ -x $tmux_bin ]] && break
    done
    [[ -x $tmux_bin ]] || return 0
    # The server and every pane it starts inherit this environment, and popups and run-shell
    # don't read .zshrc, so give it the full PATH now rather than the bare login one.
    source $ZDOTDIR/source-scripts/load-paths.zsh
    # tmux clients on one session share the current tab, so a second window gets its own view
    # of the same tabs (a grouped session) that goes away with the window.
    if [[ -n $($tmux_bin list-clients -t "=$session" 2>/dev/null) ]]; then
      args=(new-session -t "=$session" \; set-option destroy-unattached on)
    else
      args=(new-session -A -s $session)
    fi
    # The terminal by its real name ($TTY, e.g. /dev/ttys003), as tmux refuses a bare /dev/tty.
    # stdin read-write (<>): the server draws through the client's stdin, so with a read-only
    # one it takes your keys but never shows anything.
    $tmux_bin $args <>$TTY >$TTY 2>&1 && exit
    print -P "%F{yellow}tmux exited with status $?; staying in a plain shell. Retry with: tmux new -A -s $session%f"
  } ${${SSH_TTY:+main}:-${TMUX_MAIN_SESSION:-main}}
fi
