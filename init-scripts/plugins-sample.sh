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
moosh plugin-install -d --release 2019051505 theme_snap
# moosh plugin-install -d --release 2019042008 mod_bigbluebuttonbn
# moosh plugin-install -d --release 2020020500 mod_hvp
# moosh plugin-install -d --release 2020043003 block_xp
moosh plugin-install -d availability_xp 
echo >&2 "Plugins installed!"

moosh config-set theme snap
# import theme settings:
# script needs to be in /var/www/html and name like theme_xxxx
# it can't have info about directories: ./  so next line is not valid and I have to "hack it"
# tar -zcf snap_settings.tar.gz -C /init-scripts/snap_settings .
find /init-scripts/snap_settings -type f -printf "%f\n" | xargs tar -zcf snap_settings.tar.gz -C /init-scripts/snap_settings
moosh theme-settings-import snap_settings.tar.gz
# moosh config-set bigbluebuttonbn_server_url 2.2.2.2
# moosh config-set bigbluebuttonbn_shared_secret thisIsMySecret


