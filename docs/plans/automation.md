# Brew Upgrade & Maintenance Automation Plan

## Summary
Set up three automated maintenance tasks:
1. `brew upgrade` - every 24 hours (via built-in `brew autoupdate`)
2. `brew doctor` - weekly health check
3. Cache cleanup - weekly cleanup of caches and old logs

---

## Implementation

### 1. Brew Auto-Upgrade (24 hours)
**Approach:** Use Homebrew's built-in `brew autoupdate` command.

**File to modify:** `macos/settings.sh`

Add:
```bash
# Homebrew auto-upgrade (every 24 hours)
if command -v brew &> /dev/null; then
    brew autoupdate start 86400 --upgrade --cleanup
fi
```

### 2. Brew Doctor (Weekly)
**Approach:** Create a LaunchAgent following the existing `screencapture-nag-remover.sh` pattern.

**New file:** `macos/scripts/brew-doctor.sh`

Features:
- LaunchAgent runs weekly (604800 seconds)
- Logs output to `/tmp/brew-doctor.log`
- Sends notification if issues found (using `osascript`)
- Install/uninstall functions for manual control

### 3. Cache Cleanup (Weekly)
**Approach:** Create a LaunchAgent for periodic cleanup.

**New file:** `macos/scripts/cache-cleanup.sh`

Cleans:
- `~/Library/Caches/*` - Application caches (older than 7 days)
- `~/Library/Logs/*` - Application logs (older than 30 days)
- Homebrew cache via `brew cleanup --prune=7`

Features:
- LaunchAgent runs weekly (604800 seconds)
- Logs cleanup summary to `/tmp/cache-cleanup.log`
- Safe: only removes files older than threshold
- Install/uninstall functions

---

## Files to Create/Modify

| File | Action |
|------|--------|
| `macos/scripts/` | New directory for automation scripts |
| `macos/settings.sh` | Add brew autoupdate command |
| `macos/scripts/brew-doctor.sh` | New - weekly brew doctor with notification |
| `macos/scripts/cache-cleanup.sh` | New - weekly cache cleanup |

---

## Script Structure (brew-doctor.sh and cache-cleanup.sh)

Following the existing `screencapture-nag-remover.sh` pattern:
- `install()` - Create plist and load LaunchAgent
- `uninstall()` - Unload and remove LaunchAgent
- `run()` - Execute the actual task
- CLI interface: `./script.sh install|uninstall|run`

---

## Integration

After creating the scripts, they can be:
1. Run manually: `./macos/scripts/brew-doctor.sh install`
2. Added to `macos/settings.sh` for bootstrap
3. Optionally added to an Ansible role

---

## Verification

1. **brew autoupdate:**
   ```bash
   brew autoupdate status
   launchctl list | grep homebrew
   ```

2. **brew doctor LaunchAgent:**
   ```bash
   launchctl list | grep brew-doctor
   cat /tmp/brew-doctor.log
   ```

3. **cache cleanup LaunchAgent:**
   ```bash
   launchctl list | grep cache-cleanup
   cat /tmp/cache-cleanup.log
   ```
