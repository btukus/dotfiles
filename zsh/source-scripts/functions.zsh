# Complex aliases converted to functions
#
# Loader: sources all per-domain function files from zsh/functions/.
# Files are split by domain; numeric prefixes control load order (deps first).
for _func_file in "$ZDOTDIR/functions"/*.zsh(N); do
  [[ -r "$_func_file" ]] && source "$_func_file"
done
unset _func_file
