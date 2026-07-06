#!/bin/sh

# Paths (make sure they are correct!)
CONF_SOURCE="/mnt/us/extensions/ScreenSaverManager/bin/ss_fix.conf"
CONF_TARGET="/etc/upstart/ss_fix.conf"
LOG_FILE="/mnt/us/extensions/ScreenSaverManager/logs/install.log"

# Create the log directory
mkdir -p "$(dirname "$LOG_FILE")"

# Check that the source file exists
if [ ! -f "$CONF_SOURCE" ]; then
  echo "❌ Error: $CONF_SOURCE not found!" | tee -a "$LOG_FILE"
  exit 1
fi

# Enable writing to rootfs
/usr/sbin/mntroot rw >/dev/null 2>&1

# Copy with verification
if cp "$CONF_SOURCE" "$CONF_TARGET"; then
  chmod 644 "$CONF_TARGET"
  echo "✅ Successfully copied to $CONF_TARGET" | tee -a "$LOG_FILE"
else
  echo "❌ Copy failed (code $?)" | tee -a "$LOG_FILE"
  /usr/sbin/mntroot ro >/dev/null 2>&1
  exit 2
fi

# Restore rootfs protection
/usr/sbin/mntroot ro >/dev/null 2>&1
echo "Done! Please reboot your device." | tee -a "$LOG_FILE"