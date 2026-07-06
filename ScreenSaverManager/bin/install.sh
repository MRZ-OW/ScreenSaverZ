#!/bin/sh
#
mkdir -p "/mnt/us/extensions/ScreenSaverManager/backup_screensavers"
cp /usr/share/blanket/screensaver/*.png /mnt/us/extensions/ScreenSaverManager/backup_screensavers/ 2>/dev/null
echo "Done! Add your PNG files to the screens/ folder."
