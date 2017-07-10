#!/bin/sh

irc="weechat"

if tmux has-session -t "${irc}"; then
	echo "To stop ${irc} session, use: ./${irc}-stop.sh"
	echo "To deattach from ${irc} session, press Ctrl+B-D"
	echo "Attach to session $irc"
	tmux attach -t ${irc}
else
	echo "$irc session has not been started"
	echo "To start $irc session, use: ./${irc}-start.sh"
fi
