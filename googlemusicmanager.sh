#!/bin/bash

sudo sh -c 'echo "deb http://dl.google.com/linux/musicmanager/deb/ stable main" >> /etc/apt/sources.list.d/google-musicmanager.list'
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y google-musicmanager-beta

#wget https://dl.google.com/linux/direct/google-musicmanager-beta_current_amd64.deb
#sudo dpkg -i google-musicmanager-beta_current_amd64.deb
#sudo rm -rf google-musicmanager-beta_current_amd64.deb
