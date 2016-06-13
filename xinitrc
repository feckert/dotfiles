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
#xset +fp $HOME/.fonts
xset b off
#xset s noblank
#xset s 300 5
#xset dpms 0 0 600

### set background and start eyecandy
#setroot --restore
#xsetroot -solid darkgray
#xsetroot -solid '#444444'
#xsetroot -bg '#666666' -fg '#333333' -mod 2 2
#compton -b --inactive-dim 0.15 --sw-opti # dim unfocused windows
#compton -b -c -r 7 -o 0.6 -l -11 -t -8 # regular shadows
#compton -b -c -r 3 -o 1.0 -l -5 -t -4 # minimal shadows
#xsnow -norudolf -nosanta -notrees &

### launch terminal, filemanager daemons and conky
#urxvtd -q -f -o; sleep 2
#thunar --daemon &

# set display view (WORKi)
if [ $(hostname) = "dev-feckert" ] ; then
	xrandr --output HDMI1 --mode 1920x1200
	xrandr --output HDMI3 --mode 1920x1200 --right-of HDMI1
fi

# execute ssh-agent
eval $(ssh-agent)

# execute window manager
exec $(cat $HOME/.config/.wm)
