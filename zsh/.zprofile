# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

systemtype="$(uname -s)"
if [ "$systemtype" = "Darwin" ] ; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else 
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi 

bindkey '^ ' autosuggest-accept

export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh" # This loads nvm

export CLICOLOR=1
