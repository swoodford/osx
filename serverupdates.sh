#!/bin/bash

# Script to automatically install server updates and log results to file

exec &>> ~/serverupdates.log
date '+%c'
echo "Installing updates."
sudo yum update -y
# need to test for success/failure here
echo "Updates completed."
date '+%c'
