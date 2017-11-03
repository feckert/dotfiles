#!/bin/sh

if [ "$1" != "-u" ]; then

	IP=$1
	USER=$2
	DIR=ssh_${IP}

	if [ -z "${IP}" ] ; then
		echo "Please append IP"; exit 1
	fi

	if [ -z "${USER}" ] ; then
					echo "Please append user name"; exit 1
	fi

	# Check if directory exist
	if [ ! -d "~/mnt/${DIR}" ] ; then
		echo "execute -> mkdir -p ~/mnt/${DIR}"
		mkdir -p ~/mnt/${DIR}
	else 
		echo "Directory already set"
	fi

	# Check if directory is empty
	if [ ! "$(ls -A ~/mnt/$DIR)" ]; then 
		echo "execute -> sshfs ${USER}@${IP}:/ ~/mnt/${DIR} -o idmap=user -o uid=$(id -u) -o gid=$(id -g)"
		sshfs ${USER}@${IP}:/ ~/mnt/${DIR} -o idmap=user -o uid=$(id -u) -o gid=$(id -g)
	else
		echo "Directory not empty"
	fi

else

	DIR=$2

	if [ -z "${DIR}" ] ; then
		echo "Please append directory"; exit 1
	fi

	if [ "$(cat /etc/mtab | grep -w ${DIR})" ]; then
		echo "execute -> fusermount -u ${DIR}"
		fusermount -u ${DIR}
	else
		echo "Directory not mounted"
	fi
fi
