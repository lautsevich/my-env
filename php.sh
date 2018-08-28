#!/bin/bash

INSTALL_BULK=$1

if [[ "$INSTALL_BULK" = false ]]; then
    sudo apt-get update
fi

sudo apt-get install -y php php-common
sudo apt-get install -y php-json php-phpdbg php-dev php-xml
sudo apt-get install -y php-cli
sudo apt-get install -y libapache2-mod-php
sudo apt-get install -y php-mysql
sudo apt-get install -y php-gd
sudo apt-get install -y php-curl
sudo apt-get install -y php-mbstring
sudo apt-get install -y php-zip
sudo apt-get install -y php-pear

# TODO: Add PHP version setup
