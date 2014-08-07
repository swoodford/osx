#!/bin/bash
# This script takes a snapshot of each EC2 volume that is tagged with Backup=1
# TODO: Convert from EC2 CLI to AWS CLI
# TODO: Add error handling and loop breaks

DESCRIBEVOLUMES=$(aws ec2 describe-volumes --filter Name=tag:Backup,Values="1")

TOTALBACKUPVOLUMES=$(echo "$DESCRIBEVOLUMES" | grep Name | cut -f 3 | nl | wc -l)

echo " "
echo "====================================================="
echo "Creating EC2 Snapshots for Volumes with tag Backup=1"
echo "Snapshots to be created:"$TOTALBACKUPVOLUMES
echo "====================================================="
echo " "

START=1
for (( COUNT=$START; COUNT<=$TOTALBACKUPVOLUMES; COUNT++ ))
do
  echo "====================================================="
  echo \#$COUNT
  
  VOLUME=$(echo "$DESCRIBEVOLUMES" | cut -f 9 | nl | grep -w $COUNT | cut -f 2)
  # VOLUME=$(aws ec2 describe-volumes --filter Name=tag:Backup,Values="1" | cut -f 9 | nl | grep -w $COUNT | cut -f 2)
  echo "Volume ID: "$VOLUME
  
  NAME=$(echo "$DESCRIBEVOLUMES" | grep Name | cut -f 3 | nl | grep -w [^0-9]$COUNT | cut -f 2)
  # NAME=$(aws ec2 describe-volumes --filter Name=tag:Backup,Values="1" | grep Name | cut -f 3 | nl | grep -w [^0-9]$COUNT | cut -f 2)
  echo "Volume Name: "$NAME
  
  CLIENT=$(echo "$DESCRIBEVOLUMES" | grep Client | cut -f 3 | nl | grep -w [^0-9]$COUNT | cut -f 2)
  # CLIENT=$(aws ec2 describe-volumes --filter Name=tag:Backup,Values="1" | grep Client | cut -f 3 | nl | grep -w $COUNT | cut -f 2)
  echo "Client: "$CLIENT
  
  DESCRIPTION=$NAME-$(date +%m-%d-%Y)
  echo "Snapshot Description: "$DESCRIPTION

  # TODO: Convert from EC2 CLI to AWS CLI
  SNAPSHOTRESULT=$(ec2-create-snapshot $VOLUME -d $DESCRIPTION)
  # echo "Snapshot result is: "$SNAPSHOTRESULT

  SNAPSHOTID=$(echo $SNAPSHOTRESULT | cut -c 10-23)
  echo "Snapshot ID: "$SNAPSHOTID
  #echo $SNAPSHOTID | grep -E "snap-........"
  # sleep 3

  # TODO: Convert from EC2 CLI to AWS CLI
  TAGRESULT=$(ec2-create-tags $SNAPSHOTID --tag Client=$CLIENT --tag Name=$NAME)
  # echo "Tag Result is: "$TAGRESULT
done

echo "====================================================="
echo " "
echo "Completed!"
