# Completions. Sourced from antidote.zsh, after plugin completion dirs are on
# fpath and before fzf-tab loads.
autoload -Uz compinit
typeset -U fpath

# Full compinit at most once a day; otherwise trust the cached dump (-C).
() {
  local zcd=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION
  [[ -d ${zcd:h} ]] || mkdir -p ${zcd:h}
  if [[ -n $zcd(#qN.mh-24) ]]; then
    compinit -C -d $zcd
  else
    compinit -d $zcd
    touch $zcd          # compinit skips rewriting an unchanged dump; bump mtime so we don't rescan every start
  fi
  { [[ ! -f $zcd.zwc || $zcd -nt $zcd.zwc ]] && zcompile $zcd } &!
}

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu no                      # fzf-tab draws the menu
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache
zstyle ':completion:*:git-checkout:*' sort false

# fzf-tab
zstyle ':fzf-tab:*' fzf-flags --height=60% --color=hl:2 --bind=tab:accept
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:complete:(cd|z|ls|eza|cat|bat|nvim|vim):*' fzf-preview \
  '[[ -d $realpath ]] && eza -1 --color=always $realpath || bat --color=always --style=numbers $realpath 2>/dev/null'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff --color=always $word'
