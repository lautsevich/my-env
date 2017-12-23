#!/usr/bin/env bash

debconf-set-selections <<< 'mysql-server mysql-server/root_password password lovata'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password lovata'

sudo apt-get update
sudo apt-get install -y mysql-server
sudo apt-get install -y mysql-client
