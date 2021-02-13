#!/bin/sh

usage() {
	echo "Usage: $(basename $0) [host]"
	echo "host: hostname or ip address"
	exit 1
}

main() {
	local host="${1}"
	local iface="eth1"
	local port="443"
	local tcpdump="/usr/sbin/tcpdump"
	local file="/tmp/${host}_${iface}"

	[ "$#" -eq 0 ] && usage

	echo "Use: wireshark -k -i ${file}"
	rm -rf "${file}"
	mkfifo "${file}"

	ssh -l root ${host} "${tcpdump} -s 0 -U -n -w - -i ${iface} not port 22" \
		> ${file}
}

main "$@"
