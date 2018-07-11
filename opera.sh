#!/bin/bash

wget -qO- https://deb.opera.com/archive.key | sudo apt-key add -
sudo add-apt-repository 'deb https://deb.opera.com/opera-stable/ stable non-free'
sudo apt-get install -y opera-stable

# TODO: Add deb-conf data for silent install
# TODO: Fix Opera multiole times configuration in sources