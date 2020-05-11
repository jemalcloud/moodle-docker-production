#!/bin/bash
# This script contains commands that should be executed first 
# time the containers goes up or after upgrades to update database

# example command: moosh config-set name value <plugin>

moosh config-set theme ${DEFAULT_THEME}
moosh config-set bigbluebuttonbn_server_url ${BBB_SERVER_URL}
moosh config-set bigbluebuttonbn_shared_secret ${BBB_SECRET}