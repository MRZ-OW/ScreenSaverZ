#!/bin/sh

# Paths
CONF_TARGET="/etc/upstart/ss_fix.conf"
LOG_DIR="/mnt/us/extensions/ScreenSaverManager/logs"
LOG_FILE="$LOG_DIR/restore.log"

# Create the log directory
mkdir -p "$LOG_DIR"

{
    echo "=== Restoring ads $(date) ==="
    echo "Checking for the file..."

    # Check for root access via mntroot
    if ! /usr/sbin/mntroot rw >/dev/null 2>&1; then
        echo "❌ Error: Could not obtain root access!"
        exit 1
    fi

    # Check that the file exists
    if [ ! -f "$CONF_TARGET" ]; then
        echo "ℹ️ File $CONF_TARGET not found (already removed?)"
        /usr/sbin/mntroot ro >/dev/null 2>&1
        exit 0
    fi

    # Remove the file
    if rm -f "$CONF_TARGET"; then
        echo "✅ Successfully removed: $CONF_TARGET"

        # Reload the upstart configuration
        if initctl reload-configuration; then
            echo "♻️ Upstart configuration reloaded"
        else
            echo "⚠️ Could not reload upstart (but the file was removed)"
        fi
    else
        echo "❌ Critical error while removing!"
        exit 2
    fi

    # Restore FS protection
    /usr/sbin/mntroot ro >/dev/null 2>&1
    echo "🔒 Filesystem protected (ro)"
    echo "Done! Ads will come back after a reboot."

} 2>&1 | tee -a "$LOG_FILE" | showtxt

# Guaranteed reset of permissions
/usr/sbin/mntroot ro >/dev/null 2>&1
exit 0