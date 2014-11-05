#!/bin/bash

echo "==================================================="
echo "This script will download and install s3cmd on OS X"
echo "==================================================="

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
