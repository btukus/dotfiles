# zmodload zsh/zprof


eval $(/opt/homebrew/bin/brew shellenv)

export EDITOR=nvim
export VISUAL=nvim

export TERM=xterm-256color
if [ -z "$TMUX" ]; then
  exec tmux new-session -A -s personal
fi

ZSHZ_DATA=$ZDOTDIR/.zshz
ZSHZ_TILDE=1
export HISTSIZE=999999999
export HISTFILESIZE=9999999999


zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# source antidote
source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
# source $ZDOTDIR/antidote/.antidote/antidote.zsh
# antidote bundle <$ZDOTDIR/antidote/shared_plugins.txt >$ZDOTDIR/antidote/shared_plugins.zsh
source $ZDOTDIR/antidote/shared_plugins.zsh

for file in "$ZDOTDIR"/aliases/*.zsh; do
  if [[ -f $file ]]; then
    source "$file"
  fi
done

ssh_keys=(github gitlab bitbucket devops)
for n in ${ssh[@]}; do
  if [[ -f ~/.ssh/$n/$n ]]; then
    ssh-add ~/.ssh/$n/$n
  fi
done

. $(brew --prefix asdf)/libexec/asdf.sh
# . ~/.asdf/plugins/java/set-java-home.zsh
. "/Users/btukus/.asdf/installs/rust/stable/env" 

# autoload -Uz compinit
#
# () {
#   if [[ $# -gt 0 ]]; then
#     compinit
#   else
#     compinit -C
#   fi
# } ${ZDOTDIR}/.zcompdump(N.mh+24)
#

# eval "$(starship init zsh)"
eval "$(oh-my-posh init zsh --config ~/dotfiles/zsh/nordtron.omp.json)"

# zprof
