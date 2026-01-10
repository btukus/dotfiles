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

# MX Master 3s Bluetooth fix (requires sudo)
CURRENT_BT=$(sudo defaults read /Library/Preferences/com.apple.airport.bt.plist bluetoothCoexMgmt 2>/dev/null || echo "")
if [ "$CURRENT_BT" != "Hybrid" ]; then
    echo "Applying Bluetooth fix for MX Master 3s..."
    sudo defaults write /Library/Preferences/com.apple.airport.bt.plist bluetoothCoexMgmt Hybrid
fi

# Homebrew auto-upgrade (every 24 hours)
if command -v brew &> /dev/null; then
    if ! brew autoupdate status 2>/dev/null | grep -q "installed and running"; then
        echo "Setting up Homebrew auto-upgrade..."
        brew autoupdate start 86400 --upgrade --cleanup
    fi
fi

echo "macOS settings applied."
