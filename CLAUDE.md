# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles for macOS/Linux development environment. Uses stow for symlink management and Ansible for automated setup.

## Quick Start (Fresh macOS Install)

```bash
# One command to set up everything
curl -fsSL https://raw.githubusercontent.com/btukus/dotfiles/main/install.sh | bash

# Or if already cloned
cd ~/dotfiles && ./install.sh
```

This installs Xcode CLI tools, Homebrew, all packages, and runs Ansible.

## Manual Setup Commands

```bash
# Install Homebrew only
./brew_install.sh

# Install all brew packages
brew bundle --file=brew/Brewfile.macos

# Run Ansible playbook
ansible-playbook ansible/macos_playbook.yml

# Symlink configs with stow (from dotfiles root)
stow -t ~ config  # Links config/.config/* to ~/.config/
stow -t ~ zsh     # Links zsh files to ~/
stow -t ~ git     # Links git config to ~/
```

## Architecture

### Zsh Configuration
- Entry point: `zsh/.zshenv` sets `$ZDOTDIR` to `~/dotfiles/zsh`
- `zsh/.zshrc` sources modular scripts from `zsh/source-scripts/`:
  - `load-paths.zsh` - PATH and editor settings
  - `load-completions.zsh` - Completion configuration
  - `load-history-settings.zsh` - History settings
  - `antidote.zsh` - Plugin manager (loads `zsh/antidote/shared_plugins.txt`)
  - `load-aliases.zsh` - Recursively sources all `.zsh` files in `zsh/aliases/`
  - `asdf.zsh` - Version manager integration
  - `.p10k.zsh` - Powerlevel10k theme

### Aliases Organization (`zsh/aliases/`)
- `git/` - Git shortcuts and worktree helpers (`gg` for lazygit)
- `kubernetes/` - kubectl, helm, k8s shortcuts (`k` for kubectl)
- `tools/` - Docker, Azure, brew, tmux, nvim aliases
- `languages/` - Language-specific aliases
- `clients/`, `machines/` - Environment-specific configs

### Key Tools
- **asdf**: Version management for nodejs, python, rust, java, maven, terraform, bun (see `asdf/.tool-versions`)
- **antidote**: Zsh plugin manager via Homebrew
- **tmux**: Uses TPM with nord theme, vim-tmux-navigator, resurrect/continuum
- **neovim**: LazyVim-based config with VSCode compatibility mode

### Config Locations
- `config/.config/nvim/` - Neovim config (Lua-based, uses lazy.nvim)
- `config/.config/tmux/tmux.conf` - Tmux configuration
- `config/.config/alacritty/` - Terminal emulator
- `config/.config/k9s/` - Kubernetes TUI
- `config/.config/lazygit/` - Git TUI

### Tmux Keybindings
- Prefix: `Alt-f`
- `Alt-t` - New window
- `Alt-w` - Kill pane
- `Alt-j` - Popup shell session
- `Alt-k` - Popup k9s session
- `Alt-1/2/3` - Switch to named sessions

### macOS Settings
Run `macos/settings.sh` to configure dock auto-hide, Finder quit menu, and disable press-and-hold.
