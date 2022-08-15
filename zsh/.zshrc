# # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

systemtype="$(uname -s)"

export HISTSIZE=10000
export HISTFILESIZE=10000

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

export NVM_DIR=${HOME}/.nvm
export NVM_COMPLETION=true

# source antidote
source $ZDOTDIR/.antidote/antidote.zsh
antidote bundle <$ZDOTDIR/.zsh_plugins.txt >$ZDOTDIR/.zsh_plugins.zsh
source $ZDOTDIR/.zsh_plugins.zsh

loadFiles=(zsh_aliases zsh_git_aliases zsh_k8s_aliases zsh_functions)
for t in ${loadFiles[@]}; do
  if [[ -f $ZDOTDIR/$t ]]; then
    source $ZDOTDIR/$t
  fi
done

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh


if [ "$systemtype" = "Darwin" ] ; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
else 
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi 

# Load Angular CLI autocompletion.
source <(ng completion script)

eval $(thefuck --alias)


export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
