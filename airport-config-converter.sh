#!/bin/bash

##############################################################################
# Airport Configuration Reader
#
# This script processes the xml exported by the Airport Utility to produce a
# tab or comma delimited file containing the DHCP assignments, NAT port 
# mappings, and a snapshot of the outstanding leases and performance of the
# wireless clients at the time the file was exported.  The file is suitable
# for opening in excel or a text editor, where it can be formatted at will.
#
# It relies on the presence of the utility PlistBuddy, normally shipped with
# OS X, and displays an error message if it cannot find it.
#
# To use it, run the Airport Utility, select Manual Setup (command-L) and then
# File | Export Configuration to save the file on your disk.  Then run this
# script against it.
#
# This has only been really tested on my Airport Extreme, which is a dual N.
# Unfortunately your mileage may vary as I don't have any other devices...
#
# Questions, bugs, suggestions, improvements: dan at gerrity dot org.
#
# $URL: http://hints.macworld.com/article.php?story=20111226173953274
# $Source: /Users/dan/bin/RCS/apt2tsv-v $
# $Date: 2011-12-26 17:27:21-08 $
# $Revision: 1.12 $
#
###############################################################################

###############################################################################
# Variable and default definitions
#
# Default text item delimiter is a tab, the -c switch can be used for comma
# delimited.  Note that string quoting is not provided so if names have quotes
# in them, the comma delimited version may not format exactly right.

declare -a res maps leases perf
me=$(basename $0)
delimiter="\t"
kma="${HOME}/.knownmacaddresses.$(date "+%Y-%m-%d_%H.%M")"
rev="$(echo '$Revision: 1.12 $' | sed -e 's/\$//g' -e 's/ $//' -e 's/R/r/')"


###############################################################################
# Functions
###############################################################################

function usage() {
    [[ ${1} ]] && echo -e "Configuration file \"${1}\" could not be found.\n" 1>&2
    echo -e "${me} ${rev}\n" 1>&2
    echo -e "Usage: ${me} [-c] configuration[.baseconfig]\n" 1>&2
    echo -e "Option -c creates comma delimited files instead of tab delimited.\n" 1>&2
    echo "Using the AirPort Utility, select the device for which you want information, and" 1>&2
    echo "then press the \"Manual Setup\" button.  Once the configuration is loaded, use" 1>&2
    echo "the File | Export Configuration File... to save the configuration to disk." 1>&2
    echo -e "Use that file as the argument to the script.\n" 1>&2
    exit 1
}

function checkForPlistBuddy() {
    plb=$(which PlistBuddy)
    [[ (! ${plb}) && (-e /usr/libexec/PlistBuddy) ]] && plb="/usr/libexec/PlistBuddy"
    [[ ${plb} ]] && return
    echo "PlistBuddy is an application provided by Apple that processes plist files."
    echo "${me} relies on PListBuddy and it is neither in your path nor in the normal location"
    echo "/usr/libexec/PlistBuddy."
    exit 2
}

function getConfigFile() {
    filepath="${1}:./${1}:./${1}.baseconfig"
    filepath="${filepath}:${HOME}/${1}:${HOME}/${1}.baseconfig"
    filepath="${filepath}:${HOME}/Downloads/${1}:${HOME}/Downloads/${1}.baseconfig"
    filepath="${filepath}:${HOME}/Desktop/${1}:${HOME}/Desktop/${1}.baseconfig"
    oIFS="${IFS}"
    IFS=":"
    for fpn in ${filepath}; do
  if [[ -e "${fpn}" ]]; then cf="${fpn}"; break; fi
    done
    IFS="${oIFS}"
    [[ ! -e "${cf}" ]] && usage "${cf}"
}

# This function makes a poor-man's lookup table (no associative arrays in bundled bash) between
# MAC address, IP address, and host name.  
# Takes an environment variable name prefix, an address, and a description
function mungAddr() {
    munged="${1}$(echo ${2} | sed -e 's/\./x/g' -e 's/:/x/g')"
    shift; shift
    eval "${munged}=\"$*\""
}

