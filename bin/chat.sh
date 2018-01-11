#!/bin/sh

# start terminal, ssh to nohostname and attach tmux session
xfce4-terminal.wrapper -e ssh feckert@nohostname.de -t tmux attach -t weechat
# wait a little bit for the terminal to start
sleep 0.50
# move window to i3 scratchpad, show scratchpad, resize and move window
i3-msg move scratchpad, scratchpad show, resize set 1000 800, move position center
