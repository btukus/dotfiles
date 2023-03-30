#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  brew bundle --file=~/dotfiles/brew/Brewfile.macos
else
  brew bundle --file=~/dotfiles/brew/Brewfile.linux
fi

# set the amazing ZDOTDIR variable
export ZDOTDIR=~/dotfiles/zsh
cat << 'EOF' >| ~/.zshenv
export ZDOTDIR=~/dotfiles/zsh
[[ -f $ZDOTDIR/.zshenv ]] && . $ZDOTDIR/.zshenv
EOF


# Stow dotfiles
stow git
stow config

if [[ "$SHELL" == "$(which bash)" ]]; then
  rm ~/.bashrc
  rm ~/.profile
  stow bash
fi

# Install Antidote
git clone https://github.com/mattmc3/antidote.git $ZDOTDIR/antidote/.antidote
source $ZDOTDIR/antidote/.antidote/antidote.zsh
antidote bundle <$ZDOTDIR/antidote/shared_plugins.txt >$ZDOTDIR/antidote/shared_plugins.zsh
source $ZDOTDIR/antidote/shared_plugins.zsh

# Change shell to zsh 
if [[ "$SHELL" != "$(which zsh)" ]]; then
  sudo sh -c "echo $(which zsh) >> /etc/shells" && "chsh -s $(which zsh)"
fi

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

tmux start-server && \ tmux new-session -d && \ sleep 1 && \ ~/.tmux/plugins/tpm/scripts/install_plugins.sh

# Install node 
if command -v asdf > /dev/null; then
  asdf plugin-add nodejs
  asdf install nodejs lts
  asdf install nodejs lts
  asdf global nodejs lts
  npm i -g neovim
  npm install -g prettier

  # Python
  asdf plugin-add python
  asdf install python 3.11.0
  asdf global python 3.11.0
  sudo pip3 install pynvim
fi
