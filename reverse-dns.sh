#!/bin/bash
# Programmer: Ron Guilmet
# ronpguilmet@gmail.com

# This is a Nagios plugin that will check that the 
# reverse dns will match the forward dns
#
#    Copyright (C) <2018>  <Ron Guilmet>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, version 2 only.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

# URL to Check
url=`dig +short ${1}`

# put the hostname in the ip variable
ip=$(awk '{print $1}' <<< "$url")

# get hostname from ip
getreversedns=`host ${ip} 2>/dev/null`
forwarddns=$(awk '{print $1}' <<< "$getreversedns")

# remove in-addr.arpa from the end 
octet1=$(cut -d'.' -f1 <<< "$forwarddns")
octet2=$(cut -d'.' -f2 <<< "$forwarddns")
octet3=$(cut -d'.' -f3 <<< "$forwarddns")
octet4=$(cut -d'.' -f4 <<< "$forwarddns")
reversedns="$octet4."
reversedns+="$octet3."
reversedns+="$octet2."
reversedns+=$octet1

# check the reversed ip against the forward ip
if [ "$reversedns" != "$ip" ]; then
	echo "CRITICAL | Reverse DNS Fail"
	exit 2
else
	echo "OK | Reverse DNS Pass"
	exit 0
fi
