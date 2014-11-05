#!/bin/bash

# Bash profile customizations

read -rp "This script will add extra features to customize your bash profile, proceed ? (y/n) " CONTINUE
if [[ $CONTINUE =~ ^([yY][eE][sS]|[yY])$ ]]; then
	touch ~/.bash_profile

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

	echo "if [ -f ~/.git-completion.bash ]; then" >> ~/.bash_profile
	echo "	. ~/.git-completion.bash" >> ~/.bash_profile
	echo "fi" >> ~/.bash_profile

	# Tell ls to be colorful
	echo "export CLICOLOR=1" >> ~/.bash_profile
	echo "export LSCOLORS=eafxcxdxbxegedabagacad" >> ~/.bash_profile

	# Tell grep to highlight matches
	echo "export GREP_OPTIONS='--color=auto'" >> ~/.bash_profile

	# Add alias for ll
	echo "alias ll='ls -fl'" >> ~/.bash_profile

	# Source in .profile
	if [ -f ~/.profile ]; then
		echo "source ~/.profile" >> ~/.bash_profile
	fi

	# Set Java HOME
	if ! grep -q "JAVA_HOME" ~/.bash_profile; then
		echo "export JAVA_HOME=`/usr/libexec/java_home -v1.8`" >> ~/.bash_profile
	fi

	if ! grep -q "PATH" ~/.bash_profile; then
		echo "export PATH=/usr/local/bin:\$PATH" >> ~/.bash_profile
	fi

fi
