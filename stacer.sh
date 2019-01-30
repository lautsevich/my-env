#!/bin/bash

wget https://jaist.dl.sourceforge.net/project/stacer/v1.0.9/stacer_1.0.9_amd64.deb
sudo dpkg -i stacer*.deb
sudo rm -rf stacer*.deb
