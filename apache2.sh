#!/bin/bash

INSTALL_BULK=$1

if [[ "$INSTALL_BULK" = false ]]; then
    sudo apt-get update
fi

sudo apt-get install -y apache2

# TODO: Add apache.conf user & group replacement
# User ${APACHE_RUN_USER}
# Group ${APACHE_RUN_GROUP}
