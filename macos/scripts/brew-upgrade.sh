#!/bin/bash
# Brew Upgrade - Daily automatic brew update and upgrade
# Usage: ./brew-upgrade.sh install|uninstall|run

SELF='brew-upgrade'
FQPN=$(realpath "$0")
AGENT_PLIST="$HOME/Library/LaunchAgents/$SELF.plist"
LOG_DIR="$HOME/Library/Logs/dotfiles"
LOG_FILE="$LOG_DIR/$SELF.log"
INTERVAL=86400  # Daily (24 hours in seconds)

_run() {
    mkdir -p "$LOG_DIR"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Running brew upgrade..." >> "$LOG_FILE"

    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found" >> "$LOG_FILE"
        return 1
    fi

    # Update brew
    echo "Updating Homebrew..." >> "$LOG_FILE"
    brew update >> "$LOG_FILE" 2>&1

    # Upgrade all packages
    echo "Upgrading packages..." >> "$LOG_FILE"
    brew upgrade >> "$LOG_FILE" 2>&1

    # Cleanup old versions
    echo "Cleaning up..." >> "$LOG_FILE"
    brew cleanup >> "$LOG_FILE" 2>&1

    echo "Done." >> "$LOG_FILE"
    echo "---" >> "$LOG_FILE"
}

_install() {
    _uninstall &>/dev/null

    mkdir -p "$HOME/Library/LaunchAgents"
    mkdir -p "$LOG_DIR"

    cat > "$AGENT_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$SELF.agent</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>--norc</string>
        <string>--noprofile</string>
        <string>$FQPN</string>
        <string>run</string>
    </array>
    <key>StandardErrorPath</key>
    <string>$LOG_DIR/$SELF.stderr</string>
    <key>StandardOutPath</key>
    <string>$LOG_DIR/$SELF.stdout</string>
    <key>StartInterval</key>
    <integer>$INTERVAL</integer>
    <key>WorkingDirectory</key>
    <string>/tmp</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
    </dict>
</dict>
</plist>
EOF

    chmod 644 "$AGENT_PLIST"

    if launchctl bootstrap gui/$UID "$AGENT_PLIST" 2>/dev/null; then
        echo "Installed $SELF LaunchAgent (runs daily)"
        echo "Log file: $LOG_FILE"
    else
        echo "Failed to install LaunchAgent" >&2
        return 1
    fi
}

_uninstall() {
    launchctl bootout gui/$UID "$AGENT_PLIST" 2>/dev/null
    rm -f "$AGENT_PLIST"
    echo "Uninstalled $SELF LaunchAgent"
}

_status() {
    if launchctl list | grep -q "$SELF"; then
        echo "$SELF is installed and running"
        echo "Log file: $LOG_FILE"
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
$SELF - Daily Homebrew update and upgrade

Usage: ${0##*/} [command]

Commands:
    install     Install LaunchAgent for daily runs
    uninstall   Remove LaunchAgent
    run         Run upgrade now (default)
    status      Check if LaunchAgent is installed

Actions:
    - brew update
    - brew upgrade
    - brew cleanup

Log file: $LOG_FILE
EOF
        ;;
    *)
        echo "Unknown command: $1" >&2
        echo "Usage: ${0##*/} install|uninstall|run|status" >&2
        exit 1
        ;;
esac
