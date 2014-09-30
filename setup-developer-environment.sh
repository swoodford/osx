#!/bin/bash
# This script will setup a new developer environment in OS X, it is untested and considered experimental. Proceed carefully!

function pause(){
	read -p "Press any key to continue..."
}

function homebrew(){
	brew install $*
}

read -rp "This script will setup a new developer environment in OS X, it is untested and considered experimental. Proceed with installation? (y/n) " CONTINUE
if [[ $CONTINUE =~ ^([yY][eE][sS]|[yY])$ ]]; then

	echo "Show Hidden Files (Mavericks)"
	defaults write com.apple.finder AppleShowAllFiles YES

	echo "Install Xcode (unreliable)"
	xcode-select --install
	pause

	echo "Download Xcode from Apple Dev site"
	open "https://developer.apple.com/downloads/index.action"
	pause

	read -rp "Warning: Do not proceed until Xcode has been installed. Has Xcode finished installation? (y/n) " XCODE
	if [[ $XCODE =~ ^([yY][eE][sS]|[yY])$ ]]; then

		echo "Install Homebrew"
		ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

		brew doctor

		echo "Make sure to prepend '/usr/local/bin:' to very beginning of PATH statement in ~/.bash_profile"
		pause
		echo "export PATH=/usr/local/bin:$PATH" >> ~/.bash_profile

		echo "Install updated git"

		homebrew 'git'

		git --version

		echo "Version should be ≥ git version 2.0.4, if not check $PATH or restart terminal"
		pause

		echo "Speed up gem installation by disabling documentation"
		echo "gem: --no-document" >> ~/.gemrc

		echo "Install RVM with Ruby 1.9.3"

		curl -sSL https://get.rvm.io | bash -s stable --ruby=1.9.3

		echo "Set default global ruby version"

		rvm use 1.9.3 --default

		echo "Set local ruby version"

		rvm use 1.9.3

		ruby -v

		echo "Should be ≥ ruby 1.9.3p547"
		pause

		which ruby

		echo "Should show ~/.rvm/rubies/ruby-1.9.3-p547/bin/ruby"
		pause

		echo "Update RubyGems"

		gem update --system

		gem -v

		echo "Should be ≥ 2.4.1"
		pause

		echo "Install Rails"

		gem install rails

		rails -v

		echo "Should be ≥ Rails 4.1.4"
		pause

		echo "Install extra brew packages"

		homebrew 'mysql'

		homebrew 'imagemagick'

		homebrew 'gpg'

		homebrew 'python'

		echo "python --version Should be ≥ Python 2.7.8, if not check $PATH or restart terminal"

		echo "Install Java JDK 8"

		open "http://www.oracle.com/technetwork/java/javase/downloads/index.html"
		pause

		echo "Set JAVA_HOME"
		echo "export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_11.jdk/Contents/Home" >> ~/.bash_profile

		echo "Install s3cmd"
		wget http://downloads.sourceforge.net/project/s3tools/s3cmd/1.5.0-beta1/s3cmd-1.5.0-beta1.tar.gz
		tar xzf s3cmd-1.5.0-beta1.tar.gz
		cd s3cmd-1.5.0-beta1
		python setup.py install

		read -rp "Configure s3cmd? (y/n) " CONFIGURE
		if [[ $CONFIGURE =~ ^([yY][eE][sS]|[yY])$ ]]; then
			s3cmd --configure
		fi

		echo "Install AWS CLI"
		pip install awscli

		read -rp "Configure AWS CLI? (y/n) " CONFIGURE
		if [[ $CONFIGURE =~ ^([yY][eE][sS]|[yY])$ ]]; then
			aws configure
			complete -C '/usr/local/aws/bin/aws_completer' aws
		fi
	else
		echo "Xcode must be installed before continuing."
		exit 1
	fi
else
	echo "Cancelled."
	exit 1
fi

