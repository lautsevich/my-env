#!/bin/bash

cd /tmp
curl https://linux.avocode.com/avocode_pub.gpg | sudo apt-key add -
echo deb http://linux.avocode.com/apt all main >> /etc/apt/sources.list
sudo apt-get update
sudo apt-get install -y avocode
