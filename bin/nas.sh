#!/bin/sh

usage(){
	echo "$(basename "$0"): do enable/disable nas"
	echo "Usage:"
	echo "$(basename "$0") [ start | stop | snapshot ]"
	exit 0
}

main(){
	case "${1}" in
		start)
			ssh root@skynet.lan "/etc/init.d/etherwake start zion"
			;;
		stop)
			ssh root@zion.lan "/sbin/shutdown -h now"
			;;
		snapshot)
			ssh root@zion.lan "/usr/sbin/zfSnap -z -s -S -a 4w -r merkur"
			;;
		*)
			usage
			;;
	esac
}
#bindfs -o ro --mirror-only=feckert /media/feckert/9b8f3224-7ade-45d0-95ea-9c8481f169c6/ /home/feckert/mnt/backup/
#fusermount -u /home/feckert/mnt/backup
main "$@"
