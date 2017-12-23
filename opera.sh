#!/bin/bash

cd /tmp
wget -qO- https://deb.opera.com/archive.key | sudo apt-key add -
sudo add-apt-repository 'deb https://deb.opera.com/opera-stable/ stable non-free'
sudo apt-get update
sudo apt-get install -y opera-stable
