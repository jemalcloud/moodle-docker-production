#!/bin/bash
set -euo pipefail
declare MOODLE_DATA=/var/www/moodledata

# install only if executed without CMD parameter

if [[ "$1" == apache2* ]] || [ "$1" == php-fpm ]; then
	# get user and group
	if [ "$(id -u)" = '0' ]; then
		case "$1" in
			apache2*)
				user="${APACHE_RUN_USER:-www-data}"
				group="${APACHE_RUN_GROUP:-www-data}"

				# strip off any '#' symbol ('#1000' is valid syntax for Apache)
				pound='#'
				user="${user#$pound}"
				group="${group#$pound}"
				;;
			*) # php-fpm
				user='www-data'
				group='www-data'
				;;
		esac
	else
		user="$(id -u)"
		group="$(id -g)"
	fi

	# moodle data directory

	if [ ! -d $MOODLE_DATA ]; then
		mkdir $MOODLE_DATA
		chown -R "$user:$group" $MOODLE_DATA
		echo >&2 "MOODLE DATA DIRECTORY CREATED"
	else
		echo >&2 "MOODLE DATA DIRECTORY FOUND: SKIP CREATION"
		# if the directory exists AND the permissions of it are root:root, let's chown it (likely a Docker-created directory)
		if [ "$(id -u)" = '0' ] && [ "$(stat -c '%u:%g' $MOODLE_DATA)" = '0:0' ]; then
		    echo >&2 "Changed permissions to Moodle Data directory"
			chown -R "$user:$group" $MOODLE_DATA
		fi
	fi

	# env variables
	if 	[[ ! -v MOODLE_MYSQL_PASSWORD ]]; then
		export MOODLE_MYSQL_PASSWORD=$(cat /dev/urandom | tr -dc "a-zA-Z0-9!@#$%^&*()_+?><~\`;'" | fold -w 16 | head -n 1)
	fi

 

	# moodle code

	if [ ! -e config.php ]; then

		echo >&2 "Moodle not found in $PWD - copying now..."
		if [ -n "$(ls -A)" ]; then
			echo >&2 "WARNING: $PWD is not empty! (copying anyhow)"
		fi
		sourceTarArgs=(
			--create
			--file -
			--directory /usr/src/moodle
			--owner "$user" --group "$group"
		)
		targetTarArgs=(
			--extract
			--file -
		)
		if [ "$user" != '0' ]; then
			# avoid "tar: .: Cannot utime: Operation not permitted" and "tar: .: Cannot change mode to rwxr-xr-x: Operation not permitted"
			targetTarArgs+=( --no-overwrite-dir )
		fi
		tar "${sourceTarArgs[@]}" . | tar "${targetTarArgs[@]}"
		echo >&2 "MOODLE CODE CREATED"
	else
		echo >&2 "MOODLE CODE FOUND: SKIP CREATION"
	fi

	# database

	echo >&2"Checking database status..."

	#wait till is ready for connections
	dockerize -wait tcp://db:3306 -timeout 20s
	# prevent container exit by php return value
	set +e
	php /var/www/html/admin/cli/check_database_schema.php
	dbStatus=$?
	if [ $dbStatus  -eq 2 ]; then
		echo >&2 "Creating database..."
		php $PWD/admin/cli/install_database.php --lang="${MOODLE_LANG}" --adminuser="${MOODLE_ADMIN_USER}" --adminpass="${MOODLE_ADMIN_PASSWORD}" --adminemail="${MOODLE_ADMIN_EMAIL}" --agree-license --fullname="${MOODLE_SITE_FULLNAME}" --shortname="${MOODLE_SITE_NAME}"
		echo >&2 "DATABASE CREATED"
	elif [ $dbStatus -eq 0 ]; then
		echo >&2 "MOODLE DATABASE FOUND: SKIP CREATION"
	else
		echo >&2 "ERRORS WITH MOODLE DATABASE!"
		exit $dbStatus
	fi

	# install plugins via moosh, first upgrade list
	echo >&2 "Installing plugins..."
	# remove blank and comment lines
	cat /usr/src/plugins |sed '/^#/d'|sed '/^$/d' >/usr/src/plugins_filtered
	cd /var/www/html
	# execute plugin installation
	while read in; do echo moosh plugin-install "$in" |bash; done < /usr/src/plugins_filtered
	echo >&2 "PLUGINS INSTALLED!"
	echo >&2 "STARTING WEB SERVER"
fi

exec "$@"
