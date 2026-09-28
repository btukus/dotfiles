# Completions. Sourced from antidote.zsh, after plugin completion dirs are on
# fpath and before fzf-tab loads.
autoload -Uz compinit
zmodload -F zsh/stat b:zstat
zmodload zsh/datetime
typeset -U fpath

# Always trust the cached dump (-C): a full compinit rescans the whole fpath and takes ~277ms,
# which used to land on the first shell of the day and made it visibly slower than the next one.
# The rescan still happens daily, just in the background, so it only ever benefits the next shell.
() {
  local zcd=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION
  [[ -d ${zcd:h} ]] || mkdir -p ${zcd:h}
  compinit -C -d $zcd
  { [[ ! -f $zcd.zwc || $zcd -nt $zcd.zwc ]] && zcompile $zcd } &!

  # Stale? Claim the slot first by bumping the mtime, so shells starting at the same time
  # don't all fork the same rescan, then rebuild out of the way and swap it in.
  # Checked with zstat, not a glob qualifier: `[[ -n $zcd(#qN.mh-24) ]]` does no filename
  # generation inside [[ ]], so it compared a literal string and was always true - the rescan
  # never ran and the dump never picked up completions from newly installed tools.
  local -a zcd_mtime
  zstat -A zcd_mtime +mtime $zcd 2>/dev/null
  if (( EPOCHSECONDS - ${zcd_mtime[1]:-0} > 86400 )); then
    touch $zcd
    {
      local tmp=$zcd.new.$$
      if compinit -d $tmp; then
        zcompile $tmp 2>/dev/null
        mv -f $tmp $zcd
        [[ -f $tmp.zwc ]] && mv -f $tmp.zwc $zcd.zwc
      fi
      rm -f $tmp $tmp.zwc
    } &!
  fi
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
