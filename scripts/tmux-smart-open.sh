#!/usr/bin/env bash
#
# Split / new-window that inherits the current pane's SSH session.
#
# If the pane's foreground command is `ssh`, extract the exact ssh command line
# from that process and reuse it in the new pane/window. Otherwise fall back to
# inheriting the pane's cwd (matches the default -c "#{pane_current_path}"
# behaviour we already use).
#
# Wired up from tmux.conf:
#   bind M-k run-shell '~/dotfiles/scripts/tmux-smart-open.sh split-h'
#   bind M-j run-shell '~/dotfiles/scripts/tmux-smart-open.sh split-v'
#   bind c   run-shell '~/dotfiles/scripts/tmux-smart-open.sh window'
#
# Portable across BSD (macOS) and GNU (Linux) — uses only `ps -o args=` and
# `pgrep -P`, which behave the same on both.

set -eu

mode=${1:?usage: $0 split-h|split-v|window}

pane_pid=$(tmux display-message -p '#{pane_pid}')
pane_cmd=$(tmux display-message -p '#{pane_current_command}')
pane_path=$(tmux display-message -p '#{pane_current_path}')

# If the foreground process is ssh, grab its full argv so the new pane opens
# the exact same connection (same host, same -L/-R/-J flags, same user).
inherit=""
if [ "$pane_cmd" = "ssh" ]; then
    ssh_pid=$(pgrep -P "$pane_pid" -x ssh 2>/dev/null | head -n1 || true)
    if [ -n "$ssh_pid" ]; then
        inherit=$(ps -o args= -p "$ssh_pid" 2>/dev/null | sed 's/^ *//')
    fi
fi

case "$mode" in
    split-h)
        if [ -n "$inherit" ]; then tmux split-window -h "$inherit"
        else                       tmux split-window -h -c "$pane_path"
        fi ;;
    split-v)
        if [ -n "$inherit" ]; then tmux split-window -v "$inherit"
        else                       tmux split-window -v -c "$pane_path"
        fi ;;
    window)
        if [ -n "$inherit" ]; then tmux new-window "$inherit"
        else                       tmux new-window -c "$pane_path"
        fi ;;
    *)
        echo "unknown mode: $mode" >&2
        exit 2 ;;
esac
