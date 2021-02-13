#!/bin/sh
# script to synchronize a local directory with a remote directory

usage(){
	echo "$(basename "$0"): synchronize a local directory with a remote directory"
	echo "Usage:"
	echo "$(basename "$0") [push|pull]"
	echo "Add .sync and add remote path user@example.com/example/path"
	exit 1
}

main(){
	local cmd="$1"

	local local_folder=""
	local remote_folder=""

	local result

	local_folder="$(pwd)"
	[ -f ".sync" ] || {
		echo "No \".sync\" config file found"
		exit 2
	}
	remote_folder="$(cat .sync)"
	[ "$remote_folder" = "" ] && {
		echo "No remote path in config found"
		exit 3
	}

	case "$cmd" in
		push)
			# copy locale directory to remote directory, delete locally missing files
			rsync --numeric-ids \
				--archive \
				--verbose \
				--partial \
				--progress \
				--compress \
				--exclude "./.sync" \
				-rsh=ssh \
				--delete "$local_folder" \ 
				"$remote_folder"
			result=$?
			;;
		pull)
			# copy remote directory to locale directory, delete remotely missing files
			rsync --numeric-ids \
				--archive \
				--verbose \
				--partial \
				--progress \
				--compress \
				--rsh=ssh \
				--delete "$remote_folder" \
				"$local_folder"
			result=$?
			;;
		*)
			usage
			;;
	esac

	exit "$result"
}

main "$@"
