#!/bin/sh

CMD="${1}"

case "${CMD}" in
	off)
		xrandr --output HDMI2 --off
		;;
	beamer)
		xrandr --output HDMI2 --mode 1600x1200 --right-of LVDS1
		;;
	*)
		echo "cmd not supported"
		exit 1
		;;
esac

