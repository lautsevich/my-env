#!/bin/bash

cd /tmp
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
sudo dpkg -i gitkraken-amd64.deb
sudo rm -rf gitkraken-amd64.deb
