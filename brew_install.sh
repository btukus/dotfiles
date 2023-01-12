systemtype=$(uname -s)

# Install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [[ "$systemtype" == "Linux" ]]; then
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$(whoami)/.profile
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$(whoami)/.bashrc
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  source ~/.profile
  source ~/.bashrc
  sudo apt-get install build-essential python3-pip -y
fi

# Add brew to the shell
if [[ "$systemtype" == "Darwin" ]]; then
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/btukus/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
