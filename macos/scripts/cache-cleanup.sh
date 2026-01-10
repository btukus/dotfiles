#!/bin/bash
# Cache Cleanup - Weekly cleanup of caches and old logs
# Usage: ./cache-cleanup.sh install|uninstall|run

SELF='cache-cleanup'
FQPN=$(realpath "$0")
AGENT_PLIST="$HOME/Library/LaunchAgents/$SELF.plist"
LOG_DIR="$HOME/Library/Logs/dotfiles"
LOG_FILE="$LOG_DIR/$SELF.log"
INTERVAL=604800  # Weekly (7 days in seconds)

# Thresholds
CACHE_DAYS=7   # Delete caches older than 7 days
LOG_DAYS=30    # Delete logs older than 30 days

_run() {
    mkdir -p "$LOG_DIR"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Running cache cleanup..." >> "$LOG_FILE"

    TOTAL_FREED=0

    # Clean user caches (older than CACHE_DAYS)
    if [ -d "$HOME/Library/Caches" ]; then
        CACHE_SIZE_BEFORE=$(du -sk "$HOME/Library/Caches" 2>/dev/null | cut -f1)
        find "$HOME/Library/Caches" -type f -mtime +$CACHE_DAYS -delete 2>/dev/null
        find "$HOME/Library/Caches" -type d -empty -delete 2>/dev/null
        CACHE_SIZE_AFTER=$(du -sk "$HOME/Library/Caches" 2>/dev/null | cut -f1)
        CACHE_FREED=$((CACHE_SIZE_BEFORE - CACHE_SIZE_AFTER))
        TOTAL_FREED=$((TOTAL_FREED + CACHE_FREED))
        echo "  Caches: freed ${CACHE_FREED}KB" >> "$LOG_FILE"
    fi

    # Clean user logs (older than LOG_DAYS)
    if [ -d "$HOME/Library/Logs" ]; then
        LOG_SIZE_BEFORE=$(du -sk "$HOME/Library/Logs" 2>/dev/null | cut -f1)
        find "$HOME/Library/Logs" -type f -mtime +$LOG_DAYS -delete 2>/dev/null
        find "$HOME/Library/Logs" -type d -empty -delete 2>/dev/null
        LOG_SIZE_AFTER=$(du -sk "$HOME/Library/Logs" 2>/dev/null | cut -f1)
        LOG_FREED=$((LOG_SIZE_BEFORE - LOG_SIZE_AFTER))
        TOTAL_FREED=$((TOTAL_FREED + LOG_FREED))
        echo "  Logs: freed ${LOG_FREED}KB" >> "$LOG_FILE"
    fi

    # Run brew cleanup
    if command -v brew &> /dev/null; then
        BREW_OUTPUT=$(brew cleanup --prune=$CACHE_DAYS 2>&1)
        echo "  Homebrew: $BREW_OUTPUT" >> "$LOG_FILE"
    fi

    # Convert to MB for display
    TOTAL_MB=$((TOTAL_FREED / 1024))
    echo "Total freed: ${TOTAL_MB}MB" >> "$LOG_FILE"
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
$SELF - Weekly cache and log cleanup

Usage: ${0##*/} [command]

Commands:
    install     Install LaunchAgent for weekly runs
    uninstall   Remove LaunchAgent
    run         Run cleanup now (default)
    status      Check if LaunchAgent is installed

Cleans:
    - ~/Library/Caches/* (files older than $CACHE_DAYS days)
    - ~/Library/Logs/* (files older than $LOG_DAYS days)
    - Homebrew cache (brew cleanup --prune=$CACHE_DAYS)

Log file: $LOG_FILE
EOF
        ;;
    *)
        echo "Unknown command: $1" >&2
        echo "Usage: ${0##*/} install|uninstall|run|status" >&2
        exit 1
        ;;
esac
