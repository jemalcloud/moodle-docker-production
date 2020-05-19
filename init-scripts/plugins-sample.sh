#!/bin/bash
# This script contains commands that should be executed first 
# time the containers goes up or after upgrades to update database

# example command: moosh config-set name value <plugin>

# Plugin list with [--release <build version>] if different from last
# hack: last one does never get active, so install one more


echo >&2 "Downloading plugin list..."
moosh plugin-list >/dev/null
echo >&2 "Plugin list downloaded!"				


echo >&2 "Installing plugins..."
moosh plugin-install -d theme_snap
moosh plugin-install -d mod_hvp
moosh plugin-install -d block_xp
moosh plugin-install -d availability_xp 
echo >&2 "Plugins installed!"

moosh config-set theme snap
moosh config-set tool_generator_users_password ${VARIABLE_DE_ENTORNO}
moosh config-set smtphosts ${VARIABLE_DE_ENTORNO}
moosh config-set smtpsecure ${VARIABLE_DE_ENTORNO}
moosh config-set smtpauthtype LOGIN
moosh config-set smtpuser ${VARIABLE_DE_ENTORNO}
moosh config-set smtppass ${VARIABLE_DE_ENTORNO}
moosh config-set smtpmaxbulk 100
moosh config-set noreplyaddress ${VARIABLE_DE_ENTORNO}
moosh config-set cron_hour 0
moosh config-set cron_minute 0
moosh config-set crrepository jleyva/moodle-configurable_reports_repository
moosh config-set dbhost ${VARIABLE_DE_ENTORNO}
moosh config-set dbname ${VARIABLE_DE_ENTORNO}
moosh config-set dbpass ${VARIABLE_DE_ENTORNO}
moosh config-set dbuser ${VARIABLE_DE_ENTORNO}
moosh config-set reportlimit 5000
moosh config-set reporttableui datatables
moosh config-set sharedsqlrepository jleyva/moodle-custom_sql_report_queries
moosh config-set sqlsecurity 1
moosh config-set sqlsyntaxhighlight 1
