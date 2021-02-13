#!/bin/sh

SRC="iptables"
DIR="/tmp"

if [ -e ${DIR}/${SRC}.txt ]; then
	for t in "mangle" "filter" "nat" "raw"; do
		~/bin/graph-iptables-save.pl -tables ${t} \
			> ${DIR}/${SRC}-${t}.dot \
			< ${DIR}/${SRC}.txt && \
			dot -Tpng ${DIR}/${SRC}-${t}.dot > ${DIR}/${SRC}-${t}.png
	done
else
	echo "No input file ${DIR}/${SRC}.txt found"
	echo "Execude: iptables-save > ${DIR}/${SRC}.txt"
fi
