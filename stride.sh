#!/bin/bash

cd /tmp
sudo sh -c 'echo "deb https://packages.atlassian.com/debian/stride-apt-client $(lsb_release -c -s) main" > /etc/apt/sources.list.d/atlassian-stride.list'
wget -O - https://packages.atlassian.com/api/gpg/key/public | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y stride

APP_NAME=Stride
APP_EXEC="/usr/share/applications/stride %U"
AUTOSTART_CONFIG=~/.config/autostart/$APP_NAME.desktop

sudo touch $AUTOSTART_CONFIG

sudo echo "[Desktop Entry]" >> $AUTOSTART_CONFIG
sudo echo "Type=Application" >> $AUTOSTART_CONFIG
sudo echo "Exec=$APP_EXEC" >> $AUTOSTART_CONFIG
sudo echo "Hidden=false" >> $AUTOSTART_CONFIG
sudo echo "NoDisplay=false" >> $AUTOSTART_CONFIG
sudo echo "X-GNOME-Autostart-enabled=true" >> $AUTOSTART_CONFIG
sudo echo "Name[en_US]=$APP_NAME" >> $AUTOSTART_CONFIG
sudo echo "Name=$APP_NAME" >> $AUTOSTART_CONFIG
sudo echo "Comment[en_US]=" >> $AUTOSTART_CONFIG
sudo echo "Comment=" >> $AUTOSTART_CONFIG
