#!/bin/bash
# [] required, <> optional
# Usage ``
# Variables: 

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

directories=(
    /srv/daemon-data/
)

mysql_databases=(
    litebans
)

