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

# Keyboard modifier remaps (three-key rotation):
#   Caps Lock    (0x700000039)  -> Escape       (0x700000029)
#   Left Control (0x7000000E0)  -> Caps Lock    (0x700000039)
#   fn/Globe     (0xFF00000003) -> Left Control (0x7000000E0)
# hidutil is session-only, so a LaunchAgent re-applies it at every login.
KEYMAP_LABEL="com.user.keyremap"
KEYMAP_PLIST="$HOME/Library/LaunchAgents/${KEYMAP_LABEL}.plist"
KEYMAP_MAPPING='{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029},{"HIDKeyboardModifierMappingSrc":0x7000000E0,"HIDKeyboardModifierMappingDst":0x700000039},{"HIDKeyboardModifierMappingSrc":0xFF00000003,"HIDKeyboardModifierMappingDst":0x7000000E0}]}'

# Apply now if the Left Control -> Caps Lock leg (src 30064771296) isn't active
if ! hidutil property --get UserKeyMapping 2>/dev/null | grep -q "MappingSrc = 30064771296"; then
    echo "Remapping keys (Caps->Esc, Ctrl->Caps, fn->Ctrl)..."
    hidutil property --set "$KEYMAP_MAPPING" >/dev/null
fi

# Install/refresh LaunchAgent for persistence across reboots
if ! grep -qF "$KEYMAP_MAPPING" "$KEYMAP_PLIST" 2>/dev/null; then
    echo "Installing keyboard remap LaunchAgent..."
    mkdir -p "$HOME/Library/LaunchAgents"
    launchctl unload "$KEYMAP_PLIST" 2>/dev/null || true
    cat > "$KEYMAP_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${KEYMAP_LABEL}</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/hidutil</string>
        <string>property</string>
        <string>--set</string>
        <string>${KEYMAP_MAPPING}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF
    launchctl load "$KEYMAP_PLIST" 2>/dev/null || true
fi

# MX Master 3s Bluetooth fix (requires sudo)
CURRENT_BT=$(sudo defaults read /Library/Preferences/com.apple.airport.bt.plist bluetoothCoexMgmt 2>/dev/null || echo "")
if [ "$CURRENT_BT" != "Hybrid" ]; then
    echo "Applying Bluetooth fix for MX Master 3s..."
    sudo defaults write /Library/Preferences/com.apple.airport.bt.plist bluetoothCoexMgmt Hybrid
fi

echo "macOS settings applied."
