#!/bin/sh

main() {
	local ips="192.168.0.50 192.168.0.51"

	for ip in ${ips}; do
		cp $1 /home/feckert/mnt/ssh_${ip}${2}
	done
}

main "$@"

