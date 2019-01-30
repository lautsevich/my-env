#!/bin/bash

INSTALL_BULK=$1

if [[ "$INSTALL_BULK" = false ]]; then
    sudo apt-get update
fi

sudo apt-get install gnome-shell-extensions

#https://linuxconfig.org/how-to-install-gnome-shell-extensions-on-ubuntu-18-04-bionic-beaver-linux
