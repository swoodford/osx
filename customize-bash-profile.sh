#!/bin/bash

# Put Your Git Branch in Your Bash Prompt
# http://code-worrier.com/blog/git-branch-in-bash-prompt/
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh

# Load in the git branch prompt script.
source ~/.git-prompt.sh

# Copy this into your .bash_profile
# export PS1="\h\[\e[32;1m\] \w\[\e[32;1m\] \$(__git_ps1) \[\e[0m\]"
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
