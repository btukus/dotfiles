#!/bin/bash
set -e

echo "=== macOS Development Environment Setup ==="

# 1. Install Xcode Command Line Tools (required for git, brew)
if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Press any key after Xcode tools are installed..."
    read -n 1
fi

# 2. Install Homebrew
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 3. Clone dotfiles (if not already in dotfiles directory)
DOTFILES_DIR="$HOME/dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/btukus/dotfiles.git "$DOTFILES_DIR"
fi
cd "$DOTFILES_DIR"

# 4. Install all brew packages (includes ansible, stow, etc.)
echo "Installing brew packages..."
brew bundle --file=brew/Brewfile.macos || echo "Warning: Some brew packages failed to install (continuing...)"

# 5. Run Ansible playbook
echo "Running Ansible playbook..."
ansible-playbook ansible/macos_playbook.yml

# 6. Apply macOS settings
echo "Applying macOS settings..."
bash macos/settings.sh

echo ""
echo "=== Setup complete! ==="
echo "Restart your terminal to apply all changes."
