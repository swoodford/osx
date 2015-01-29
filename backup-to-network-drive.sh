#!/bin/bash
# Script to backup specified folder from local user's computer to network drive over AFP

# Set the path to your local folder that is to be backed up
LOCALBACKUPFOLDER="~/backupfolder"

# Set the path on the remote drive to your backup folder destination
REMOTEPATH="/Remote/Path/"

# Set the remote drive folder and fileserver name
MOUNTPOINT="/Volumes"
FOLDER="/Network_Share"
FILESERVER="HOST_NAME._afpovertcp._tcp.local"

# Detect the username and password needed to logon to the drive
USER=$(security find-internet-password -s $FILESERVER | grep "acct" | cut -d '"' -f 4)
PW=$(security find-internet-password -ws $FILESERVER)

# Check if already mounted
if ! [ -d $MOUNTPOINT$FOLDER ]; then
	# Mount if not mounted yet
	mkdir $MOUNTPOINT$FOLDER
	mount -t afp afp://$USER:$PW@$FILESERVER$FOLDER $MOUNTPOINT$FOLDER
fi

echo "Beginning backup..."
rsync -r $LOCALBACKUPFOLDER $MOUNTPOINT$FOLDER$REMOTEPATH
echo "Backup completed!"

# Unmount fileserver
umount -f $MOUNTPOINT$FOLDER
