#!/bin/bash

wget https://zoom.us/client/latest/zoom_amd64.deb
sudo dpkg -i zoom*.deb
sudo rm -rf zoom*.deb
sudo apt --fix-broken install -y
