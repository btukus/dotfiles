# Key bindings and fzf shell integration. Sourced after antidote.zsh so these win
# over plugin defaults (zsh-vi-mode is initialised by then, see plugin-settings.zsh).

# fzf: ^R history, ^T files, Alt-c cd
export FZF_DEFAULT_OPTS='--height 60% --layout=reverse --border'
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
  export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules'
fi
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :200 {}'"
export FZF_ALT_C_OPTS="--preview 'eza -1 --color=always --group-directories-first {}'"
if (( $+commands[fzf] )); then
  # `fzf --zsh` forks fzf on every shell (~10ms). Cache its output like brew shellenv,
  # regenerating when the binary is newer than the cache.
  () {
    local cache=${XDG_CACHE_HOME:-$HOME/.cache}/fzf-init.zsh
    if [[ ! -f $cache || $commands[fzf] -nt $cache ]]; then
      mkdir -p ${cache:h}
      fzf --zsh >$cache.$$ && mv -f $cache.$$ $cache
    fi
    source $cache
  }
  bindkey -M viins '^I' fzf-tab-complete   # keep fzf-tab on Tab (fzf --zsh rebinds it)
  bindkey -M vicmd '^R' redo               # keep vi redo in normal mode (^R in insert mode = fzf history)
fi

# Up/Down (and k/j in normal mode) search history for the typed prefix
for _km in viins emacs; do
  bindkey -M $_km '^[[A' history-substring-search-up
  bindkey -M $_km '^[OA' history-substring-search-up
  bindkey -M $_km '^[[B' history-substring-search-down
  bindkey -M $_km '^[OB' history-substring-search-down
done
unset _km
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Ctrl-Space accepts the autosuggestion
bindkey -M viins '^@' autosuggest-accept

# Enter expands abbreviations in insert mode, and in normal mode too
# (abbr only looks left of the cursor, and in normal mode the cursor sits on the last char)
bindkey -M viins '^M' abbr-expand-and-accept
abbr-expand-and-accept-vicmd() { CURSOR=$#BUFFER; zle abbr-expand-and-accept }
zle -N abbr-expand-and-accept-vicmd
bindkey -M vicmd '^M' abbr-expand-and-accept-vicmd
