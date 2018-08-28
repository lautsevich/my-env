#!/bin/bash

sudo snap install telegram-desktop

APP_NAME=Telegram
AUTOSTART_FILE=$APP_NAME.desktop
APP_EXEC="/opt/telegram/Telegram -- %u"
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

# TODO: Doesn't work autostart