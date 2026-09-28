# AGENTS.md

## Repository purpose

This is a public personal dotfiles repository for macOS and Linux. It uses:

- GNU Stow to link configuration into the home directory.
- Ansible to provision machines and install/link the dotfiles.
- Zsh with modular startup scripts, Antidote plugins, and asdf.

This repository is paired with the private checkout at
`/Users/btukus/dotfiles-private` (normally `~/dotfiles-private`). Read
the sections below before making structural changes.

## Setup and provisioning

For a fresh macOS machine, the bootstrap entry point is:

```bash
curl -fsSL https://raw.githubusercontent.com/btukus/dotfiles/main/install.sh | bash
```

For an existing checkout, run `./install.sh`. Common manual commands are:

```bash
# Install macOS Homebrew packages.
brew bundle --file=brew/Brewfile.macos

# Provision a macOS machine.
ansible-playbook ansible/macos_playbook.yml

# Link Stow packages from the repository root.
stow -t ~ config
stow -t ~ git
```

Zsh is deliberately not stowed. Its initial setup writes a `~/.zshenv` that
exports `ZDOTDIR=~/dotfiles/zsh` and sources `zsh/.zshenv`. Powerlevel10k needs
a Nerd Font installed.

## Working conventions

- Preserve existing user changes. Do not revert or reformat unrelated files.
- Keep changes small and platform-aware: macOS and Linux provisioning are separate.
- Prefer editing an existing module over adding a new startup layer.
- Shell files are Zsh unless their shebang says otherwise; retain Zsh-compatible
  syntax and quote paths/expansions appropriately.
- Keep aliases in `zsh/aliases/` flat. Put substantial command helpers in the
  numbered domain files under `zsh/functions/`.
- When changing the Zsh startup flow, respect the source ordering in
  `zsh/.zshrc`; Powerlevel10k instant prompt must remain at the top.
- Keep `config/.config/zellij/cheatsheet.txt` aligned with user-visible Zellij
  keybinding changes.

## Zsh architecture

`zsh/.zshenv` is the entry point and sets `ZDOTDIR`. `zsh/.zshrc` sources the
following modules in a deliberate order:

1. `.p10k.zsh` instant prompt first. Do not move it: it avoids input being
   echoed as a stale line before the real prompt renders.
2. `source-scripts/zellij-autostart.zsh`, which opens the configured main Zellij
   session for Ghostty or SSH shells and remains a plain shell if Zellij is
   unavailable. It relies on tty state captured in `.zshenv` because instant
   prompt redirects stdin.
3. `load-paths.zsh`, `load-options.zsh`, and `load-history-settings.zsh`.
4. `plugin-settings.zsh`, which defines settings plugins need while loading and
   manages the zsh-abbr cache at `$XDG_CACHE_HOME/zsh-abbr-cache.zsh`.
5. `antidote.zsh`, then `load-completions.zsh`, then shared plugins. antidote itself
   is sourced only when a bundle has to be regenerated; generating one also `zcompile`s
   the plugins it sources, so shells read bytecode instead of parsing ~1.5MB of Zsh.
   Delete `zsh/antidote/*_plugins.zsh` to force a rebuild, e.g. after updating plugins
   so they are recompiled. `compinit` always uses the cached dump and rebuilds it in
   the background once a day, so no interactive shell waits for the full rescan.
6. `keybindings.zsh`, which also sets up vi mode: Zsh's built-in `bindkey -v` rather
   than a plugin, plus `KEYTIMEOUT`, insert-mode line editing and the beam/block
   cursor. Then `clipboard.zsh`, `functions.zsh`, `load-aliases.zsh`,
   `load-ssh-keys.zsh`, `asdf.zsh`, and the full `.p10k.zsh` theme
   configuration.
7. The optional private Zsh overlay, followed by the zsh-abbr cache restore or
   refresh. Keep this last so private session abbreviations participate in the
   cached snapshot.

The abbreviations source is
`config/.config/zsh-abbr/user-abbreviations`; `%` marks the cursor position in
an expansion. Changes to it or its private overlay invalidate the cache.

### Measuring Zsh startup

`touch $XDG_CACHE_HOME/zsh/profile` to log one line per shell to
`$XDG_CACHE_HOME/zsh/startup.log`, and `rm` it to stop; when off it costs a
single stat. It records both `zshrc=` and `prompt=`, because `zsh -i -c exit`
never runs precmd hooks and so misses gitstatus init, the asdf Java hook and the
prompt render - most of the wait when a pane opens.

### Zsh organization

- `zsh/aliases/` is a flat directory for the few plain aliases.
- `zsh/functions/NN-<domain>.zsh` holds most command helpers, grouped by
  numeric domain prefix.
