#!/bin/sh

SIZE="800x600"

usage() {
	local retval="$1"

	echo "$(basename "$0"): Resize image in folder"
	echo "Usage:"
	echo "$(basename "$0") [input folder] [output folder]"
	exit "$retval"
}

main() {
	folder_in="$1"
	folder_out="$2"

	if [ "${folder_in}" = "" ] || [ "${folder_out}" = "" ]; then
		usage 1
	fi

	[ -d "${folder_out}" ] || {
		mkdir -p "${folder_out}"
	}

	for pic in $(ls "${folder_in}"); do
		convert "${folder_in}/${pic}" \
			-resize "$SIZE" \
			"${folder_out}/resize-${pic}"
	done
}

main "$@"
