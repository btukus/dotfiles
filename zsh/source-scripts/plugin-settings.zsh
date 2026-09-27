# Plugin settings. Must be sourced before antidote.zsh: plugins read these at load time.

# zsh-vi-mode: initialise while being sourced (not lazily at the first prompt), so
# keys bound by later plugins and keybindings.zsh aren't overwritten afterwards.
ZVM_INIT_MODE=sourcing
ZVM_LAZY_KEYBINDINGS=false

# zsh-z
ZSHZ_DATA=$ZDOTDIR/z/.zshz
ZSHZ_TILDE=1

# zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# zsh-abbr
ABBR_QUIET=1
ABBR_SET_EXPANSION_CURSOR=1                                   # '%' in an expansion marks where the cursor lands
ABBR_EXPERIMENTAL_COMMAND_POSITION_REGULAR_ABBREVIATIONS=2    # also expand after && || | ;
typeset -ga ABBR_REGULAR_ABBREVIATION_SCALAR_PREFIXES=('sudo ' 'watch ' 'time ' 'command ' 'nohup ')
ABBR_GET_AVAILABLE_ABBREVIATION=1                             # remind when a typed command has an abbreviation
ABBR_LOG_AVAILABLE_ABBREVIATION=1
ABBR_LOG_AVAILABLE_ABBREVIATION_AFTER=1
