#!/bin/sh

if tmux has-session -t 'irssi'; then
	echo "Irssi is already running."
	echo "To stop it use: ./irssi-stop.sh"
	echo "To attach to it use: tmux attach -t irssi"
else
	tmux new-session -s 'irssi' 'irssi'
	echo "irssi has been started in tmux session 'irssi'"
	echo "To attach to session, use: tmux attach -t irssi"
	echo "To deattach, press Ctrl+B-D"
	echo "To stop irssi, use: ./irssi-stop.sh"
fi
