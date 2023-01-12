brew bundle --file=~/dotfiles/brew/Brewfile

# set the amazing ZDOTDIR variable
export ZDOTDIR=~/dotfiles/zsh

# change the root .zshenv file to use ZDOTDIR
cat << 'EOF' >| ~/.zshenv
export ZDOTDIR=~/dotfiles/zsh
[[ -f $ZDOTDIR/.zshenv ]] && . $ZDOTDIR/.zshenv
EOF

# Stow dotfiles
stow git
stow config
stow tmux
if [[ "$SHELL" == "$(which bash)" ]]; then
  stow bash
fi

# Install Antidote
git clone https://github.com/mattmc3/antidote.git $ZDOTDIR/antidote/.antidote
. $ZDOTDIR/antidote/.antidote/antidote.zsh
antidote load

# Change shell to zsh 
if [[ "$SHELL" != "$(which zsh)" ]]; then
  sudo sh -c "echo $(which zsh) >> /etc/shells" && "chsh -s $(which zsh)"
fi

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install node 
if command -v nvm > /dev/null; then
  nvm install --lts
  sudo npm i -g neovim
  npm install -g prettier
  npm i -g neovim
# gem install neovim
fi

if command -v pyenv > /dev/null; then
  pyenv install 3.10.4
  pyenv global 3.10.4
  sudo pip3 install pynvim
fi
