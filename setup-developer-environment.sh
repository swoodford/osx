#!/bin/bash
# This script will setup a new developer environment in OS X. Proceed carefully!
# Assumptions: Fresh OS X install, nothing else installed/configured

function pause(){
	# read -p "Press any key to continue..."
	echo ""
}

function homebrew(){
	brew install $*
}

read -rp "This script will setup a new developer environment in OS X, Proceed with installation? (y/n) " CONTINUE
if [[ $CONTINUE =~ ^([yY][eE][sS]|[yY])$ ]]; then

	echo "Show Hidden Files (Mavericks/Yosemite/El Capitan)"
	defaults write com.apple.finder AppleShowAllFiles -boolean true ; killall Finder
	# defaults write com.apple.finder AppleShowAllFiles YES && killall Finder

	echo "Install Sublime Text"
	open http://www.sublimetext.com/2
	pause

	echo "Link Sublime command line utility"
	sudo mkdir -p /usr/local/bin
	sudo ln -s "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl

	echo "Install Sublime Text Package Control"
	open https://packagecontrol.io/installation

	if ! [ -f ~/.bash_profile ]; then
		# Bash profile customizations
		touch ~/.bash_profile
		
		# Add alias for ll
		echo "alias ll='ls -fl'" >> ~/.bash_profile

		# Add alias for git clone
		echo "alias gc='git clone'" >> ~/.bash_profile
		
		# Setup custom command prompt in your .bash_profile
		echo 'export PS1="\h\[\e[32;1m\] \w\[\e[32;1m\] \$(__git_ps1) \[\e[0m\]"' >> ~/.bash_profile

		# Put Your Git Branch in Your Bash Prompt
		# http://code-worrier.com/blog/git-branch-in-bash-prompt/
		curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh

		# Load in the git branch prompt script in your bash profile.
		echo "if [ -f ~/.git-prompt.sh ]; then" >> ~/.bash_profile
		echo "	source ~/.git-prompt.sh" >> ~/.bash_profile
		echo "fi" >> ~/.bash_profile

		# Autocomplete Git Commands and Branch Names in Bash
		# http://code-worrier.com/blog/autocomplete-git/
		curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash

		# Add the following lines to your .bash_profile
		echo "if [ -f ~/.git-completion.bash ]; then" >> ~/.bash_profile
		echo "	. ~/.git-completion.bash" >> ~/.bash_profile
		echo "fi" >> ~/.bash_profile

		# Tell ls to be colorful
		echo "export CLICOLOR=1" >> ~/.bash_profile
		echo "export LSCOLORS=eafxcxdxbxegedabagacad" >> ~/.bash_profile

		# Tell grep to highlight matches
		echo "export GREP_OPTIONS='--color=auto'" >> ~/.bash_profile

		# Source in .profile
		if [ -f ~/.profile ]; then
			echo "source ~/.profile" >> ~/.bash_profile
		fi

		echo "Make sure to prepend '/usr/local/bin:' to very beginning of PATH statement in ~/.bash_profile"
		
		echo "export PATH=/usr/local/bin:\$PATH" >> ~/.bash_profile
	fi

	# Make nano colorful
	find /usr/share/nano/ -iname "*.nanorc" -exec echo include {} \; >> ~/.nanorc

	# Add gitconfig for customization later
	if ! [ -f ~/.gitconfig ]; then
		touch ~/.gitconfig
		cat git/.gitconfig >> ~/.gitconfig
	fi

	echo "Install Xcode command line tools"
	xcode-select --install
	pause

	echo "Download Xcode from Apple Dev site"
	open "https://developer.apple.com/downloads/index.action"
	pause

	read -rp "Warning: Do not proceed until Xcode command line tools have been installed. Continue? (y/n) " XCODE
	if [[ $XCODE =~ ^([yY][eE][sS]|[yY])$ ]]; then

		echo "Install Homebrew"
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		brew update
		brew doctor

		echo "Install updated git"
		homebrew 'git'

		git --version

		echo "Version should be ≥ git version 2.6.3, if not check $PATH or restart terminal"
		pause


		read -rp "Install Ruby on Rails environment? (y/n) " RUBY
		if [[ $RUBY =~ ^([yY][eE][sS]|[yY])$ ]]; then


			echo "Speed up gem installation by disabling documentation"
			if ! -f ~/.gemrc; then
				touch ~/.gemrc
			fi

			if ! grep -q "no-document" ~/.gemrc; then
				echo "gem: --no-document" >> ~/.gemrc
			fi

			read -rp "Install RVM with Ruby, which Ruby version? (ex. 1.9.3, 2.0.0) " RUBYV

			gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3

			curl -sSL https://get.rvm.io | bash -s stable --auto-dotfiles --autolibs=enable --ruby=$RUBYV

			source ~/.rvm/scripts/rvm
			source ~/.bash_profile

			echo "Update RVM"
			rvm get stable

			echo "Cleanup RVM"
			rvm cleanup all

			echo "Set default global ruby version"

			rvm use $RUBYV --default

			echo "Set local ruby version"

			rvm use $RUBYV

			ruby -v

			# echo "Should be ≥ ruby 1.9.3p547"
			pause

			which ruby

			echo "Should show ~/.rvm/rubies/ruby-x.y.z.version/bin/ruby"
			pause

			echo "Install Rails"

			gem install rails

			rails -v

			echo "Should be ≥ Rails 4.2.0"
			pause

			echo "Update RubyGems"

			gem update --system

			gem -v

			echo "Should be ≥ RubyGems 2.4.5"
			pause
		fi

		echo "Install extra brew packages"

		homebrew 'mysql'

		# Make mysql usable
		unset TMPDIR
		mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp
		# mysql.server start

		homebrew 'imagemagick'

		homebrew 'gpg'

		homebrew 'node'

		homebrew 'python'

		python --version

		echo "python --version Should be ≥ Python 2.7.10, if not check $PATH or restart terminal"
		pause

		echo "Check Java version"

		java -version

		echo "Install Java JDK 8"

		open "http://www.oracle.com/technetwork/java/javase/downloads/index.html"
		pause

		read -rp "Warning: Do not proceed until Java JDK has been installed. Continue? (y/n) " JAVA
		if [[ $JAVA =~ ^([yY][eE][sS]|[yY])$ ]]; then
			echo "Set JAVA_HOME"

			if ! grep -q "JAVA_HOME" ~/.bash_profile; then
				echo 'export JAVA_HOME=$(/usr/libexec/java_home)' >> ~/.bash_profile
			fi
		fi

		echo "Install s3cmd"
		command -v s3cmd >/dev/null 2>&1 || {
			cd ~
			git clone https://github.com/s3tools/s3cmd.git
			cd s3cmd
			sudo python setup.py install
			read -rp "Configure s3cmd? (y/n) " CONFIGURE
			if [[ $CONFIGURE =~ ^([yY][eE][sS]|[yY])$ ]]; then
				s3cmd --configure
			fi
		}

		echo "Install AWS CLI"
		sudo pip install awscli

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
