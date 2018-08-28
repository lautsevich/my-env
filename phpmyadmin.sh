#!/bin/bash

INSTALL_BULK=$1
APP_PASS="lovata"
ROOT_PASS="lovata"
APP_DB_PASS="lovata"

if [[ "$INSTALL_BULK" = false ]]; then
    sudo apt-get update
fi

sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $APP_PASS"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $ROOT_PASS"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $APP_DB_PASS"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"

sudo apt-get install -y phpmyadmin php-mbstring php-gettext
sudo phpenmod mbstring
sudo systemctl restart apache2

# TODO: Move password to config
