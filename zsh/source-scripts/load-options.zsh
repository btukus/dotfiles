# Interactive shell options
setopt AUTO_CD                 # type a directory name to cd into it
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_MINUS PUSHD_SILENT   # cd -<Tab> picks from recent dirs
setopt INTERACTIVE_COMMENTS    # allow # comments on the command line
setopt NUMERIC_GLOB_SORT
setopt NO_BEEP
setopt NO_FLOW_CONTROL         # free up ^S/^Q
setopt LONG_LIST_JOBS NOTIFY
DIRSTACKSIZE=20

# Ctrl-W / Alt-Backspace stop at / . - (delete one path segment, not the whole path)
WORDCHARS=${WORDCHARS//[\/.-]}
