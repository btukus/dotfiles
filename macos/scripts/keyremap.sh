#!/bin/bash
# keyremap - Per-keyboard modifier remaps via the native macOS mechanism, plus a
# launchd agent that re-applies them on login and whenever a keyboard connects.
# Usage: ./keyremap.sh install|uninstall|run|status
#
# Why this exists: macOS stores per-keyboard remaps in the native preference
#   com.apple.keyboard.modifiermapping.<vendor>-<product>-<country>   (ByHost / -currentHost)
# — the same store System Settings > Keyboard > Modifier Keys writes. It persists across
# reboots, but macOS only *applies* it at login; it does NOT re-read it when a keyboard
# reconnects mid-session (Bluetooth wake/reconnect, Logi Bolt, hot-plug). So we also apply
# it to the current session with hidutil, driven by a launchd agent that fires on every
# keyboard-connect IOKit event. The agent just runs this script's `run` and exits — no
# persistent process, no polling.
#
# Layout notes:
#   - Built-in MacBook keyboard is key "0-0-0" (Apple internal reports vendor/product/country
#     0 on Apple Silicon). We rotate three keys so the bottom-left corner (fn) becomes Control.
#   - A Logi Bolt / Unifying receiver enumerates as the RECEIVER, not the keyboard
#     (e.g. MX Mechanical Mini shows up as 1133-50504 "USB Receiver"), so external keyboards
#     are discovered at runtime rather than hardcoded.
#
# HID usage codes:
#   Caps Lock    0x700000039 = 30064771129     Escape       0x700000029 = 30064771113
#   Left Control 0x7000000E0 = 30064771296      fn/Globe    0xFF00000003 = 1095216660483

SELF='keyremap'
FQPN=$(realpath "$0")
AGENT_PLIST="$HOME/Library/LaunchAgents/$SELF.plist"
LOG_DIR="$HOME/Library/Logs/dotfiles"
LOG_FILE="$LOG_DIR/$SELF.log"

# Built-in keyboard: Caps->Esc, Ctrl->Caps, fn->Ctrl
INTERNAL_KEY='com.apple.keyboard.modifiermapping.0-0-0'
INTERNAL_WANT='({HIDKeyboardModifierMappingDst=30064771113;HIDKeyboardModifierMappingSrc=30064771129;},{HIDKeyboardModifierMappingDst=30064771129;HIDKeyboardModifierMappingSrc=30064771296;},{HIDKeyboardModifierMappingDst=30064771296;HIDKeyboardModifierMappingSrc=1095216660483;})'
INTERNAL_HID='{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029},{"HIDKeyboardModifierMappingSrc":0x7000000E0,"HIDKeyboardModifierMappingDst":0x700000039},{"HIDKeyboardModifierMappingSrc":0xFF00000003,"HIDKeyboardModifierMappingDst":0x7000000E0}]}'

# External keyboards: Caps->Esc only (bottom-left is already a real Left Control)
EXTERNAL_WANT='({HIDKeyboardModifierMappingDst=30064771113;HIDKeyboardModifierMappingSrc=30064771129;})'
CAPS_TO_ESC_HID='{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029}]}'

# Known external keyboard IDs, seeded so a fresh machine (or next login) is configured even
# while they're disconnected. Any other connected keyboard is discovered automatically.
#   1133-45929  MX Keys Mini (Bluetooth)
#   1133-50504  Logi Bolt receiver (MX Mechanical Mini and friends)
KNOWN_EXTERNAL='1133-45929-0 1133-50504-0'

# Write the ByHost preference for one external keyboard id (vid-pid-0) if it differs.
_ensure_external_pref() {
    local key="com.apple.keyboard.modifiermapping.$1"
    if [ "$(defaults -currentHost read -g "$key" 2>/dev/null | tr -d ' \n')" != "$EXTERNAL_WANT" ]; then
        defaults -currentHost write -g "$key" -array \
            '{HIDKeyboardModifierMappingSrc=30064771129;HIDKeyboardModifierMappingDst=30064771113;}'
        echo "$(date '+%F %T') wrote pref $key" >> "$LOG_FILE"
    fi
}

