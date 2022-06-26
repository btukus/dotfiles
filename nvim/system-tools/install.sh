# Update and Upgrade system packages
sudo apt-get update && sudo apt-get upgrade -y

# Install all build essentials
sudo apt-get install build-essential procps curl file git unzip ripgrep xsel wl-clipboard python3-pip -y

# Install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


# Install Packer
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer -y

# Install nvm for node version manager
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
# command -v nvm

# Install node
# nvm install --lts
# node --version
# npm --version

# Install latest stable java
sudo apt install default-jre -y

# Add brew to the shell
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$(whoami)/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install nvm
brew install nvm
mkdir ~/.nvm
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# Install Neovim
brew install neovim

# Install dependencies
sudo pip install pynvim
sudo npm i -g neovim
