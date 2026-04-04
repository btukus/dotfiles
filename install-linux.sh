#!/bin/bash
set -e

echo "=== Ubuntu Development Environment Setup ==="

# Ask for sudo upfront and keep it alive
if [ -t 0 ]; then
    sudo -v
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    SUDO_PID=$!
    trap "kill $SUDO_PID 2>/dev/null" EXIT
fi

# 1. Install apt packages
echo "Installing apt packages..."
sudo apt-get update
grep -v '^#' "$(dirname "$0")/brew/aptfile.txt" | grep -v '^$' | xargs sudo apt-get install -y

# 2. Install Homebrew
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Set up Homebrew environment
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# 3. Clone dotfiles (if not already in dotfiles directory)
DOTFILES_DIR="$HOME/dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/btukus/dotfiles.git "$DOTFILES_DIR"
fi
cd "$DOTFILES_DIR"

# 4. Install all brew packages
echo "Installing brew packages..."
brew bundle --file=brew/Brewfile.linux || echo "Warning: Some brew packages failed to install (continuing...)"

# 5. Run Ansible playbook
echo "Running Ansible playbook..."
if ! ansible-playbook ansible/linux_playbook.yml; then
    echo "Warning: Ansible playbook had errors (continuing...)"
fi

echo ""
echo "=== Setup complete! ==="
echo "Restart your terminal to apply all changes."
