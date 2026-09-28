# Plugin settings. Must be sourced before antidote.zsh: plugins read these at load time.

# zsh-z
ZSHZ_DATA=$ZDOTDIR/z/.zshz
ZSHZ_TILDE=1

# zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# zsh-abbr
# Loading is linear in the number of abbreviations: every line of the abbreviations file becomes
# an `abbr` call, and each one takes zsh-abbr's cross-session file lock. At ~250 abbreviations
# that was ~130ms of a ~250ms startup, on every pane. So load them once and cache the parsed
# result: ABBR_CACHE holds `typeset -p` of zsh-abbr's own state arrays, restored at the end of
# .zshrc. On a hit the plugin reads an empty file instead and costs nothing; on a miss (any
# input file newer than the cache) it loads normally and the cache is rewritten.
# `abbr add/erase` keep working: they rewrite the real file, which invalidates the cache.
ABBR_CACHE=${XDG_CACHE_HOME:-$HOME/.cache}/zsh-abbr-cache.zsh
ABBR_USER_ABBREVIATIONS_FILE=${ABBR_USER_ABBREVIATIONS_FILE:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh-abbr/user-abbreviations}
() {
  local f
  # Stale if anything that can define an abbreviation is newer than the cache
  for f in $ABBR_USER_ABBREVIATIONS_FILE ~/dotfiles-private/zsh/*.zsh(N); do
    [[ $f -nt $ABBR_CACHE ]] && return
  done
  [[ -r $ABBR_CACHE ]] || return
  typeset -g ABBR_CACHE_HIT=1
  # Feed the plugin an empty file; the real path is restored before anything can write to it
  typeset -g ABBR_USER_ABBREVIATIONS_FILE_REAL=$ABBR_USER_ABBREVIATIONS_FILE
  typeset -g ABBR_USER_ABBREVIATIONS_FILE=${ABBR_CACHE:h}/zsh-abbr-empty
  [[ -e $ABBR_USER_ABBREVIATIONS_FILE ]] || { mkdir -p ${ABBR_CACHE:h}; : >$ABBR_USER_ABBREVIATIONS_FILE }
}

ABBR_QUIET=1
ABBR_SET_EXPANSION_CURSOR=1                                   # '%' in an expansion marks where the cursor lands
ABBR_EXPERIMENTAL_COMMAND_POSITION_REGULAR_ABBREVIATIONS=2    # also expand after && || | ;
typeset -ga ABBR_REGULAR_ABBREVIATION_SCALAR_PREFIXES=('sudo ' 'watch ' 'time ' 'command ' 'nohup ')
ABBR_GET_AVAILABLE_ABBREVIATION=1                             # remind when a typed command has an abbreviation
ABBR_LOG_AVAILABLE_ABBREVIATION=1
ABBR_LOG_AVAILABLE_ABBREVIATION_AFTER=1
