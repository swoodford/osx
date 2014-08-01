#!/bin/bash

# This script is to sync authorized ssh keys on all servers with a master list.
# It will read from the list of servers in the file serverlist,
# ssh into each server in the list and overwrite the remote authorized_keys file with the local authorized_keys file

while read SERVER
do
  # need to check if file exists, do some validation before overwriting, maybe add a prompt to confirm before running
  scp authorized_keys $SERVER:~/.ssh/authorized_keys
  # need to test for success/failure here
  echo $SERVER updated
done < serverlist
