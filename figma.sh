#!/bin/bash

wget https://github.com/302bis/figma-app-ubuntu/releases/download/0.5.0/figma_0.4_amd64.snap

sudo snap install --dangerous figma_0.4_amd64.snap

rm figma_0.4_amd64.snap

sudo updatedb

FIGMA_LOCATIONS=$(locate -i figma.desktop)
FIGMA_LOCATION_LAST=$(echo $FIGMA_LOCATIONS | awk '{print $NF}')

FIGMA_NAME_OLD='Name=Castle Arena'
FIGMA_NAME_NEW='Name=Figma'

sudo sed -i "s/$FIGMA_NAME_OLD/$FIGMA_NAME_NEW/" $FIGMA_LOCATION_LAST

FIGMA_PATH_OLD="Exec=env BAMF_DESKTOP_FILE_HINT=\/var\/lib\/snapd\/desktop\/applications\/figma_figma.desktop \/snap\/bin\/figma"
FIGMA_PATH_NEW="Exec=env BAMF_DESKTOP_FILE_HINT=\/var\/lib\/snapd\/desktop\/applications\/figma_figma.desktop \"\/snap\/bin\/figma\""

sudo sed -i "s/$FIGMA_PATH_OLD/$FIGMA_PATH_NEW/" $FIGMA_LOCATION_LAST
