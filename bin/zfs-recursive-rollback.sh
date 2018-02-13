#!/bin/sh

usage(){
	local retval="$1"

	echo "$(basename "$0") <fs> <id>"
	echo "Usage:"
	echo "		fs: zfs filesystem"
	echo "		id: zfs snapshot id"
	exit "$retval"
}

main(){
	local fs="$1"
	local id="$2"

	local result snapshots

	if [ "$(id -u)" != "0" ]; then
		echo "ERROR: This script has to be run as root!"
		exit 1
	fi

	if [ "${fs}" = "" ] || [ "${id}" = "" ]; then
		usage 1
	fi

	snapshots="$(zfs list -H -t snapshot -r "$fs" | grep "$id" | cut -f 1)"

	for snap in $snapshots; do
		# -r : also destroys the snapshots newer than the specified one
		# -R : also destroys the snapshots newer than the one specified and their clones
		# -f : forces an unmount of any clone file systems that are to be destroyed
		echo "rolling back to [$snap]: "
		zfs rollback -r -R -f "$snap"
		result=$?
		if [ "$result" != "0" ]; then
			echo "Failed"
		else
			echo "Success"
		fi
	done
}

main "$@"
