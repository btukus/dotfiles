# Atuin Integration Plan

## Overview
Integrate Atuin shell history with your dotfiles, including self-hosted sync on your Synology NAS.

## Critical Compatibility Note
You use `zsh-vi-mode` which has a **known conflict** with Atuin - it lazy-loads keybindings after `.zshrc`, overwriting Atuin's `ctrl-r` binding. This requires a specific workaround.

---

## Part 1: Client Setup (Dotfiles)

### 1.1 Add Atuin to Brewfile
**File:** `brew/Brewfile.macos`
```
brew "atuin"
```

### 1.2 Create Atuin init script
**File:** `zsh/source-scripts/atuin.zsh` (new file)
```zsh
# Atuin shell history
# Must use zvm_after_init due to zsh-vi-mode conflict
if command -v atuin &> /dev/null; then
  function _atuin_init() {
    eval "$(atuin init zsh --disable-up-arrow)"
  }
  zvm_after_init_commands+=(_atuin_init)
fi
```

The `--disable-up-arrow` flag is recommended to avoid conflicts with zsh-vi-mode's up arrow behavior.

### 1.3 Source the script in .zshrc
**File:** `zsh/.zshrc`

Add after `antidote.zsh` (which loads zsh-vi-mode):
```zsh
source "$ZDOTDIR/source-scripts/atuin.zsh"
```

### 1.4 Add Atuin config (optional, for self-hosted sync)
**File:** `config/.config/atuin/config.toml` (new file, stowed to `~/.config/atuin/`)
```toml
# Point to self-hosted server
sync_address = "https://atuin.yourdomain.com"  # Your Cloudflare Tunnel hostname

# Search settings
search_mode = "fuzzy"
filter_mode = "global"
style = "compact"

# Sync settings
auto_sync = true
sync_frequency = "5m"
```

---

## Part 2: Self-Hosted Server on Synology NAS

### Option A: Official Docker + PostgreSQL (Recommended)
More stable, officially supported.

Create on NAS at `/volume1/docker/atuin/docker-compose.yml`:
```yaml
version: '3.8'
services:
  atuin:
    image: ghcr.io/atuinsh/atuin:v18.4.0  # Use specific version
    restart: always
    command: server start
    ports:
      - "8888:8888"
    volumes:
      - "./config:/config"
    environment:
      ATUIN_HOST: "0.0.0.0"
      ATUIN_OPEN_REGISTRATION: "false"  # Set true initially to register
      ATUIN_DB_URI: "postgres://${ATUIN_DB_USERNAME}:${ATUIN_DB_PASSWORD}@db/${ATUIN_DB_NAME}"
    depends_on:
      - db

  db:
    image: postgres:14
    restart: always
    volumes:
      - "./database:/var/lib/postgresql/data/"
    environment:
      POSTGRES_USER: ${ATUIN_DB_USERNAME}
      POSTGRES_PASSWORD: ${ATUIN_DB_PASSWORD}
      POSTGRES_DB: ${ATUIN_DB_NAME}
```

Create `.env`:
```
ATUIN_DB_NAME=atuin
ATUIN_DB_USERNAME=atuin
ATUIN_DB_PASSWORD=<generate-strong-password>
```

### Option B: Unofficial SQLite (Lighter weight)
Uses less resources but unofficial. See: [atuin-server-sqlite](https://github.com/conradludgate/atuin-server-sqlite)

### Cloudflare Tunnel Setup
Since you're using Cloudflare Tunnel:

1. Create a new public hostname in your Cloudflare Zero Trust dashboard
2. Point it to `http://localhost:8888` (or the container's internal address)
3. Example: `atuin.yourdomain.com` -> Atuin server

The tunnel handles HTTPS automatically. Your `sync_address` will be `https://atuin.yourdomain.com`.

---

## Part 3: Initial Setup Commands (Post-implementation)

```bash
# Install atuin
brew bundle --file=brew/Brewfile.macos

# Restart shell
exec zsh

# Import existing history
atuin import auto

# Register with your server (once server is running)
atuin register -u <username> -e <email> -p <password>

# Or login if already registered
atuin login -u <username> -p <password>

# Sync
atuin sync
```

---

## Files to Modify/Create

| File | Action |
|------|--------|
| `brew/Brewfile.macos` | Add `brew "atuin"` |
| `zsh/source-scripts/atuin.zsh` | Create (init script with zvm workaround) |
| `zsh/.zshrc` | Add source line |
| `config/.config/atuin/config.toml` | Create (optional, for sync config) |

---

## Verification

1. After implementation, run `brew bundle` and restart shell
2. Press `ctrl-r` - should open Atuin's full-screen search UI
3. Run `atuin stats` - should show history statistics
4. After server setup: `atuin sync` should succeed

---

## Sources
- [Atuin Key Binding Docs](https://docs.atuin.sh/cli/configuration/key-binding/)
- [zsh-vi-mode conflict issue](https://github.com/atuinsh/atuin/issues/977)
- [Docker self-hosting](https://docs.atuin.sh/cli/self-hosting/docker/)
