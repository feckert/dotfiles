#/bin/sh

DOWNLOAD_FOLDER="/tmp"
NODE_VERSION="v4.4.7"
NODE_DIRECTORY="node-${NODE_VERSION}-linux-x64"
NODE_FILE="${NODE_DIRECTORY}.tar.xz"
NODE_INSTALL_FOLDER=/home/feckert/opt

usage() {
	echo "Usage: $(basename $0) -c [command]"
	echo "Command:"
	echo "   install  install node js version"
	echo "   uninstall deinstall node js version"
	exit 1
}

install () {
	# download file if not exists
	if [ ! -e ${DOWNLOAD_FOLDER}/${NODE_FILE} ] ; then
		echo "Download node ..."
		wget https://nodejs.org/dist/${NODE_VERSION}/${NODE_FILE} -P ${DOWNLOAD_FOLDER}
	fi

	# create install folder
	mkdir -p ${NODE_INSTALL_FOLDER}

	# check if already installed @todo remove
	if [ -e ${NODE_INSTALL_FOLDER}/${NODE_DIRECTORY} ] ; then
		echo "Already installed ..."
		exit 1
	fi

	# extract node files
	echo "Extracting node ..."
	tar xf ${DOWNLOAD_FOLDER}/${NODE_FILE} -C ${NODE_INSTALL_FOLDER}

	# set link
	echo "Set link ..."
	ln -s ${NODE_INSTALL_FOLDER}/${NODE_DIRECTORY}/bin/node ~/bin/node
	ln -s ${NODE_INSTALL_FOLDER}/${NODE_DIRECTORY}/bin/npm ~/bin/npm
}

uninstall () {
	# unset link
	echo "unset link ..."
	rm ~/bin/node
	rm ~/bin/npm

	# remove nod files
	echo "Remove node files ..."
	rm -rf ${NODE_INSTALL_FOLDER}/${NODE_DIRECTORY}
}

main() {
	local command=""

	if [ "$#" -eq 0 ] ; then
		usage
	fi

	while getopts "c:" option; do
		case "${option}" in
			c) 
				command="${OPTARG}"
				;;
			*)
				usage
				;;
		esac
	done

	case $command in 
		install)
			install
			;;
		uninstall)
			uninstall
			;;
		*)
			usage
			;;
	esac
}

main "$@"
