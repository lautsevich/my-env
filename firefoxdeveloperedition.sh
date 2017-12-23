#!/bin/bash

sudo add-apt-repository ppa:ubuntu-desktop/ubuntu-make
sudo apt-get update
sudo apt-get install ubuntu-make
umake web firefox-dev
sudo ln -s ~/.local/share/umake/web/firefox-dev/firefox /usr/bin/firefox-dev
