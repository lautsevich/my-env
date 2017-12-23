#!/bin/bash

cd /tmp
wget http://download.cdn.viber.com/cdn/desktop/Linux/viber.deb
sudo dpkg -i viber.deb
sudo rm -rf viber.deb

APP_NAME=Viber
APP_EXEC="/opt/viber/Viber %u"
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
