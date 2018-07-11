!/bin/bash

sudo sh -c 'echo "deb https://packages.atlassian.com/debian/stride-apt-client $(lsb_release -c -s) main" > /etc/apt/sources.list.d/atlassian-stride.list'
wget -O - https://packages.atlassian.com/api/gpg/key/public | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y stride

APP_NAME=Stride
AUTOSTART_FILE=$APP_NAME.desktop
APP_EXEC="/usr/share/applications/stride %U"
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