#!/bin/bash

sudo apt update
sudo apt upgrade
sudo apt install -y git
sudo apt install -y snapd
sudo apt install -y ansible
sudo apt install -y make
sudo apt autoremove

echo "Run make provision"
