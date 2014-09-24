#!/bin/bash

# This script will read from the list of servers in the file ipblacklistservers
# copy the block list and block script to each server specified in the list
# then execute the script ipblock.sh to block the servers

while read ipblacklistservers
do
  scp ipblock.sh ipblacklistmaster $ipblacklistservers:~
  echo Blocking IPs on $ipblacklistservers
  ssh -n $ipblacklistservers '(./ipblock.sh &)' >> ipblock.log
  # need to test for success/failure here
  echo $ipblacklistservers Done
done < ipblacklistservers
