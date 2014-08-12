#!/bin/bash
CLEAR
ECHO "==================================================="
ECHO "This script will download and install s3cmd on OS X"
ECHO "==================================================="
mkdir ~/s3cmd
cd ~/s3cmd
ECHO "Downloading"
curl -L -o 's3cmd-1.5.0-beta1.tar.gz' 'http://downloads.sourceforge.net/project/s3tools/s3cmd/1.5.0-beta1/s3cmd-1.5.0-beta1.tar.gz'
ECHO "Extracting"
gunzip -c s3cmd-1.5.0-beta1.tar.gz | tar xopf -
cd s3cmd-1.5.0-beta1
ECHO "Installing"
python setup.py install
ECHO "Installation Completed"
s3cmd --configure
