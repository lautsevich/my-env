#!/bin/bash

wget -qO- https://deb.opera.com/archive.key | sudo apt-key add -
sudo add-apt-repository 'deb https://deb.opera.com/opera-stable/ stable non-free'

sudo debconf-set-selections <<< 'opera-stable opera-stable/add-deb-source boolean true'

sudo apt-get install -y opera-stable

# TODO: Fix Opera multiple times configuration in sources