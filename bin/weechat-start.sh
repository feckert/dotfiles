#!/bin/sh

irc="weechat"

if tmux has-session -t "${irc}"; then
	echo "${irc} is already running."
	echo "To stop ${irc} session, use: ./${irc}-stop.sh"
	echo "To attach to ${irc}, use: ./${irc}-attach.sh"
else
	tmux new-session -s "${irc}" "${irc}"
	echo "${irc} has been started in tmux session '${irc}'"
	echo "To attach to ${irc} session, use: ./${irc}-attach.sh"
	echo "To stop ${irc} session, use: ./${irc}-stop.sh"
	echo "To deattach from ${irc} session, press Ctrl+B-D"
fi