- `zsh/antidote/fpath_plugins.txt` supplies completion directories; shared
  plugins are listed in `zsh/antidote/shared_plugins.txt`.
- asdf manages Node.js, Python, Rust, Java, Maven, Terraform, and Bun versions
  through `asdf/.tool-versions`.

## Managed application configuration

- `config/.config/nvim/`: LazyVim-based Neovim configuration in Lua.
- `config/.config/ghostty/config`: Ghostty terminal settings.
- `config/.config/zellij/`: `config.kdl`, layouts, and the interactive
  cheatsheet.
- `config/.config/k9s/` and `config/.config/lazygit/`: terminal UI settings.

Ghostty, Zellij, and related terminal applications use the Nord theme.

## Zellij behavior

Zellij defaults are cleared and bindings are Alt-based. On macOS, Ghostty maps
Command keys to the relevant Alt chords; on Linux use Alt directly.

- `Ctrl-h/j/k/l`: focus panes, including Neovim splits through the navigator
  plugins.
- `Alt-Shift-h/j/k/l`: move panes; `Alt--` and `Alt-|`: split below/beside.
- `Alt-b`, `Alt-<`, `Alt->`: move a pane to a new, previous, or next tab.
- `Alt-t`: new tab; `Alt-w`: close pane; `Alt-z`: zoom; `Alt-e`: float/dock;
  `Alt-Space`: cycle layout.
- `Alt-1..9`: go to a tab; `Alt-p`/`Alt-n`: move a tab left/right.
- `Alt-j`: toggle floating panes; `Alt-k`: open k9s in one.
- `Alt-o`: project picker; `Alt-s`: session manager; `Alt-v`: scroll/copy mode;
  `Alt-f`: prefix mode; `Alt-?`: cheatsheet.
- `F12`: pass keys through to nested Zellij (for example over SSH); press it
  again to return.

Layout and status-bar changes apply only to newly created sessions. A restarted
session restores its saved layout. The `zr` abbreviation resets the main session.

## Privacy and security

This repository is public. Never add personal or work-specific data here,
including employer/client names, private hosts or IPs, email addresses, tokens,
SSH material, or private repository URLs. Put it in the paired private checkout
at `~/dotfiles-private` instead.

When a change needs public and private configuration to agree, update only the
public side here unless the task explicitly includes the private checkout. State
the expected private-side follow-up rather than copying private values into this
repository.

The private overlay may provide Ansible overrides, a private Brewfile, Git user
configuration, Zsh environment and extra scripts, Claude settings, and the
`repos.conf` manifest. All overlay pieces are optional: the public setup must
continue to work without them. The private Ansible role clones the overlay after
the GitHub SSH key is configured; re-run the playbook when that prerequisite is
newly satisfied.

A pre-commit hook at `.githooks/pre-commit`, enabled through `core.hooksPath`,
runs gitleaks using `.gitleaks.toml` to block secrets and private identifiers.

Avoid printing secrets from environment files, private overlays, or command
output. Do not modify generated caches or machine-local state.

## Validation

Run the narrowest relevant checks after a change:

- Zsh: `zsh -n <changed-file>`.
- Bash installers: `bash -n <changed-file>`.
- Ansible: `ansible-playbook --syntax-check <playbook>` when Ansible is
  available.
- Stow layout changes: inspect package paths and confirm they map correctly
  beneath the target home directory; do not run a mutating stow operation
  against a real home directory unless explicitly requested.

For behavior that depends on local applications, explain any validation that
cannot be performed in the current environment.

## macOS and repository management

Run `macos/settings.sh` to configure Dock auto-hide, Finder's Quit menu, and
press-and-hold behavior.

`scripts/repos` manages repositories under `~/code` (`$CODE_ROOT`) in arbitrary
folder layouts. It discovers normal and bare repositories, records their paths,
layouts, remotes, and worktrees in the private `repos.conf` manifest, and can
restore them on a new machine.

- `repos status -f` reports what a restore could lose, including dirty or
  unpushed work, stashes, `.env` files, and non-Git folders.
- `repos repair` relinks worktrees after repositories move; worktrees use
  relative paths.
- `repos restore` is the new-machine restoration command, after SSH credentials
  are configured and the provisioning playbook has been re-run.

The `repos` Ansible role also installs a launchd job that syncs the private
manifest six times per day and on wake. `.env` files are intentionally flagged;
use a secrets manager to inject their values instead.

## Common entry points

- `install.sh`, `install-linux.sh`, `install-nas.sh`: bootstrap scripts.
- `ansible/macos_playbook.yml`, `ansible/linux_playbook.yml`: provisioning.
- `zsh/.zshenv`, `zsh/.zshrc`: shell entry points.
- `config/.config/`: stowed application configuration.
- `brew/`: Homebrew bundles.
