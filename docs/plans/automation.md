# Brew Upgrade & Maintenance Automation

## Summary
Three automated maintenance tasks via LaunchAgents:
1. `brew upgrade` - daily (24 hours)
2. `brew doctor` - weekly health check
3. Cache cleanup - weekly cleanup of caches and old logs

---

## Scripts

All scripts are in `macos/scripts/` and support: `install|uninstall|run|status`

| Script | Interval | What it does |
|--------|----------|--------------|
| `brew-upgrade.sh` | Daily | `brew update && brew upgrade && brew cleanup` |
| `brew-doctor.sh` | Weekly | Runs `brew doctor`, notifies if issues found |
| `cache-cleanup.sh` | Weekly | Cleans old caches/logs, runs `brew cleanup` |

---

## Installation

```bash
# Install all three
./macos/scripts/brew-upgrade.sh install
./macos/scripts/brew-doctor.sh install
./macos/scripts/cache-cleanup.sh install
```

## Check Status

```bash
./macos/scripts/brew-upgrade.sh status
./macos/scripts/brew-doctor.sh status
./macos/scripts/cache-cleanup.sh status
```

## Logs

- `/tmp/brew-upgrade.log`
- `/tmp/brew-doctor.log`
- `/tmp/cache-cleanup.log`

## Uninstall

```bash
./macos/scripts/brew-upgrade.sh uninstall
./macos/scripts/brew-doctor.sh uninstall
./macos/scripts/cache-cleanup.sh uninstall
```
