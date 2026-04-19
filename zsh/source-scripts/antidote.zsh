# Antidote
for _antidote_prefix in /opt/homebrew /home/linuxbrew/.linuxbrew /usr/local; do
  if [[ -r "$_antidote_prefix/opt/antidote/share/antidote/antidote.zsh" ]]; then
    source "$_antidote_prefix/opt/antidote/share/antidote/antidote.zsh"
    break
  fi
done
unset _antidote_prefix

if [[ ! -f $ZDOTDIR/antidote/shared_plugins.zsh ]]; then
  antidote bundle <$ZDOTDIR/antidote/shared_plugins.txt >$ZDOTDIR/antidote/shared_plugins.zsh
fi
source $ZDOTDIR/antidote/shared_plugins.zsh
