#!/bin/bash
# This script will update your developer environment in OS X. Proceed carefully!
# Assumptions: You have Homebrew and RVM installed.

function pause(){
	read -p "Press any key to continue..."
}

read -rp "This script will update your developer environment in OS X. Proceed with installation? (y/n) " CONTINUE
if [[ $CONTINUE =~ ^([yY][eE][sS]|[yY])$ ]]; then

	echo "Update Homebrew"
	brew update

	echo "List outdated Homebrew packages"
	brew outdated

	echo "Upgrade outdated Homebrew packages"
	brew upgrade

	echo "Check Homebrew"
	brew doctor
	pause

	echo "Update pip"
	sudo easy_install -U pip

	echo "Update RVM"
	gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
	rvm get stable

	echo "Cleanup RVM"
	rvm cleanup all

	echo "Update awscli"
	pip install --upgrade awscli

	echo "Update cli53"
	sudo pip install --upgrade cli53

else
	echo "Cancelled."
	exit 1

fi
