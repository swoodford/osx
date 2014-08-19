#!/bin/bash

# Bash profile customizations

# Put Your Git Branch in Your Bash Prompt
# http://code-worrier.com/blog/git-branch-in-bash-prompt/
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh

# Load in the git branch prompt script in your bash profile.
echo "source ~/.git-prompt.sh" >> ~/.bash_profile

# Setup custom command prompt in your .bash_profile
echo 'export PS1="\h\[\e[32;1m\] \w\[\e[32;1m\] \$(__git_ps1) \[\e[0m\]"' >> ~/.bash_profile

# Autocomplete Git Commands and Branch Names in Bash
# http://code-worrier.com/blog/autocomplete-git/
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash

# Add the following lines to your .bash_profile
echo "if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi" >> ~/.bash_profile

# Tell ls to be colorful
# export CLICOLOR=1
# export LSCOLORS=eafxcxdxbxegedabagacad
echo "export CLICOLOR=1
export LSCOLORS=eafxcxdxbxegedabagacad" >> ~/.bash_profile

# Tell grep to highlight matches
# export GREP_OPTIONS='--color=auto'
echo "export GREP_OPTIONS='--color=auto'" >> ~/.bash_profile

# Add alias for ll
echo "alias ll='ls -fl'" >> ~/.bash_profile

# Source in .profile
echo "source ~/.profile" >> ~/.bash_profile

# Load RVM into a shell session *as a function*
echo "[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"" >> ~/.bash_profile

# Set Java HOME
echo "export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_11.jdk/Contents/Home" >> ~/.bash_profile

