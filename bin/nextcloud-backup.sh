#!/bin/sh
#
# Copyright (C) 2017 Florian Eckert <Eckert.Florian@googlemail.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See https://www.gnu.org/licenses/gpl-2.0.txt for more information.
#

start_maintenance_mode() {
	local cdir="$(pwd)"

	echo "Start maintenance mode for Nextcloud..."
	cd "${NEXTCLOUD_APP_DIR}"
	sudo -u "${WEBSERVER_USER}" php occ maintenance:mode --on
	cd "$cdir"
	echo "Done"
}

stop_maintenance_mode() {
	local cdir="$(pwd)"

	echo "Stop maintenance mode for Nextcloud..."
	cd "${NEXTCLOUD_APP_DIR}"
	sudo -u "${WEBSERVER_USER}" php occ maintenance:mode --off
	cd "$cdir"
	echo "Done"
}

stop_webserver() {
	echo "Stopping web server..."
	service "${WEBSERVER}" stop
	echo "Done"
}

start_webserver() {
	echo "Starting web server..."
	service "${WEBSERVER}" start
	echo "Done"
}

exporting_app_dir(){
	echo "Creating backup of Nextcloud app directory..."
	rm -rf "${BACKUP_DIR}/${NEXTCLOUD_APP_FILE}"
	tar -cpzf "${BACKUP_DIR}/${NEXTCLOUD_APP_FILE}" \
		-C "${NEXTCLOUD_APP_DIR}" .
	echo "Done"
}

importing_app_dir() {
	echo "Restoring Nextcloud app directory..."
	rm -rf "${NEXTCLOUD_APP_DIR}"
	mkdir -p "${NEXTCLOUD_APP_DIR}"
	tar -xpzf "${BACKUP_DIR}/${NEXTCLOUD_APP_FILE}" \
		-C "${NEXTCLOUD_APP_DIR}"
	echo "Done"
}

exporingt_nexcloud_db() {
	echo "Backup Nextcloud database..."
	mysqldump --single-transaction \
		-h localhost \
		-u "${NEXTCLOUD_DB_USER}" \
		-p"${NEXTCLOUD_DB_PASSWORD}" \
		"${NEXTCLOUD_DB}" > "${BACKUP_DIR}/${NEXTCLOUD_DB_FILE}"
	echo "Done"
}

importing_nextcloud_db() {
	echo "Dropping Nextcloud DB..."
	mysql -h localhost \
		-u "${NEXTCLOUD_DB_USER}" \
		-p"${NEXTCLOUD_DB_PASSWORD}" \
		-e "DROP DATABASE ${NEXTCLOUD_DB}"
	echo "Done"

	echo "Creating Nextcloud DB..."
	mysql -h localhost \
		-u "${NEXTCLOUD_DB_USER}" \
		-p"${NEXTCLOUD_DB_PASSWORD}" \
		-e "CREATE DATABASE ${NEXTCLOUD_DB}"
	echo "Done"

	echo "Restoring Nextcloud DB..."
	mysql -h localhost \
		-u "${NEXTCLOUD_DB_USER}" \
		-p"${NEXTCLOUD_DB_PASSWORD}" \
		"${NEXTCLOUD_DB}" < "${BACKUP_DIR}/${NEXTCLOUD_DB_FILE}"
	echo "Done"
}

do_houskeeping() {
	local cdir="$(pwd)"

	echo "Setting directory permissions..."
	chown -R "${WEBSERVER_USER}":"${WEBSERVER_USER}" "${NEXTCLOUD_APP_DIR}"
	echo "Done"

	echo "Updating the system data-fingerprint..."
	cd "${NEXTCLOUD_APP_DIR}"
	sudo -u "${WEBSERVER_USER}" php occ maintenance:data-fingerprint
	cd "$cdir"
	echo "Done"
}

importing() {
	local nextcloud_db_file="$1"
	local nextcloud_app_file="$2"

	if [ ! -f "${nextcloud_db_file}" ]; then
		echo "ERROR: No Nextcloud db file given!"
		exit 1
	fi

	if [ ! -f "${nextcloud_app_file}" ]; then
		echo "ERROR: No Nextcloud app file given!"
		exit 1
	fi

	start_maintenance_mode
	stop_webserver
	importing_app_dir
	importing_nextcloud_db
	do_houskeeping
	stop_maintenance_mode
	start_webserver
}

exporting() {
	if [ ! -d "${BACKUP_DIR}" ]; then
		mkdir -p "${BACKUP_DIR}"
	fi

	start_maintenance_mode
	stop_webserver
	exporting_app_dir
	exporting_nexcloud_db
	stop_maintenance_mode
	start_webserver

}

check_config() {
	local configs="
		BACKUP_DIR
		WEBSERVER
		WEBSERVER_USER
		NEXTCLOUD_DB
		NEXTCLOUD_DB_USER
		NEXTCLOUD_DB_PASSWORD
		NEXTCLOUD_DB_FILE
		NEXTCLOUD_APP_DIR
		NEXTCLOUD_APP_FILE"
	local var

	for config in $configs; do
		var=$(eval echo \${$config})
		[ "$var" = "" ] && {
			echo "No config value for \"$config\" found"
			exit 1
		}
	done
}

usage() {
	local rval="$1"

	echo "Usage: $(basename "${0}") [importing|exporting]"
	echo ""
	echo "	importing: import database and Nextcloud app"
	echo "		arg1: nextcloud mysql [backup].sql file"
	echo "		arg2: nextcloud app [backup].tar.gz file"
	echo "	exporting: export database and Nextcloud app"

	exit "$rval"
}

main() {
	local cmd="$1"
	local nextcloud_db_file="$2"
	local nextcloud_app_file="$3"

	if [ "$(id -u)" != "0" ]; then
		echo "ERROR: This script has to be run as root!"
		exit 1
	fi

	BACKUP_DIR="/mnt/nextcloud"

	WEBSERVER="nginx"
	WEBSERVER_USER="www-data"
	NEXTCLOUD_DB=""
	NEXTCLOUD_DB_USER=""
	NEXTCLOUD_DB_PASSWORD=""
	NEXTCLOUD_DB_FILE="nextcloud.sql"

	NEXTCLOUD_APP_DIR="/var/www/nextcloud"
	NEXTCLOUD_APP_FILE="nextcloud-filedir.tar.gz"

	check_config

	case "$1" in
		importing)
			importing "$nextcloud_db_file" "$nextcloud_app_file"
			echo "DONE!"
			echo "Backup successfully restored"
			;;
		exporting)
			exporting
			echo "DONE!"
			echo "Backup successfully created"
			;;
		*)
			usage "1"
			;;
	esac
}

main "$@"