_run() {
    mkdir -p "$LOG_DIR"
    echo "$(date '+%F %T') applying keyboard remaps" >> "$LOG_FILE"

    # Built-in: durable preference + current session
    if [ "$(defaults -currentHost read -g "$INTERNAL_KEY" 2>/dev/null | tr -d ' \n')" != "$INTERNAL_WANT" ]; then
        defaults -currentHost write -g "$INTERNAL_KEY" -array \
            '{HIDKeyboardModifierMappingSrc=30064771129;HIDKeyboardModifierMappingDst=30064771113;}' \
            '{HIDKeyboardModifierMappingSrc=30064771296;HIDKeyboardModifierMappingDst=30064771129;}' \
            '{HIDKeyboardModifierMappingSrc=1095216660483;HIDKeyboardModifierMappingDst=30064771296;}'
        echo "$(date '+%F %T') wrote pref $INTERNAL_KEY" >> "$LOG_FILE"
    fi
    hidutil property --matching '{"Product":"Apple Internal Keyboard / Trackpad"}' \
        --set "$INTERNAL_HID" >/dev/null 2>&1 || true

    # Seed known external keyboards' preferences even if disconnected
    local ids="$KNOWN_EXTERNAL"

    # Discover connected external keyboards (skip vid/pid 0 = built-in) and apply to session
    local vid pid
    while read -r vid pid; do
        [ -n "$pid" ] || continue
        ids="$ids $((vid))-$((pid))-0"
        hidutil property --matching "{\"VendorID\":$((vid)),\"ProductID\":$((pid))}" \
            --set "$CAPS_TO_ESC_HID" >/dev/null 2>&1 || true
    done <<EOF
$(hidutil list --matching '{"PrimaryUsagePage":1,"PrimaryUsage":6}' 2>/dev/null \
    | awk '$1 ~ /^0x[0-9a-fA-F]+$/ && $1 != "0x0" { print $1, $2 }' | sort -u)
EOF

    # Write the durable preference for every id (known + connected), de-duplicated
    local id
    for id in $(printf '%s\n' $ids | sort -u); do
        _ensure_external_pref "$id"
    done
}

_install() {
    _uninstall &>/dev/null

    mkdir -p "$HOME/Library/LaunchAgents"
    mkdir -p "$LOG_DIR"

    # RunAtLoad covers login; the com.apple.iokit.matching LaunchEvents fires the agent
    # whenever a HID keyboard interface is attached (Bluetooth reconnect, Bolt, USB hot-plug).
    cat > "$AGENT_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$SELF</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>--norc</string>
        <string>--noprofile</string>
        <string>$FQPN</string>
        <string>run</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>LaunchEvents</key>
    <dict>
        <key>com.apple.iokit.matching</key>
        <dict>
            <key>$SELF-keyboard-attach</key>
            <dict>
                <key>IOMatchLaunchStream</key>
                <true/>
                <key>IOProviderClass</key>
                <string>IOHIDInterface</string>
                <key>PrimaryUsagePage</key>
                <integer>1</integer>
                <key>PrimaryUsage</key>
                <integer>6</integer>
            </dict>
        </dict>
    </dict>
    <key>StandardErrorPath</key>
    <string>$LOG_DIR/$SELF.stderr</string>
    <key>StandardOutPath</key>
    <string>$LOG_DIR/$SELF.stdout</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/bin:/bin:/usr/sbin:/sbin</string>
    </dict>
</dict>
</plist>
EOF

    chmod 644 "$AGENT_PLIST"

    if launchctl bootstrap gui/$UID "$AGENT_PLIST" 2>/dev/null; then
        echo "Installed $SELF LaunchAgent (login + on keyboard connect)"
    else
        echo "Failed to install $SELF LaunchAgent" >&2
        return 1
    fi
}

_uninstall() {
    launchctl bootout gui/$UID "$AGENT_PLIST" 2>/dev/null
    rm -f "$AGENT_PLIST"
    # Also clean up the pre-2026 label if present
    launchctl bootout gui/$UID "$HOME/Library/LaunchAgents/com.user.keyremap.plist" 2>/dev/null
    rm -f "$HOME/Library/LaunchAgents/com.user.keyremap.plist"
    echo "Uninstalled $SELF LaunchAgent"
}

_status() {
    if launchctl list | grep -q "$SELF"; then
        echo "$SELF is installed"
    else
        echo "$SELF is not installed"
    fi
}

case "${1:-run}" in
    install)   _install ;;
    uninstall) _uninstall ;;
    run)       _run ;;
    status)    _status ;;
    -h|--help)
        cat <<EOF
$SELF - per-keyboard modifier remaps (Caps->Esc etc.) via the native macOS mechanism

Usage: ${0##*/} [command]

Commands:
    install     Write preferences + install the login/on-connect LaunchAgent
    uninstall   Remove the LaunchAgent
    run         Apply remaps now (preferences + current session) (default)
    status      Check if the LaunchAgent is installed

Log file: $LOG_FILE
EOF
        ;;
    *)
        echo "Unknown command: $1" >&2
        echo "Usage: ${0##*/} install|uninstall|run|status" >&2
        exit 1
        ;;
esac
