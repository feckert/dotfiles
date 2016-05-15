#!/bin/sh

if tmux has-session -t 'irssi' 2>/dev/null; then
	tmux kill-session -t irssi 2>/dev/null
	echo "Irssi has bin stopped"
else
	echo "Irssi is not running"
	echo "To start it use: ./irssi-start.sh"
fi
