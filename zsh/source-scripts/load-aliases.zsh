# Load alias definitions from zsh/aliases/*.zsh
for _alias_file in "$ZDOTDIR"/aliases/*.zsh; do
  [[ -r "$_alias_file" ]] && source "$_alias_file"
done
unset _alias_file
