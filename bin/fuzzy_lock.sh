#!/bin/sh -e

# Take a screenshot
scrot /tmp/screen_locked.png

# Blur the screenshot
mogrify -blur 0x03 /tmp/screen_locked.png

# Lock screen displaying this image.
i3lock -i /tmp/screen_locked.png

# Turn the screen off after a delay.
#sleep 60; pgrep i3lock && xset dpms force off
