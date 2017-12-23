#!/bin/bash

sudo add-apt-repository -y ppa:webupd8team/atom
sudo apt-get update
sudo apt-get install -y atom
sudo apt-get -f install
