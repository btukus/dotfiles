# zmodload zsh/zprof

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

export EDITOR=nvim
export VISUAL=nvim

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux -u new-session -A -s personal
fi

ZSHZ_DATA=$ZDOTDIR/.zshz
ZSHZ_TILDE=1
export HISTSIZE=999999999
export HISTFILESIZE=9999999999


zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# source antidote
# source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
source $ZDOTDIR/antidote/.antidote/antidote.zsh
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


# export https_proxy=socks5://localhost:1080


autoload -Uz compinit

() {
  if [[ $# -gt 0 ]]; then
    compinit
  else
    compinit -C
  fi
} ${ZDOTDIR}/.zcompdump(N.mh+24)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh


# zprof
