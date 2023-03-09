#!/bin/bash

# Parse Apache log and formats it into a readable way
# Example: 101.236.44.127 - - [24/Oct/2017:04:11:14 -0500] "GET / HTTP/1.1" 200 225 "-" "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.94 Safari/537.36"

# Read in file

# Arguments using the position, they start at $1
APACHE_LOG="$1"

# Checks to see if the file exists
read -p "Please enter an apache log file: "

if [[ ! -f ${APACHE_LOG} ]]
then
        echo "The file doesn't exist."
        exit 1
fi

# Example: 101.236.44.127 - - [24/Oct/2017:04:11:14 -0500] "GET / HTTP/1.1" 200 225 "-" "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.94 Safari/537.36"
# Looking for web scanners
sed -e 's/\[//g' -e 's/\"//g' "${APACHE_LOG}" | \
grep -Ei 'test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t' | \
awk ' BEGIN { format = "%-15s %-20s %-6s %-6s %-5s %s\n"
                printf format, "IP", "Date", "Method", "Status", "Size", "URI"
                printf format, "--", "----", "------", "------", "----", "---" }

# Prints the format into the apachelogfile.txt
{ printf format, $1, $4, $6, $9, $10, $7 } ' | tee -a apachelogfile.txt

grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' apachelogfile.txt | sort -u | tee blockedIPs.txt

for badIP in $(cat blockedIPs.txt)
do
        echo "netsh advfirewall firewall add rule name=\"BLOCK IP Address - ${badIP}\" dir=in action=block remoteip=${badIP}" | tee -a blockedIPs.ps1
		echo "iptables -A INPUT -s ${badIP} -j DROP" | tee -a blockedIPstable.txt
done