#!/bin/bash

curl https://linux.avocode.com/avocode_pub.gpg | sudo apt-key add -
sudo echo deb http://linux.avocode.com/apt all main >> /etc/apt/sources.list

SOURCES_FILE='/etc/apt/sources.list'
AVOCODE_SOURCE='deb http://linux.avocode.com/apt all main'
sudo sed -i -e "\$a$AVOCODE_SOURCE" $SOURCES_FILE

sudo apt-get update
sudo apt-get install -y avocode
