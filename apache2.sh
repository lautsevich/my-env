#!/bin/bash

sudo apt-get update
sudo apt-get install -y apache2

# TODO: Add apache.conf user & group replacement
# User ${APACHE_RUN_USER}
# Group ${APACHE_RUN_GROUP}
