# Install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Antidote
git clone https://github.com/mattmc3/antidote.git ~/.antidote

# Add brew to the shell
# echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$(whoami)/.profile
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install packages in Brewfile
brew bundle ~/dofiles/brew/Brewfile

# Stow dotfiles
stow git
stow bash
stow zsh 
stow nvim
# stow tmux

# Install Oh-My-ZSH
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh plugins with antidote
antidote bundle <~/.zsh_plugins.txt >~/.zsh_plugins.zsh

# Install dependencies
sudo pip install pynvim
sudo npm i -g neovim
