# Obsidian preferences

Obsidian stores preferences inside each vault's `.obsidian` directory, rather
than in `~/.config`. This directory is therefore **not a Stow package**.

Quit Obsidian, then apply the saved preferences to an existing vault:

```sh
./scripts/obsidian-settings "/path/to/vault"
```

Requires Python 3.9+ and curl. The command merges the saved preferences with the
vault's existing settings, preserves other hotkeys and community plugins, and
downloads missing navigation and Vimrc Support plugins from pinned GitHub
releases. Existing plugin installations and their settings are retained.
Changed files are backed up under `.obsidian/dotfiles-backups/` in the vault.
Reopen Obsidian after applying. Community plugins must be allowed in Settings →
Community plugins (Restricted mode off).

Saved settings include Vim mode, Markdown links, relative link paths, automatic
link updates, frontmatter visibility, readable line length, deletion without a
confirmation prompt, core plugin preferences, and the 950px note-width snippet.
Cmd+E on macOS (Ctrl+E on Linux) focuses the file explorer. The default preview
toggle binding is removed to free that key. Sidebar Keyboard Navigation provides
Vim-style navigation in the explorer.

[Vimrc Support](https://github.com/esm7/obsidian-vimrc-support) loads
`.obsidian.vimrc` from the vault root. The installer adds a source line for
`.obsidian/dotfiles.vimrc`, preserving existing Vim mappings. The managed setting
`set clipboard=unnamed` shares Vim yanks/deletes and `p`/`P` with the system
clipboard, including the macOS clipboard. Named registers retain their usual use.
Pressing `vv` from normal mode selects the whole line: the first `v` enters
visual mode, and the second switches to linewise selection, matching Neovim.

To check after restarting, yank a test line with `yy` and paste into another macOS
app with Cmd+V. Copy different text from that app with Cmd+C, then use `p` in
Obsidian normal mode. Also check Cmd+E focuses the explorer.

Future preference changes are not captured automatically: update the matching
JSON files here and reapply to each vault. Review settings before copying them
back into this public repository. Never copy workspace state, note paths, account
data, plugin data, or the global vault registry here.
