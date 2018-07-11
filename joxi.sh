#!/bin/bash

wget http://dl.joxi.ru/linux/joxi-amd64.deb
sudo dpkg -i joxi-amd64.deb
sudo rm -rf joxi-amd64.deb
sudo apt-get -f install -y

# TODO: Need fix dependecies fail
