#!/bin/bash

cd /tmp
wget https://github.com/MarshallOfSound/Google-Play-Music-Desktop-Player-UNOFFICIAL-/releases/download/v4.2.0/google-play-music-desktop-player_4.2.0_amd64.deb
sudo dpkg -i google-play-music-desktop-player_*_amd64.deb
sudo rm -rf google-play-music-desktop-player_*_amd64.deb
