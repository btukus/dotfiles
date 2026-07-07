#!/usr/bin/env bash
# Claude Code status line: "model · dir · branch", with a caveman marker
# appended when the caveman@caveman plugin is active. Plugin state is NOT
# exposed on the statusLine stdin, so we read enabledPlugins from the settings
# files directly (precedence: local > project > user).
input="$(cat)"
command -v jq >/dev/null 2>&1 || { printf 'claude\n'; exit 0; }
j() { printf '%s' "$input" | jq -r "$1" 2>/dev/null; }
model="$(j '.model.display_name // .model.id // "?"')"
proj="$(j '.workspace.project_dir // .workspace.current_dir // .cwd // "."')"
cwd="$(j '.workspace.current_dir // .cwd // "."')"
dir="$(basename "$cwd")"
branch="$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)"
caveman=""
for f in "$proj/.claude/settings.local.json" "$proj/.claude/settings.json" "$HOME/.claude/settings.json"; do
  if [ -f "$f" ]; then
    v="$(jq -r '.enabledPlugins["caveman@caveman"] // empty' "$f" 2>/dev/null)"
    if [ -n "$v" ]; then caveman="$v"; break; fi
  fi
done
line="$model · $dir"
[ -n "$branch" ] && line="$line · $branch"
[ "$caveman" = "true" ] && line="$line · 🗿 caveman"
printf '%s\n' "$line"
