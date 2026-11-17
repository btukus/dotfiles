#!/bin/sh
# Saved sessions can restore explicit window indexes, including zero.
tmux list-sessions -F '#{session_id}' 2>/dev/null | while IFS= read -r session; do
  tmux move-window -r -t "$session:"
done
