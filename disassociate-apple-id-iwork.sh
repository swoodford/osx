#!/bin/bash

# This script will safely disassociate an Apple ID from iWork applications Keynote, Numbers and Pages
# Allowing a new Apple ID sign in to enable updating the applications again from the Mac App Store


if [ -d "/Applications/Keynote.app/Contents/_MASReceipt" ]; then
	sudo mv /Applications/Keynote.app/Contents/_MASReceipt /Applications/Keynote.app/Contents/_MASReceipt_disabled
fi

if [ -d "/Applications/Numbers.app/Contents/_MASReceipt" ]; then
	sudo mv /Applications/Numbers.app/Contents/_MASReceipt /Applications/Numbers.app/Contents/_MASReceipt_disabled
fi

if [ -d "/Applications/Pages.app/Contents/_MASReceipt" ]; then
	sudo mv /Applications/Pages.app/Contents/_MASReceipt /Applications/Pages.app/Contents/_MASReceipt_disabled
fi

echo "Done!"

open -a "/Applications/App Store.app"
