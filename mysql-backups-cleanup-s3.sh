#!/bin/bash

# Script to delete old database backups from the specified year and month from Amazon S3 using s3cmd
# Must have s3cmd installed and preconfigured with valid AWS IAM credentials

SAVEDIR="YOUR BACKUP FOLDER PATH HERE"
S3BUCKET="YOUR S3 BUCKET NAME HERE"
DATABASE="YOUR DATABASE NAME HERE"

clear
echo "This script will delete old database backups from Amazon S3 by deleting backups from the specified year and month."
echo
echo "Enter four digit year:"
read YEAR

if echo "$YEAR" | egrep '^[0-9]+$' >/dev/null 2>&1
  then
  if [ "$YEAR" -ge 2010 -a "$YEAR" -le 2020 ]; then
    echo "Enter two digit month:"
    read MONTH
    if echo "$MONTH" | egrep '^[0-9]+$' >/dev/null 2>&1
      then
      if [ "$MONTH" -ge 01 -a "$MONTH" -le 12 ]; then
        echo "Beginning $DATABASE cleanup for $MONTH/$YEAR."
        s3cmd del s3://$S3BUCKET/$DATABASE/$SAVEDIR/$DATABASE-$YEAR$MONTH*
        echo "$DATABASE Cleanup Completed."
      else
        echo "Out of range, Aborted."
      fi
    else
      echo "Not a number, Aborted."
    fi
    
  else
    echo "Out of range, Aborted."
  fi
else
  echo "Not a number, Aborted."
fi
