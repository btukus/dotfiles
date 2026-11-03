#!/bin/bash
# macOS settings - idempotent (only changes if needed)

CHANGED=0

# Dock auto-hide
if [ "$(defaults read com.apple.dock autohide 2>/dev/null)" != "1" ]; then
    echo "Enabling dock auto-hide..."
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock autohide-time-modifier -float 0
    CHANGED=1
fi

# Finder quit menu
if [ "$(defaults read com.apple.finder QuitMenuItem 2>/dev/null)" != "1" ]; then
    echo "Enabling Finder quit menu..."
    defaults write com.apple.finder QuitMenuItem -bool true
    killall Finder
fi

# Restart Dock only if changed
if [ "$CHANGED" = "1" ]; then
    killall Dock
fi

# Disable press-and-hold for keys
if [ "$(defaults read -g ApplePressAndHoldEnabled 2>/dev/null)" != "0" ]; then
    echo "Disabling press-and-hold for keys..."
    defaults write -g ApplePressAndHoldEnabled -bool false
fi

# Keyboard modifier remaps (Caps->Esc, built-in rotation) are handled by keyremap.sh,
# which writes the native per-keyboard preferences AND installs a launchd agent that
# re-applies them at login and on every keyboard-connect event (Bluetooth reconnect / wake,
# Logi Bolt, USB hot-plug). See that script's header for the full rationale.
# Resolve keyremap.sh next to this script when possible, else fall back to ~/dotfiles
# (Ansible's script module runs settings.sh from a temp dir, so the sibling path may miss).
KEYREMAP="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)/scripts/keyremap.sh"
[ -x "$KEYREMAP" ] || KEYREMAP="$HOME/dotfiles/macos/scripts/keyremap.sh"
if [ -x "$KEYREMAP" ]; then
    "$KEYREMAP" install || exit 1
    "$KEYREMAP" run || exit 1
else
    echo "Error: keyboard remap script not found: $KEYREMAP" >&2
    exit 1
fi

# MX Master 3s Bluetooth fix (requires sudo)
CURRENT_BT=$(defaults read /Library/Preferences/com.apple.airport.bt.plist bluetoothCoexMgmt 2>/dev/null || echo "")
if [ "$CURRENT_BT" != "Hybrid" ]; then
    echo "Applying Bluetooth fix for MX Master 3s..."
    if ! sudo -n defaults write /Library/Preferences/com.apple.airport.bt.plist bluetoothCoexMgmt Hybrid; then
        echo "Warning: Bluetooth fix needs administrator credentials. Run 'sudo -v && bash ~/dotfiles/macos/settings.sh' in your terminal to finish it." >&2
    fi
fi

echo "macOS settings applied."
