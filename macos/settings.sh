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
# Logitech MX Keys Mini — key "1133-45929-0" (0x46d / 0xb369). Its bottom-left corner is
# already a real Left Control, and the Logitech fn is firmware-handled (unmappable), so we
# only turn Caps Lock into Escape and leave Left Control as Control.
#   Caps Lock -> Escape

# One-time cleanup of the previous hidutil/LaunchAgent approach (older installs)
KEYMAP_PLIST="$HOME/Library/LaunchAgents/com.user.keyremap.plist"
if [ -f "$KEYMAP_PLIST" ]; then
    echo "Removing old keyboard remap LaunchAgent..."
    launchctl unload "$KEYMAP_PLIST" 2>/dev/null || true
    rm -f "$KEYMAP_PLIST"
    # Drop the stale session-wide hidutil mapping so it stops overriding the preference
    hidutil property --set '{"UserKeyMapping":[]}' >/dev/null 2>&1 || true
fi

INTERNAL_KEY="com.apple.keyboard.modifiermapping.0-0-0"
MXMINI_KEY="com.apple.keyboard.modifiermapping.1133-45929-0"

# Idempotency: compare the whole stored array (whitespace-stripped) to what we intend to
# write. `defaults` reads dict keys back alphabetically (Dst before Src), so these canonical
# strings match its output exactly once our value is in place.
INTERNAL_WANT='({HIDKeyboardModifierMappingDst=30064771113;HIDKeyboardModifierMappingSrc=30064771129;},{HIDKeyboardModifierMappingDst=30064771129;HIDKeyboardModifierMappingSrc=30064771296;},{HIDKeyboardModifierMappingDst=30064771296;HIDKeyboardModifierMappingSrc=1095216660483;})'
MXMINI_WANT='({HIDKeyboardModifierMappingDst=30064771113;HIDKeyboardModifierMappingSrc=30064771129;})'

# Built-in keyboard: Caps->Esc, Ctrl->Caps, fn->Ctrl
if [ "$(defaults -currentHost read -g "$INTERNAL_KEY" 2>/dev/null | tr -d ' \n')" != "$INTERNAL_WANT" ]; then
    echo "Setting built-in keyboard remap (Caps->Esc, Ctrl->Caps, fn->Ctrl)..."
    defaults -currentHost write -g "$INTERNAL_KEY" -array \
        '{HIDKeyboardModifierMappingSrc=30064771129;HIDKeyboardModifierMappingDst=30064771113;}' \
        '{HIDKeyboardModifierMappingSrc=30064771296;HIDKeyboardModifierMappingDst=30064771129;}' \
        '{HIDKeyboardModifierMappingSrc=1095216660483;HIDKeyboardModifierMappingDst=30064771296;}'
fi

# MX Keys Mini: Caps->Esc only (Left Control stays Control)
if [ "$(defaults -currentHost read -g "$MXMINI_KEY" 2>/dev/null | tr -d ' \n')" != "$MXMINI_WANT" ]; then
    echo "Setting MX Keys Mini remap (Caps->Esc only)..."
    defaults -currentHost write -g "$MXMINI_KEY" -array \
        '{HIDKeyboardModifierMappingSrc=30064771129;HIDKeyboardModifierMappingDst=30064771113;}'
fi

# The preferences above are the durable, native part. macOS applies them on next login /
# keyboard reconnect. Apply once to the current session too (session-only, no daemon) so
# the remap takes effect immediately without logging out. Absent keyboards are skipped.
hidutil property --matching '{"Product":"Apple Internal Keyboard / Trackpad"}' \
    --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029},{"HIDKeyboardModifierMappingSrc":0x7000000E0,"HIDKeyboardModifierMappingDst":0x700000039},{"HIDKeyboardModifierMappingSrc":0xFF00000003,"HIDKeyboardModifierMappingDst":0x7000000E0}]}' >/dev/null 2>&1 || true
hidutil property --matching '{"VendorID":0x46d,"ProductID":0xb369}' \
    --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029}]}' >/dev/null 2>&1 || true

# MX Master 3s Bluetooth fix (requires sudo)
CURRENT_BT=$(sudo defaults read /Library/Preferences/com.apple.airport.bt.plist bluetoothCoexMgmt 2>/dev/null || echo "")
if [ "$CURRENT_BT" != "Hybrid" ]; then
    echo "Applying Bluetooth fix for MX Master 3s..."
    sudo defaults write /Library/Preferences/com.apple.airport.bt.plist bluetoothCoexMgmt Hybrid
fi

echo "macOS settings applied."
