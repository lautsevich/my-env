#!/bin/bash

APP_PASS="password"
ROOT_PASS="password"
APP_DB_PASS="password"

sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $APP_PASS"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $ROOT_PASS"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $APP_DB_PASS"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"

sudo apt-get update
sudo apt-get install -y phpmyadmin php-mbstring php-gettext
sudo phpenmod mbstring
sudo systemctl restart apache2
