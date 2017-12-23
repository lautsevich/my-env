#!/bin/bash

cd /tmp
wget https://lisakov.com/files/acestream-64.zip
unzip acestream-64.zip
rm acestream-64.zip
sudo dpkg -i acestream-64/00-libgnutls-deb0-28_3.3.15-5ubuntu2_amd64.deb
sudo dpkg -i acestream-64/01-acestream-engine_3.0.5.1-0.2_amd64.deb
sudo dpkg -i acestream-64/02-acestream-player-compat_3.0.2-1.1_amd64.deb
sudo dpkg -i acestream-64/03-acestream-player-data_3.0.2-1.1_amd64.deb
sudo dpkg -i acestream-64/04-acestream-player_3.0.2-1.1_amd64.deb
sudo apt-get -f install -y
rm -rf acestream-64/
