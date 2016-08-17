#!/bin/sh

SSHFS_DIR="ssh_192.168.0.50"
SRC="iptables"
IP_D="/home/feckert/mnt/${SSHFS_DIR}/tmp"

if [ -e ${IP_D}/iptables.txt ]; then
	for t in "mangle" "filter" "nat" "raw"; do
		cat ${IP_D}/${SRC}.txt | ~/bin/graph-iptables-save.pl -tables ${t} > ${IP_D}/${SRC}-${t}.dot && dot -Tpng ${IP_D}/${SRC}-${t}.dot > ${IP_D}/${SRC}-${t}.png
	done
else
	echo "file ${IP_D}/${SRC}.txt does not exist"
fi
