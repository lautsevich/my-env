#!/bin/bash

# INSTALL_BULK=true

# Update OS
sudo apt-get update
sudo apt-get upgrade

# Remove unnecesary apps
bash clean-ubuntu.sh

# UTILS
bash curl.sh $INSTALL_BULK
bash keepassxc.sh $INSTALL_BULK
bash gufw.sh $INSTALL_BULK

# DEVELOPMENT
bash git.sh $INSTALL_BULK
bash git-lfs.sh $INSTALL_BULK
bash gitkraken.sh $INSTALL_BULK
bash apache2.sh $INSTALL_BULK
bash mysql.sh $INSTALL_BULK
bash php.sh $INSTALL_BULK
bash composer.sh $INSTALL_BULK
bash phpmyadmin.sh $INSTALL_BULK
bash ruby.sh $INSTALL_BULK
bash bundler.sh $INSTALL_BULK
bash nodejs.sh $INSTALL_BULK
bash build-essential.sh $INSTALL_BULK
bash ansible.sh $INSTALL_BULK
bash terraform.sh $INSTALL_BULK
bash docker-ce.sh $INSTALL_BULK
bash code.sh $INSTALL_BULK
bash webstorm.sh $INSTALL_BULK
bash avocode.sh $INSTALL_BULK
bash figma.sh $INSTALL_BULK
bash avocode.sh $INSTALL_BULK

# INTERNET
bash chromium.sh $INSTALL_BULK
bash opera.sh $INSTALL_BULK
bash yandexbrowser.sh $INSTALL_BULK
bash skype.sh $INSTALL_BULK
bash telegram.sh $INSTALL_BULK
bash slack.sh $INSTALL_BULK
bash viber.sh $INSTALL_BULK

# MEDIA
bash vlc.sh $INSTALL_BULK
bash acestream.sh $INSTALL_BULK
bash sopcast.sh $INSTALL_BULK
bash google-musicmanager.sh $INSTALL_BULK
bash google-play-music-desktop-player.sh $INSTALL_BULK
bash flameshot.sh $INSTALL_BULK
bash steam.sh $INSTALL_BULK
bash simplescreenrecorder.sh $INSTALL_BULK

# OS
bash gnome-tweaks.sh $INSTALL_BULK
bash krusader.sh $INSTALL_BULK
bash mc.sh $INSTALL_BULK
bash teamviewer.sh $INSTALL_BULK
bash virtualbox.sh $INSTALL_BULK
bash vagrant.sh $INSTALL_BULK
bash wine.sh $INSTALL_BULK
bash playonlinux.sh $INSTALL_BULK
bash gnome-weather.sh $INSTALL_BULK
bash ubuntu-restricted-extras.sh $INSTALL_BULK
bash libavcodec-extra.sh $INSTALL_BULK
bash stacer.sh $INSTALL_BULK
bash gnome-shell-extensions.sh $INSTALL_BULK