# Creates a 12 digit number for the IP address that is sortable
function ipSort() {
    printf "%03s%03s%03s%03s" $(echo ${1} | sed 's/\./ /g')
}

# Gets some name and model parameters
function setName () {
    # n1=$(${plb} -c "print auNN" "${cf}")
    [[ ${n1} ]] && name="${n1}"
    n2=$(${plb} -c "print syDN" "${cf}")
    n3=$(${plb} -c "print syAM" "${cf}")
    if [[ (${n1}) && (${n2}) ]]; then
  [[ "${n1}" != "${n2}" ]] && name="${n1}/${n2}"
    else
  [[ (${n1}) || (${n2}) ]] && name="${n1}${n2}"
    fi
    [[ (${name}) && (${n3}) ]] && name="${name}, ${n3}"
}

# Reads the DRes key to obtain dhcp reservations, also links machine name to IP and MAC addresses
function getReservations() {
    resTitle="|Description|IP Address|MAC Address|Type"
    numres=$(${plb} -c "print DRes:dhcpReservations:" "${cf}" | grep Dict | wc | awk '{print $1}')
    for (( i=0; i<${numres}; i++ )); do
  eval $(${plb} -c "print DRes:dhcpReservations:${i}" "${cf}" | grep "=" | \
      sed -e 's/type/etype/' -e  's/[[:space:]]*\(.*\) = \(.*\)$/\1="\2"/')
  macAddress=$(echo ${macAddress} | tr "[A-F]" "[a-f]")
  mungAddr "i2h" "${ipv4Address}" "${description}"
  mungAddr "m2h" "${macAddress}"  "${description}"
  mungAddr "m2i" "${macAddress}"  "${ipv4Address}"
  res[ i ]="$(ipSort ${ipv4Address})||${description}|${ipv4Address}|${macAddress}|${etype}"
    done
}

# Reads the NAT address translations
function getMaps() {
    mapTitle="|Description|Destination|Host|TCP Public|UDP Public|TCP Private|UDP Private|"
    mapTitle="${mapTitle}Service Type|Service Name|Advertise|Enabled"
    nummaps=$(${plb} -c "print fire:entries:" "${cf}" | grep Dict | wc | awk '{print $1}')
    for (( i=0; i<${nummaps}; i++ )); do
  dest=$(${plb} -c "print fire:entries:${i}:hosts:0" "${cf}")
  hname="i2h$(echo ${dest} | sed 's/\./x/g')"
  [[ "${!hname}" == "" ]] && host="** NO DHCP **" || host="${!hname}"
  eval $(${plb} -c "print fire:entries:${i}" "${cf}" | grep "=" | grep -v hosts | \
      sed -e 's/[[:space:]]*\(.*\) = \(.*\)$/\1="\2"/' -e 's/true/yes/g' -e 's/false/no/g')
  maps[ i ]="$(ipSort ${dest})||${description}|${dest}|${host}|${tcpPublicPorts}|${udpPublicPorts}|${tcpPrivatePorts}|${udpPrivatePorts}|${serviceType}|${serviceName}|${advertiseService}|${entryEnabled}"
    done
}

# Reads the outstanding leases at the time the export was made.
function getLeases() {
    leaseTitle="|Host|IP Address|MAC Address|Lease Ends"
    numleases=$(${plb} -c "print dhSL:leases:" "${cf}" | grep Dict | wc | awk '{print $1}')
    for (( i=0; i<${numleases}; i++ )); do
  eval $(${plb} -c "print dhSL:leases:${i}" "${cf}" | grep "=" | \
      sed 's/[[:space:]]*\(.*\) = \(.*\)$/\1="\2"/')
  macAddress=$(echo ${macAddress} | tr "[A-F]" "[a-f]")
  leases[ i ]="$(ipSort ${ipAddress})||${hostname} (lease)|${ipAddress}|${macAddress}|${leaseEnds}"
    done
}

