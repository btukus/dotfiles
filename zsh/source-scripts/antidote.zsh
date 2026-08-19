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

# Regenerate the static bundle when it's missing, older than the plugin list, or
# stale (paths gone -- e.g. after an antidote major upgrade changes the cache layout).
() {
  local static=$ZDOTDIR/antidote/shared_plugins.zsh
  local list=$ZDOTDIR/antidote/shared_plugins.txt
  local first_line first_path

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
