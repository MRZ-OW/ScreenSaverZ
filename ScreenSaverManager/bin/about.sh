#!/bin/sh

FBINK="/mnt/us/extensions/ScreenSaverManager/bin/fbink"

# Message
#TEXT1=""
#TEXT2=""
#TEXT3=""
#TEXT4=""
#TEXT5=""
#TEXT6=""

# Clear the screen
$FBINK -c

# Horizontal position (roughly centered)
X=5

# Top of the frame
$FBINK -x $X -y 20 "╔═════════════════════════════╗"
# Text inside the frame
$FBINK -x $X -y 21 "║     ScreenSaverManager      ║"
$FBINK -x $X -y 22 "║           Author:           ║"
$FBINK -x $X -y 23 "║         @Shalom_Kir         ║"
$FBINK -x $X -y 24 "║        @made_by_Kir         ║"
$FBINK -x $X -y 25 "║        Version: 2.1         ║"
$FBINK -x $X -y 26 "║   Release date 16.06.2025   ║"
# Bottom of the frame
$FBINK -x $X -y 27 "╚═════════════════════════════╝"

# Message below the frame
$FBINK -x $X -y 30 "╔═════════════════════════════╗"
$FBINK -x $X -y 31 "║<--------Click here          ║"
$FBINK -x $X -y 32 "║ or under the Author button  ║"
$FBINK -x $X -y 33 "╚═════════════════════════════╝"

# Wait loop (emulation, no Power button)
while true; do
    sleep 1
done
