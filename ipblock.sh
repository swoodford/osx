#!/bin/bash

# This script will read from the list of IPs and netblocks in the file ipblacklistmaster 
# Then flush iptables to prevent duplication and block each IP or netblock specified

exec &>> ~/ipblock.log
echo "============================="
date '+%c'
echo "============================="

sudo /sbin/iptables -F
while read ipblacklistmaster
do
  sudo /sbin/iptables -A INPUT -s $ipblacklistmaster -j DROP
  echo iptables updated, $ipblacklistmaster blocked
done < ipblacklistmaster

sudo /sbin/ip6tables -F
while read ipv6blacklistmaster
do
  sudo /sbin/ip6tables -A INPUT -s $ipv6blacklistmaster -j DROP
  echo ip6tables updated, $ipv6blacklistmaster blocked
done < ipv6blacklistmaster
