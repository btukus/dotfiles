# Antidote
# Only ever needed to regenerate a static bundle, so it is sourced on demand rather than in
# every shell. Prefer a brew-installed antidote; fall back to a git-cloned copy under
# $ZDOTDIR/antidote/.antidote (the layout used by the antidote ansible role
# and the Synology installer, since there's no brew on the NAS).
_antidote_init() {
  if [[ -r "$ZDOTDIR/antidote/.antidote/antidote.zsh" ]]; then
    source "$ZDOTDIR/antidote/.antidote/antidote.zsh"
    return
  fi
  local prefix
  for prefix in /opt/homebrew /home/linuxbrew/.linuxbrew /usr/local; do
    if [[ -r "$prefix/opt/antidote/share/antidote/antidote.zsh" ]]; then
      source "$prefix/opt/antidote/share/antidote/antidote.zsh"
      return
    fi
  done
}

# Bundle a plugin list into a static file ($1 with .txt -> .zsh) and source it.
# Regenerates when the static file is missing, older than the list, or stale: any path in it
# gone or outside $ANTIDOTE_HOME (plugins deleted, ANTIDOTE_HOME moved, or an antidote upgrade
# changed the layout). Every path is checked, not just the first: the other bundle re-clones
# its own plugins, so one surviving path says nothing about the rest. ~15 stats, no forks.
_antidote_load() {
  local list=$1 static=${1%.txt}.zsh line word p

  if [[ -f $static ]]; then
    if [[ $list -nt $static ]]; then
      rm -f $static
    else
      while read -r line; do
        for word in ${(z)line}; do
          [[ $word == */* ]] || continue
          p=${(e)${(Q)word}}
          if [[ ! -e $p || ( -n $ANTIDOTE_HOME && $p != $ANTIDOTE_HOME/* ) ]]; then
            rm -f $static
            break 2
          fi
        done
      done <$static
    fi
  fi

  if [[ ! -f $static ]]; then
    (( $+functions[antidote] )) || _antidote_init
    antidote bundle <$list >$static
    _antidote_zcompile $static
  fi
  source $static
}

# Precompile the plugins the bundle sources, so every shell reads bytecode instead of parsing
# ~1.5MB of zsh. Done once, when the bundle is generated. zsh ignores a .zwc that is older than
# its source, so after a plugin update this silently falls back to parsing until the next
# regeneration - correctness never depends on it.
_antidote_zcompile() {
  local line file dir f
  for line in ${(f)"$(<$1)"}; do
    [[ $line == source\ * ]] || continue
    file=${(e)${line#source }}
    dir=${file:h}
    for f in $dir/*.zsh(N) $dir/*.zsh-theme(N); do
      [[ -r $f && ( ! -f $f.zwc || $f -nt $f.zwc ) ]] && zcompile -R $f 2>/dev/null
    done
  done
}

# Completion dirs first, then compinit, then the plugins (fzf-tab needs compinit done)
_antidote_load $ZDOTDIR/antidote/fpath_plugins.txt
source $ZDOTDIR/source-scripts/load-completions.zsh
_antidote_load $ZDOTDIR/antidote/shared_plugins.txt
unfunction _antidote_load _antidote_init _antidote_zcompile
