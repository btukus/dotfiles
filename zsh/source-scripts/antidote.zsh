# Antidote
# Prefer a brew-installed antidote; fall back to a git-cloned copy under
# $ZDOTDIR/antidote/.antidote (the layout used by the antidote ansible role
# and the Synology installer, since there's no brew on the NAS).
if [[ -r "$ZDOTDIR/antidote/.antidote/antidote.zsh" ]]; then
  source "$ZDOTDIR/antidote/.antidote/antidote.zsh"
else
  for _antidote_prefix in /opt/homebrew /home/linuxbrew/.linuxbrew /usr/local; do
    if [[ -r "$_antidote_prefix/opt/antidote/share/antidote/antidote.zsh" ]]; then
      source "$_antidote_prefix/opt/antidote/share/antidote/antidote.zsh"
      break
    fi
  done
  unset _antidote_prefix
fi

# Bundle a plugin list into a static file ($1 with .txt -> .zsh) and source it.
# Regenerates when the static file is missing, older than the list, or stale
# (paths gone -- e.g. after an antidote major upgrade changes the cache layout).
_antidote_load() {
  local list=$1 static=${1%.txt}.zsh first_line first_path

  if [[ -f $static ]]; then
    read -r first_line <$static                     # fpath+=( "<dir>" )
    first_path=${(Q)${(z)first_line}[2]}            # -> "<dir>"
    if [[ $list -nt $static ]] || [[ ! -d ${(e)first_path} ]]; then
      rm -f $static
    fi
  fi

  [[ -f $static ]] || antidote bundle <$list >$static
  source $static
}

# Completion dirs first, then compinit, then the plugins (fzf-tab needs compinit done)
_antidote_load $ZDOTDIR/antidote/fpath_plugins.txt
source $ZDOTDIR/source-scripts/load-completions.zsh
_antidote_load $ZDOTDIR/antidote/shared_plugins.txt
unfunction _antidote_load
