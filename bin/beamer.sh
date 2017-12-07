#!/bin/sh

CMD="${1}"

case "${CMD}" in
	off)
		xrandr --output HDMI1 --off
		;;
	tv)
		xrandr --output HDMI1 --mode 1920x1080 --right-of LVDS1
		;;
	*)
		echo "cmd not supported"
		exit 1
		;;
esac

