#!/bin/sh

irc="weechat"

if tmux has-session -t "${irc}" 2>/dev/null; then
	tmux kill-session -t ${irc} 2>/dev/null
	echo "${irc} has bin stopped"
else
	echo "${irc} is not running"
	echo "To start ${irc} session, use: ./${irc}-start.sh"
fi
