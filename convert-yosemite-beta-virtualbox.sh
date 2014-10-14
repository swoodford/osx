#!/bin/bash

# This script will convert the OS X Yosemite Beta installer app to a format that is compatible with VirtualBox
# Assumptions: you have already signed up here: https://appleseed.apple.com/sp/betaprogram/ and downloaded the "OS X Yosemite Beta 4" app from the App Store

gem install iesd
iesd -i /Applications/Install\ OS\ X\ Yosemite\ Beta.app -o yosemite.dmg -t BaseSystem
iesd -i /Applications/Install\ OS\ X\ Yosemite\ Beta\ Converted\ 4.app -o yosemite.dmg -t BaseSystem
hdiutil convert yosemite.dmg -format UDSP -o yosemite.sparseimage
hdiutil mount /Applications/Install\ OS\ X\ Yosemite\ Beta.app/Contents/SharedSupport/InstallESD.dmg
hdiutil mount yosemite.sparseimage
cp /Volumes/OS\ X\ Install\ ESD/BaseSystem.* /Volumes/OS\ X\ Base\ System/
hdiutil unmount /Volumes/OS\ X\ Install\ ESD/
hdiutil unmount /Volumes/OS\ X\ Base\ System/
hdiutil attach yosemite.sparseimage
hdiutil detach /Volumes/OS\ X\ Base\ System/
hdiutil convert yosemite.sparseimage -format UDZO -o Yosemite-Virtualbox-4.dmg
