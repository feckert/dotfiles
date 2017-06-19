#!/bin/sh

### execute global xinit files
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

### initialize X and environment
xrdb -load $HOME/.Xresources
xset b off

### execute ssh-agent
eval $(ssh-agent)

### execute window manager
exec $(cat $HOME/.config/.wm)
