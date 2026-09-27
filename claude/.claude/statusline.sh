#!/usr/bin/env bash
# Claude Code status line: "model · dir · branch".
input="$(cat)"
command -v jq >/dev/null 2>&1 || { printf 'claude\n'; exit 0; }
j() { printf '%s' "$input" | jq -r "$1" 2>/dev/null; }
model="$(j '.model.display_name // .model.id // "?"')"
cwd="$(j '.workspace.current_dir // .cwd // "."')"
dir="$(basename "$cwd")"
branch="$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)"
line="$model · $dir"
[ -n "$branch" ] && line="$line · $branch"
printf '%s\n' "$line"
