# ZSHZ
ZSHZ_DATA=$ZDOTDIR/z/.zshz
ZSHZ_TILDE=1

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select

# Load completions
autoload -Uz compinit

() {
  if [[ $# -gt 0 ]]; then
    compinit
  else
    compinit -C
  fi
} ${ZDOTDIR}/z/.zcompdump(N.mh+24)
