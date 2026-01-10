#!/bin/bash
# Brew Doctor - Weekly health check with notification
# Usage: ./brew-doctor.sh install|uninstall|run

SELF='brew-doctor'
FQPN=$(realpath "$0")
AGENT_PLIST="$HOME/Library/LaunchAgents/$SELF.plist"
LOG_FILE="/tmp/$SELF.log"
INTERVAL=604800  # Weekly (7 days in seconds)

_notify() {
    local title="$1"
    local message="$2"
    osascript -e "display notification \"$message\" with title \"$title\""
}

_run() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Running brew doctor..." >> "$LOG_FILE"

    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found" >> "$LOG_FILE"
        return 1
    fi

    OUTPUT=$(brew doctor 2>&1)
    EXIT_CODE=$?

    echo "$OUTPUT" >> "$LOG_FILE"
    echo "Exit code: $EXIT_CODE" >> "$LOG_FILE"
    echo "---" >> "$LOG_FILE"

    if [ $EXIT_CODE -ne 0 ]; then
        ISSUE_COUNT=$(echo "$OUTPUT" | grep -c "Warning:")
        _notify "Brew Doctor" "Found $ISSUE_COUNT issue(s). Check $LOG_FILE"
    fi
}

_install() {
    _uninstall &>/dev/null

    mkdir -p "$HOME/Library/LaunchAgents"

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
    <string>/tmp/$SELF.stderr</string>
    <key>StandardOutPath</key>
    <string>/tmp/$SELF.stdout</string>
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
        echo "Installed $SELF LaunchAgent (runs weekly)"
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
        echo "Next run: check with 'launchctl list | grep $SELF'"
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
$SELF - Weekly Homebrew health check

Usage: ${0##*/} [command]

Commands:
    install     Install LaunchAgent for weekly runs
    uninstall   Remove LaunchAgent
    run         Run brew doctor now (default)
    status      Check if LaunchAgent is installed

Log file: $LOG_FILE
EOF
        ;;
    *)
        echo "Unknown command: $1" >&2
        echo "Usage: ${0##*/} install|uninstall|run|status" >&2
        exit 1
        ;;
esac
