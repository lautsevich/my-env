#!/bin/bash

wget http://download.cdn.viber.com/cdn/desktop/Linux/viber.deb
sudo dpkg-deb -x viber.deb viber
sudo dpkg-deb --control viber.deb viber/DEBIAN
sudo sed -i -e 's/libcurl3/libcurl4/g' viber/DEBIAN/control

dpkg -b viber viberlibcurl4.deb
sudo dpkg -i viberlibcurl4.deb
sudo rm -rf viber.deb
sudo rm -rf viber/
sudo rm -rf viberlibcurl4.deb

APP_NAME=Viber
AUTOSTART_FILE=$APP_NAME.desktop
APP_EXEC="/opt/viber/Viber %u"
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
