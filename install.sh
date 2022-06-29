# Brew dependencies
sudo apt-get install build-essential

# Install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add brew to the shell
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$(whoami)/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install packages in Brewfile
brew bundle --file=~/dotfiles/brew/Brewfile

# Stow dotfiles
stow git
#stow bash
stow zsh 
stow nvim
# stow tmux

# Install Antidote
git clone https://github.com/mattmc3/antidote.git ~/.antidote
. ~/.antidote/antidote.zsh
antidote load

# Install zsh plugins with antidote
# antidote bundle <~/.zsh_plugins.txt >~/.zsh_plugins.sh

# Change shell to zsh 
sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)

# Install node 
nvm install --lts
sudo npm i -g neovim
npm install --save-dev --save-exact prettier

# Install dependencies
sudo pip install pynvim

# Install Oh-My-ZSH
zsh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
