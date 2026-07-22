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

# Keyboard modifier remaps — applied PER KEYBOARD via the NATIVE macOS mechanism
# (the same per-device preference System Settings > Keyboard > Modifier Keys writes).
# macOS reads com.apple.keyboard.modifiermapping.<vendor>-<product>-<country> (in the
# ByHost / -currentHost global domain) whenever a keyboard connects, so this persists
# across reboots and reapplies on Bluetooth reconnect with NO daemon and NO LaunchAgent.
#
# HID usage codes:  Caps Lock 0x700000039 = 30064771129,  Escape 0x700000029 = 30064771113,
#                   Left Control 0x7000000E0 = 30064771296,  fn/Globe 0xFF00000003 = 1095216660483
#
# Built-in MacBook keyboard — key "0-0-0" (Apple internal keyboard reports vendor 0 /
# product 0 / country 0 on Apple Silicon). Three-key rotation so the bottom-left corner
# key (fn) becomes Control:
#   Caps Lock -> Escape,  Left Control -> Caps Lock,  fn/Globe -> Left Control
#
# Every EXTERNAL keyboard — its bottom-left corner is already a real Left Control, and a
# Logitech fn is firmware-handled (unmappable), so we only turn Caps Lock into Escape and
# leave Left Control alone:
#   Caps Lock -> Escape
# External keyboards are discovered at runtime, so any keyboard works without editing this
# script. Note that a Logi Bolt / Unifying receiver enumerates as the RECEIVER, not the
# keyboard (e.g. MX Mechanical Mini shows up as 1133-50504 "USB Receiver"), which is why
# hardcoding individual keyboard IDs is unreliable.

# One-time cleanup of the previous hidutil/LaunchAgent approach (older installs)
KEYMAP_PLIST="$HOME/Library/LaunchAgents/com.user.keyremap.plist"
if [ -f "$KEYMAP_PLIST" ]; then
    echo "Removing old keyboard remap LaunchAgent..."
    launchctl unload "$KEYMAP_PLIST" 2>/dev/null || true
    rm -f "$KEYMAP_PLIST"
fi

# Idempotency: compare the whole stored array (whitespace-stripped) to what we intend to
# write. `defaults` reads dict keys back alphabetically (Dst before Src), so these canonical
# strings match its output exactly once our value is in place.
INTERNAL_KEY="com.apple.keyboard.modifiermapping.0-0-0"
INTERNAL_WANT='({HIDKeyboardModifierMappingDst=30064771113;HIDKeyboardModifierMappingSrc=30064771129;},{HIDKeyboardModifierMappingDst=30064771129;HIDKeyboardModifierMappingSrc=30064771296;},{HIDKeyboardModifierMappingDst=30064771296;HIDKeyboardModifierMappingSrc=1095216660483;})'
EXTERNAL_WANT='({HIDKeyboardModifierMappingDst=30064771113;HIDKeyboardModifierMappingSrc=30064771129;})'

CAPS_TO_ESC_HID='{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029}]}'
INTERNAL_HID='{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029},{"HIDKeyboardModifierMappingSrc":0x7000000E0,"HIDKeyboardModifierMappingDst":0x700000039},{"HIDKeyboardModifierMappingSrc":0xFF00000003,"HIDKeyboardModifierMappingDst":0x7000000E0}]}'

# Built-in keyboard: Caps->Esc, Ctrl->Caps, fn->Ctrl
if [ "$(defaults -currentHost read -g "$INTERNAL_KEY" 2>/dev/null | tr -d ' \n')" != "$INTERNAL_WANT" ]; then
    echo "Setting built-in keyboard remap (Caps->Esc, Ctrl->Caps, fn->Ctrl)..."
    defaults -currentHost write -g "$INTERNAL_KEY" -array \
        '{HIDKeyboardModifierMappingSrc=30064771129;HIDKeyboardModifierMappingDst=30064771113;}' \
        '{HIDKeyboardModifierMappingSrc=30064771296;HIDKeyboardModifierMappingDst=30064771129;}' \
        '{HIDKeyboardModifierMappingSrc=1095216660483;HIDKeyboardModifierMappingDst=30064771296;}'
fi
# Apply to the current session too (session-only, no daemon) so it takes effect without
# logging out. The preference above is what actually persists.
hidutil property --matching '{"Product":"Apple Internal Keyboard / Trackpad"}' \
    --set "$INTERNAL_HID" >/dev/null 2>&1 || true

# Known external keyboards, kept so a fresh machine is configured even while they're
# disconnected. Any other currently-connected external keyboard is picked up automatically.
#   1133-45929  MX Keys Mini (Bluetooth)
#   1133-50504  Logi Bolt receiver (MX Mechanical Mini and friends)
EXTERNAL_IDS="1133-45929-0 1133-50504-0"
CONNECTED=$(hidutil list --matching '{"PrimaryUsagePage":1,"PrimaryUsage":6}' 2>/dev/null \
    | awk '$1 ~ /^0x[0-9a-fA-F]+$/ && $1 != "0x0" { print $1, $2 }' | sort -u)

while read -r vid pid; do
    [ -n "$pid" ] || continue
    EXTERNAL_IDS="$EXTERNAL_IDS $((vid))-$((pid))-0"
    # Apply to the current session for this connected keyboard
    hidutil property --matching "{\"VendorID\":$((vid)),\"ProductID\":$((pid))}" \
        --set "$CAPS_TO_ESC_HID" >/dev/null 2>&1 || true
done <<EOF
$CONNECTED
EOF

# External keyboards: Caps->Esc only (Left Control stays Control)
for id in $(printf '%s\n' $EXTERNAL_IDS | sort -u); do
    key="com.apple.keyboard.modifiermapping.$id"
    if [ "$(defaults -currentHost read -g "$key" 2>/dev/null | tr -d ' \n')" != "$EXTERNAL_WANT" ]; then
        echo "Setting external keyboard $id remap (Caps->Esc)..."
        defaults -currentHost write -g "$key" -array \
            '{HIDKeyboardModifierMappingSrc=30064771129;HIDKeyboardModifierMappingDst=30064771113;}'
    fi
done

# MX Master 3s Bluetooth fix (requires sudo)
CURRENT_BT=$(sudo defaults read /Library/Preferences/com.apple.airport.bt.plist bluetoothCoexMgmt 2>/dev/null || echo "")
if [ "$CURRENT_BT" != "Hybrid" ]; then
    echo "Applying Bluetooth fix for MX Master 3s..."
    sudo defaults write /Library/Preferences/com.apple.airport.bt.plist bluetoothCoexMgmt Hybrid
fi

echo "macOS settings applied."
