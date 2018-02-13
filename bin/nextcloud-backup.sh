#!/bin/sh
#
# Copyright (C) 2017 Florian Eckert <Eckert.Florian@googlemail.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See https://www.gnu.org/licenses/gpl-2.0.txt for more information.
#

start_maintenance_mode() {
	local cdir
	cdir="$(pwd)"

	echo "Start maintenance mode for Nextcloud..."
	cd "${NEXTCLOUD_APP_DIR}" || exit 1
	sudo -u "${WEBSERVER_USER}" php occ maintenance:mode --on
	cd "$cdir" || exit 1
	echo "Done"
}

stop_maintenance_mode() {
	local cdir
	cdir="$(pwd)"

	echo "Stop maintenance mode for Nextcloud..."
	cd "${NEXTCLOUD_APP_DIR}" || exit 1
	sudo -u "${WEBSERVER_USER}" php occ maintenance:mode --off
	cd "$cdir" || exit 1
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

exporting_nexcloud_db() {
	echo "Backup Nextcloud database..."
	mysqldump --single-transaction \
		-h localhost \
		--user="${NEXTCLOUD_DB_USER}" \
		--password="${NEXTCLOUD_DB_PASSWORD}" \
		"${NEXTCLOUD_DB}" > "${BACKUP_DIR}/${NEXTCLOUD_DB_FILE}"
	echo "Done"
}

importing_nextcloud_db() {
	echo "Dropping Nextcloud DB..."
	mysql -h localhost \
		--user="${NEXTCLOUD_DB_USER}" \
		--password="${NEXTCLOUD_DB_PASSWORD}" \
		-e "DROP DATABASE ${NEXTCLOUD_DB}"
	echo "Done"

	echo "Creating Nextcloud DB..."
	mysql -h localhost \
		--user="${NEXTCLOUD_DB_USER}" \
		--password="${NEXTCLOUD_DB_PASSWORD}" \
		-e "CREATE DATABASE ${NEXTCLOUD_DB}"
	echo "Done"

	echo "Restoring Nextcloud DB..."
	mysql -h localhost \
		--user="${NEXTCLOUD_DB_USER}" \
		--password="${NEXTCLOUD_DB_PASSWORD}" \
		"${NEXTCLOUD_DB}" < "${BACKUP_DIR}/${NEXTCLOUD_DB_FILE}"
	echo "Done"
}

do_houskeeping() {
	local cdir
	cdir="$(pwd)"

	echo "Setting directory permissions..."
	chown -R "${WEBSERVER_USER}":"${WEBSERVER_USER}" "${NEXTCLOUD_APP_DIR}"
	echo "Done"

	echo "Updating the system data-fingerprint..."
	cd "${NEXTCLOUD_APP_DIR}" || exit 1
	sudo -u "${WEBSERVER_USER}" php occ maintenance:data-fingerprint
	cd "$cdir" || exit 1
	echo "Done"
}

importing() {
	if [ ! -f "${BACKUP_DIR}/${NEXTCLOUD_DB_FILE}" ]; then
		echo "ERROR: No Nextcloud db file \"${NEXTCLOUD_DB_FILE}\" found in \"${BACKUP_DIR}\"!"
		exit 1
	fi

	if [ ! -f "${BACKUP_DIR}/${NEXTCLOUD_APP_FILE}" ]; then
		echo "ERROR: No Nextcloud app file \"${NEXTCLOUD_APP_FILE}\" found in \"${BACKUP_DIR}\"!"
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
	if [ -d "${BACKUP_DIR}" ]; then
		echo "ERROR: Backup directory \"${BACKUP_DIR}\" already exist!"
		echo "Please delete first"
		exit 2
	else
		echo "INFO: Creating backup directory \"${BACKUP_DIR}\""
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
	echo "	importing: import database and nextcloud app"
	echo "	exporting: export database and nextcloud app"

	exit "$rval"
}

main() {
	local cmd="$1"

	if [ "$(id -u)" != "0" ]; then
		echo "ERROR: This script has to be run as root!"
		exit 1
	fi

	BACKUP_DIR="/mnt/nextcloud/nextcloud_backup"

	WEBSERVER="nginx"
	WEBSERVER_USER="www-data"
	NEXTCLOUD_DB="nextcloud"
	NEXTCLOUD_DB_USER="nextcloud"
	NEXTCLOUD_DB_PASSWORD="nextcloud"
	NEXTCLOUD_DB_FILE="nextcloud-mysql.sql"

	NEXTCLOUD_APP_DIR="/var/www/nextcloud"
	NEXTCLOUD_APP_FILE="nextcloud-app.tar.gz"

	check_config

	case "$cmd" in
		importing)
			importing
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
