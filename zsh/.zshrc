# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

systemtype="$(uname -s)"

if [ "$systemtype" = "Darwin" ] ; then
  eval $(/opt/homebrew/bin/brew shellenv)
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
else 
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi 

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

export HISTSIZE=10000
export HISTFILESIZE=10000

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

export NVM_LAZY_LOAD=true
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('nvim')
export NVM_DIR=${HOME}/.nvm
export NVM_COMPLETION=true

# source antidote
source $ZDOTDIR/antidote/.antidote/antidote.zsh
# antidote bundle <$ZDOTDIR/antidote/shared_plugins.txt >$ZDOTDIR/antidote/shared_plugins.zsh
source $ZDOTDIR/antidote/shared_plugins.zsh

loadFiles=(system git k8s docker node tmux functions envspecific temp)
for t in ${loadFiles[@]}; do
  if [[ -f $ZDOTDIR/aliases/$t.zsh ]]; then
    source $ZDOTDIR/aliases/$t.zsh
  fi
done

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh

export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
