#!/bin/bash

sudo apt update
sudo apt install -y git
sudo apt install -y snapd
sudo apt install -y ansible
sudo apt install -y make

echo "Run make provision"