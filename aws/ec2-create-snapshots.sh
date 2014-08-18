#!/bin/bash
# This script takes a snapshot of each EC2 volume that is tagged with Backup=1
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
  echo "Volume ID: "$VOLUME
  
  NAME=$(echo "$DESCRIBEVOLUMES" | grep Name | cut -f 3 | nl | grep -w [^0-9]$COUNT | cut -f 2)
  echo "Volume Name: "$NAME
  
  CLIENT=$(echo "$DESCRIBEVOLUMES" | grep Client | cut -f 3 | nl | grep -w [^0-9]$COUNT | cut -f 2)
  echo "Client: "$CLIENT
  
  DESCRIPTION=$NAME-$(date +%m-%d-%Y)
  echo "Snapshot Description: "$DESCRIPTION

  SNAPSHOTRESULT=$(aws ec2 create-snapshot --volume-id $VOLUME --description $DESCRIPTION)
  # echo "Snapshot result is: "$SNAPSHOTRESULT

  SNAPSHOTID=$(echo $SNAPSHOTRESULT | cut -d ' ' -f5)
  echo "Snapshot ID: "$SNAPSHOTID
  #echo $SNAPSHOTID | grep -E "snap-........"
  # sleep 3

  TAGRESULT=$(aws ec2 create-tags --resources $SNAPSHOTID --tags Key=Name,Value=$NAME Key=Client,Value=$CLIENT)
  # echo "Tag Result is: "$TAGRESULT
done

echo "====================================================="
echo " "
echo "Completed!"
echo " "
