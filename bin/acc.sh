#!/bin/sh

usage() {
	echo "Usage: $(basename $0) -c [cmd] -d [device]"
	echo "cmd:"
	echo "   on: switch device off"
	echo "   off: switch device on"
	echo "   reboot: power cycle device"
	echo "device:"
	echo "   VR2020_DRNO: Test device VR2020_DRNO"
	exit 1
}

main() {
	local cmd=""
	local device=""
	local port=""

	if [ "$#" -eq 0 ] ; then
		usage
	fi

	while getopts "c:d:" option; do
		case "${option}" in
			c)
				cmd="${OPTARG}"
				;;
			d)
				device="${OPTARG}"
				;;
			*)
				usage
				;;
		esac
	done

	[ "${cmd}" = "" ] && usage
	[ "${device}" = "" ] && usage

	case "${device}" in
		VR2020_DRNO)
			port="p1"
			;;
		*)
			echo "Device ${device} not supported"
			exit 2
			;;
	esac

	case "${cmd}" in
		off)
			/usr/bin/powerman --off ${port}
			;;
		on)
			/usr/bin/powerman --on ${port}
			;;
		reboot)
			/usr/bin/powerman --cycle ${port}
			;;
		*)
			usage
			;;
	esac
}

main "$@"