function getPerformance() {
    perfTitle="|Description|IP Address|MAC Address|Signal|Noise|Rate|Mode"
    let perfEntries=0
    numRadios=$(${plb} -c "print raSL" "${cf}" | grep "wlan.*" | wc | awk '{print $1}')
#   for some reason the wlan entries are sparse, so just from from 0 to 9    
#   for (( rad=0; rad<${numRadios}; rad++ )); do
    for (( rad=0; rad<9; rad++ )); do
  numClients=$(${plb} -c "print raSL:wlan${rad}" "${cf}" 2> /dev/null | grep "macAddress" | wc | \
      awk '{print $1}')
  for (( j=0; j<${numClients}; j++)); do
      eval macAddress=\"$(${plb} -c "print raSL:wlan${rad}:${j}:macAddress" "${cf}" 2> /dev/null | \
    tr [A-F] [a-f])\"
      for term in rssi noise txrate phy_mode; do
    eval ${term}=\"$(${plb} -c "print raSL:wlan${rad}:${j}:${term}" "${cf}" 2> /dev/null)\"
      done
      mip="m2i$(echo ${macAddress} | sed 's/:/x/g')"
      [[ ${!mip} ]] && ip=${!mip} || ip="0"
      mdesc="m2h$(echo ${macAddress} | sed 's/:/x/g')"
      [[ ${!mdesc} ]] && desc=${!mdesc} || desc="unknown"
      perf[ (( perfEntries++ )) ]="$(ipSort ${ip})||${desc}|${ip}|${macAddress}|${rssi}|${noise}|${txrate}|${phy_mode}"
  done
    done
}

function printResults() {
    echo "Airport Data taken from $(basename ${cf}) [${name}] on $(date)"; echo
    echo "DHCP RESERVATIONS IN $(basename ${cf}) [${name}]"
    echo ${resTitle} | tr "|" "${delimiter}"
    printf "%s\n" "${res[@]}" | sort | cut -f2- -d'|' | tr "|" "${delimiter}"; echo
    echo "DHCP LEASES IN $(basename ${cf}) [${name}]"
    echo ${leaseTitle} | tr "|" "${delimiter}"
    printf "%s\n" "${leases[@]}" | sort | cut -f2- -d'|' | tr "|" "${delimiter}"; echo
    echo "NAT PORT MAPPINGS IN $(basename ${cf}) [${name}]"
    echo ${mapTitle} | tr "|" "${delimiter}"
    printf "%s\n" "${maps[@]}" | sort |  cut -f2- -d'|' | tr "|" "${delimiter}"; echo
    echo "PERFORMANCE SNAPSHOT IN $(basename ${cf}) [${name}]"
    echo ${perfTitle} | tr "|" "${delimiter}"
    printf "%s\n" "${perf[@]}" | sort | cut -f2- -d'|' | tr "|" "${delimiter}"; echo
}

function printKnownMacAddresses() {
    echo "MAC ADDRESSES"
    for (( i=0; i<${#res[@]}; i++ )); do
  echo "${res[ i ]}" | sed 's/.*\|\(.*\)\|.*\|\(.*\)\|.*/\2 \1/' >> "${kma}"
    done
    for (( i=0; i<${#perf[@]}; i++ )); do
  echo "${perf[ i ]}" | sed 's/^.*\|\(.*\)\|.*\|\(.*\)\|.*\|.*\|.*\|.*$/\2 \1/' >> "${kma}"
    done
    sort "${kma}" | uniq > "${kma}.tmp" && mv "${kma}.tmp" "${kma}"
    lastmac=""
    line=""
    cat "${kma}" | while read mac rol; do
  if [[ ${mac} == ${lastmac} ]]; then
            line="${line}/${rol}"
  else
            [[ ${line} ]] && echo "$(echo ${line} | tr "|" "${delimiter}")"
            line="${mac}|${rol}"
            lastmac=${mac}
  fi
    done
}

###############################################################################

[[ ! ${1} ]] && usage

if [[ "${1}" == "-c" ]]; then
    delimiter=","
    shift
fi

while [[ "${1}" ]]; do
    getConfigFile "${1}"
    checkForPlistBuddy
    setName
    getReservations
    getLeases
    getMaps
    getPerformance
    printResults
    shift
done
printKnownMacAddresses