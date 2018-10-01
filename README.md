osx
=======

A collection of shell scripts meant to be run in OS X for automating various tasks

[![Build Status](https://travis-ci.org/swoodford/osx.svg?branch=master)](https://travis-ci.org/swoodford/osx)

- **[airport-config-converter.sh](airport-config-converter.sh)** Convert exported Apple AirPort baseconfig file to nice clean human readable comma delimited file. Usage: airport-config-converter.sh -c airport.baseconfig > airport.baseconfig.csv
- **[backup-to-network-drive.sh](backup-to-network-drive.sh)** Backup specified local folder to network share drive over AFP
- **[bluetooth-fix.sh](bluetooth-fix.sh)** Fix Bluetooth by removing the Bluetooth.plist file
- **[build-el-capitan-bootable-usb.sh](build-el-capitan-bootable-usb.sh)** Build an OS X El Capitan Bootable Thumb Drive
- **[build-mavericks-bootable-usb.sh](build-mavericks-bootable-usb.sh)** Build an OS X Mavericks Bootable Thumb Drive
- **[build-yosemite-bootable-usb.sh](build-yosemite-bootable-usb.sh)** Build an OS X Yosemite Bootable Thumb Drive
- **[convert-yosemite-beta-virtualbox.sh](convert-yosemite-beta-virtualbox.sh)** Convert the OS X Yosemite Beta installer app to a format that is compatible with VirtualBox
- **[customize-bash-profile.sh](customize-bash-profile.sh)** Bash profile customizations
- **[disassociate-apple-id-iwork.sh](disassociate-apple-id-iwork.sh)** Disassociate an Apple ID from iWork applications, allowing a new Apple ID sign in and App Store updates
- **[install-s3cmd-osx.sh](install-s3cmd-osx.sh)** Install s3cmd on OS X
- **[Make Animated GIF.workflow](Make%20Animated%20GIF.workflow)** Automator script to generate an animated gif from two or more files selected in Finder using Quick Actions
- **[mysql-backups-cleanup-s3.sh](mysql-backups-cleanup-s3.sh)** Delete old database backups from AWS S3
- **[Restart AirPort Extreme Router.scpt](Restart%20AirPort%20Extreme%20Router.scpt)** AppleScript to Restart AirPort Extreme Router
- **[Restart AirPort Extreme Router.app](Restart%20AirPort%20Extreme%20Router.app)** Exported AppleScript application to Restart AirPort Extreme Router
- **[Restart Apple Mail.workflow](Restart%20Apple%20Mail.workflow)** Automator script to Restart Apple Mail
- **[server-security-updates.sh](server-security-updates.sh)** Run locally (on OS X) to apply updates in serverupdates.sh script
- **[serverupdates.sh](serverupdates.sh)** Automatically install server updates and log results to file
- **[setup-developer-environment.sh](setup-developer-environment.sh)** Setup a new developer environment in OS X
- **[syncSSHkeys.sh](syncSSHkeys.sh)** Sync authorized ssh keys on all servers with a master list
- **[update-developer-environment.sh](update-developer-environment.sh)** Update developer environment in OS X
