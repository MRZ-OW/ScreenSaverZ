#!/bin/sh
# 
SCREENS_DIR="/mnt/us/extensions/ScreenSaverManager/screens"
SYSTEM_SCREENSAVER_DIR="/usr/share/blanket/screensaver"

echo "=== Replacing screensavers ==="
mntroot rw

#
echo "Removing old screensavers..."
find "$SYSTEM_SCREENSAVER_DIR" -name "bg_ss*.png" -type f -delete

#
echo "Copying new ones from $SCREENS_DIR..."
cp -f "$SCREENS_DIR"/bg_ss*.png "$SYSTEM_SCREENSAVER_DIR"/

#
echo "Setting permissions..."
chmod 644 "$SYSTEM_SCREENSAVER_DIR"/*.png
mntroot ro

#
echo "Refreshing system..."
lipc-set-prop com.lab126.powerd refreshScreenSaver 1

#
COUNT=$(ls "$SYSTEM_SCREENSAVER_DIR"/bg_ss*.png 2>/dev/null | wc -l)
echo "Done! Updated $COUNT files."
eips 30 30 "Screensavers replaced ($COUNT)"
eips 30 50 "Please reboot your Kindle"
