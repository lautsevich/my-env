#!/bin/bash

wget https://downloads.slack-edge.com/linux_releases/slack-desktop-3.2.1-amd64.deb
sudo dpkg -i slack-desktop-*.*.*-amd64.deb
sudo rm -rf slack-desktop-*.*.*-amd64.deb
sudo apt-get -f install -y

APP_NAME=Slack
AUTOSTART_FILE=$APP_NAME.desktop
APP_EXEC="/usr/bin/slack --disable-gpu %U"
AUTOSTART_PATH=~/.config/autostart/

touch $AUTOSTART_FILE

echo "[Desktop Entry]
Type=Application
Exec=$APP_EXEC
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=$APP_NAME
Name=$APP_NAME
Comment[en_US]=
Comment=" >> $AUTOSTART_FILE

sudo mv $AUTOSTART_FILE $AUTOSTART_PATH
