#!/bin/bash

# This setting will disable macOS Mojave Dark Mode for Microsoft Outlook

defaults write com.microsoft.Outlook NSRequiresAquaSystemAppearance -bool yes
