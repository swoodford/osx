#!/bin/bash

# This script will read from the list of IPs and netblocks in the file ipblacklistmaster 
# Then flush iptables to prevent duplication and block each IP or netblock specified

exec &>> ~/ipblock.log
date '+%c'
sudo /sbin/iptables -F
while read ipblacklistmaster
do
  sudo /sbin/iptables -A INPUT -s $ipblacklistmaster -j DROP
  # need to test for success/failure here
  echo iptables updated, $ipblacklistmaster blocked
done < ipblacklistmaster
