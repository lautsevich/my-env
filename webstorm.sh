#!/bin/bash

cd /tmp
wget https://download.jetbrains.com/webstorm/WebStorm-2017.3.1.tar.gz
tar xvf WebStorm-*.tar.gz
sudo rm -rf WebStorm-*.tar.gz
sudo mv WebStorm-*/ /opt/webstorm/
sudo ln -s /opt/webstorm/bin/webstorm.sh /usr/local/bin/webstorm
cd /opt/webstorm/bin/
./webstorm.sh

