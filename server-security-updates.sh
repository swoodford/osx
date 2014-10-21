#!/bin/bash

# This script will read from the list of servers in the file serverupdatelist, 
# ssh into each server in the list and run the command specified in the script serverupdates.sh


while read serverupdatelist
do
  scp serverupdates.sh $serverupdatelist:~/
  echo Installing Updates on $serverupdatelist
  ssh -n $serverupdatelist '(./serverupdates.sh &)' #>> serverupdates.log
  # need to test for success/failure here
  echo $serverupdatelist Updated
done < serverupdatelist
