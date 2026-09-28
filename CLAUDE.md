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
# Install all brew packages
brew bundle --file=brew/Brewfile.macos

# Run Ansible playbook
ansible-playbook ansible/macos_playbook.yml

# Symlink configs with stow (from dotfiles root)
stow -t ~ config  # Links config/.config/* to ~/.config/
echo 'export ZDOTDIR=~/dotfiles/zsh; [[ -f $ZDOTDIR/.zshenv ]] && . $ZDOTDIR/.zshenv' > ~/.zshenv  # zsh is not stowed
stow -t ~ git     # Links git config to ~/
```

## Prerequisites

Install Nerd Font for Powerlevel10k: https://github.com/romkatv/powerlevel10k/blob/master/font.md

## Architecture

### Zsh Configuration
- Entry point: `zsh/.zshenv` sets `$ZDOTDIR` to `~/dotfiles/zsh`
- `zsh/.zshrc` sources modular scripts from `zsh/source-scripts/`:
  - `zellij-autostart.zsh` - First, before p10k instant prompt: Ghostty -> Zellij session `$ZELLIJ_MAIN_SESSION` (default `main`),
    SSH -> `main`; plain shell if Zellij is missing or fails. Inside Zellij it also names tabs
    after the running command / current folder
  - `load-paths.zsh` - PATH and editor settings
  - `load-options.zsh` - Interactive `setopt`s
  - `load-history-settings.zsh` - History settings (file: `$XDG_STATE_HOME/zsh/history`)
  - `plugin-settings.zsh` - Variables plugins read at load time (zsh-vi-mode, abbr, autosuggestions, zsh-z)
  - `antidote.zsh` - Plugin manager: bundles `zsh/antidote/fpath_plugins.txt` (completion dirs),
    runs `load-completions.zsh` (compinit + fzf-tab styles), then bundles `shared_plugins.txt`
  - `keybindings.zsh` - fzf widgets and all `bindkey`s (after plugins, so they win)
  - `load-aliases.zsh` - Sources the flat `.zsh` files in `zsh/aliases/`
  - `asdf.zsh` - Version manager integration
  - `.p10k.zsh` - Powerlevel10k theme

### Aliases Organization (`zsh/aliases/`)
- Flat directory sourced by `source-scripts/load-aliases.zsh` (no subdirs).
- `tools.zsh` - The few remaining plain aliases (`vim`, `fs`)
- `envspecific.zsh` - Environment/machine-specific configs
- Most former aliases (git, kubernetes, languages, etc.) are now shell
  functions in `zsh/functions/NN-<domain>.zsh`, loaded by `source-scripts/functions.zsh`.
- Abbreviations (zsh-abbr) live in `config/.config/zsh-abbr/user-abbreviations`;
  `%` in an expansion marks where the cursor lands.

### Key Tools
- **asdf**: Version management for nodejs, python, rust, java, maven, terraform, bun (see `asdf/.tool-versions`)
- **antidote**: Zsh plugin manager via Homebrew
- **Ghostty + Zellij**: terminal + multiplexer (see below); Nord theme throughout
- **neovim**: LazyVim-based config

### Config Locations
- `config/.config/nvim/` - Neovim config (Lua-based, uses lazy.nvim)
- `config/.config/ghostty/config` - Terminal emulator
- `config/.config/zellij/` - Multiplexer: `config.kdl` (keys, theme), `layouts/default.kdl`
  (zjstatus status bar + swap layouts), `cheatsheet.txt` (shown by `Alt-?`, keep it in sync)
- `config/.config/k9s/` - Kubernetes TUI
- `config/.config/lazygit/` - Git TUI

### Zellij Keybindings
Zellij's defaults are cleared; everything is Alt-based. On macOS, Ghostty's Cmd keys send the Alt
equivalents (Cmd-T/W/J/K/I/S/P/N/F/1..9); on Linux press Alt directly.
- `Ctrl-h/j/k/l` - Focus pane, crossing into nvim splits (`zellij-nav.nvim` + vim-zellij-navigator)
- `Alt-Shift-h/j/k/l` - Move pane; `Alt--` / `Alt-|` - split below / beside
- `Alt-b` / `Alt-<` / `Alt->` - Pane to a new / previous / next tab
- `Alt-t` new tab, `Alt-w` close pane, `Alt-z` zoom, `Alt-e` float/dock, `Alt-Space` cycle layout
- `Alt-1..9` - Go to tab N; `Alt-p` / `Alt-n` - move tab left / right
- `Alt-j` - Show/hide floating panes (scratch shell); `Alt-k` - k9s in a floating pane
- `Alt-o` - Project picker (repos/worktrees under `~/code`, from the `repos` manifest; from a shell:
  `tj [project]`); `Alt-s` - session manager
- `Alt-v` - Scroll/copy mode (`/` search, `e` opens the scrollback in nvim)
- `Alt-f` - "Prefix" mode: `c` new tab, `,` rename tab, `d` detach, `Ctrl-hjkl` resize, `m` move mode
- `F12` - Lock: pass all keys to a nested (SSH) Zellij; F12 again to return
- `Alt-?` - Cheatsheet

Layout changes (`default_layout`, the bar) only apply to new sessions, and a restarted session is
resurrected with its saved layout. Reset with the `zr` abbreviation (kill + delete the main session).

### Private overlay (`~/dotfiles-private`)
This repo is public, so anything personal or work-related lives in the private
`btukus/dotfiles-private` repo. The `private` Ansible role clones it (after the GitHub SSH key
is added; re-run the playbook), and everything below is optional - without it the public setup
works on its own:
- `ansible/{macos,linux}.yml` - overrides `ssh_origins` (work keys, org routing), loaded by the playbooks
- `brew/Brewfile` - work packages, installed by the `private` role
- `git/config` - `user.email`, included by `git/.gitconfig`
- `zsh/env.zsh` - sourced by `.zshenv` (`ZELLIJ_MAIN_SESSION`, `CLIP2SERVER_HOST`, `WORKTREE_ROOTS`)
- `zsh/*.zsh` - sourced at the end of `.zshrc` (work functions, session abbreviations, hosts)
- `claude/settings.json` - Claude Code settings (incl. `autoMode`), linked to `~/.claude/settings.json` by the
  `private` role; `claude/.claude/statusline.sh` stays public
- `repos.conf` - the `repos` manifest
Never commit names of employers/clients, internal hosts, IPs, emails or tokens here; put them there.
A pre-commit hook (`.githooks/pre-commit`, rules in `.gitleaks.toml`, enabled by the stow role via
`core.hooksPath`) runs gitleaks and blocks secrets, employer/client names, private IPs and emails.

### macOS Settings
Run `macos/settings.sh` to configure dock auto-hide, Finder quit menu, and disable press-and-hold.

### Repos (`scripts/repos`, Ansible role `repos`)
All code lives under `~/code` (`$CODE_ROOT`) in any folder layout. `repos` discovers
every repo there (bare `gbare`-style or normal clone), and records path, layout,
remotes and worktrees in `~/dotfiles-private/repos.conf` — a **private** repo,
because this one is public. A launchd agent (`com.btukus.repos-sync`, log:
`~/Library/Logs/repos-sync.log`) runs `repos sync` at 0/4/8/12/16/20h (missed slots run on wake) and pushes manifest changes.
- New machine: add SSH keys to GitHub/Azure DevOps, re-run the playbook, then `repos restore`
- `repos status -f` — what a restore would lose (dirty, unpushed, stashes, .env files, non-git folders)
- `repos repair` — relink worktrees after moving repos (new worktrees use relative paths via `worktree.useRelativePaths`)
- `.env` files on disk are flagged by `repos status` (inject secrets from a secrets manager instead).
