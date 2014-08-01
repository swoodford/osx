#!/bin/bash

# This script will build an OS X Mavericks Bootable Thumb Drive
# Assumptions: you have already downloaded the "Install OS X Mavericks" app from the App Store and have an 8GB or larger USB thumb drive mounted
clear
echo "List of mounted volumes:"
ls -fl /Volumes/
echo "Which volume contains your 8GB or larger thumb drive?"
echo
read VOLUME
read -p "Proceed to erase and format \"/Volumes/$VOLUME\" with OS X Mavericks? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo /Applications/Install\ OS\ X\ Mavericks.app/Contents/Resources/createinstallmedia --volume /Volumes/$VOLUME --applicationpath /Applications/Install\ OS\ X\ Mavericks.app --nointeraction
fi
