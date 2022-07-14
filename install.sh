systemtype=$(uname -s)
if [[ "$systemtype" == "Darwin" ]]; then
  echo $systemtype
else
  echo "Not working"
fi

if [[ "$systemtype" == "Linux" ]]; then
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$(whoami)/.profile
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  sudo apt-get install build-essential python3-pip -y
fi

# Install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add brew to the shell
if [[ "$systemtype" == "Darwin" ]]; then
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/btukus/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install packages in Brewfile
brew bundle --file=~/dotfiles/brew/Brewfile

# Stow dotfiles
stow git
stow zsh 
stow nvim
#stow bash
stow tmux

# Install Antidote
git clone https://github.com/mattmc3/antidote.git ~/.antidote
. ~/.antidote/antidote.zsh
antidote load

# Change shell to zsh 
sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install node 
nvm install --lts
sudo npm i -g neovim
npm install -g prettier
npm i -g neovim
# gem install neovim

pyenv install 3.10.4
pyenv global 3.10.4
sudo pip3 install pynvim

# Create tools-nvim directory
mkdir  ~/dotfiles/nvim/.config/tools-nvim/

# Clone java-debug
git clone git@github.com:microsoft/java-debug.git ~/dotfiles/nvim/.config/tools-nvim/java-debug/
current_dir=~/dotfiles;cd ~/dotfiles/nvim/.config/tools-nvim/java-debug; ./mvnw clean install;cd $current_dir;

# Clone vscde-java-debug
git clone git@github.com:microsoft/vscode-java-test.git ~/dotfiles/nvim/.config/tools-nvim/vscode-java-test/
current_dir=~/dotfiles;cd ~/dotfiles/nvim/.config/tools-nvim/vscode-java-test; npm i && npm run build-plugin; cd $current_dir;
