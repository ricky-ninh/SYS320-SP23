#!/bin/bash

# Storyline: Extract IPs from emergingthreats.net and create a firewall ruleset

# alert tcp [2.59.200.0/22,5.134.128.0/19,5.180.4.0/22,5.183.60.0/22,5.188.10.0/23, 24.137.16.0/20,24.170.208.0/20,24.233.0.0/19,24.236.0.0/19,27.126.160.0/20,27.146.0.0/16,
# 31.14.65.0/24,36.0.8.0/21,36.37.48.0/20,36.116.0.0/16,36.119.0.0/16,37.156.64.0/23,37.156.173.0/24,41.72.0.0/18,42.0.32.0/19] any -> $HOME_NET any (msg:"ET DROP Spamhaus DROP Listed Traffic Inbound group 1"; flags:S; reference:url,www.spamhaus.org/drop/drop.lasso; threshold: type limit, track by_src, seconds 3600, count 1; classtype:misc-attack; flowbits:set,ET.Evil; flowbits:set,ET.DROPIP; sid:2400000; rev:3530; metadata:affected_product Any, attack_target Any, deployment Perimeter, tag Dshield, signature_severity Minor, created_at 2010_12_30, updated_at 2023_02_15;)

# Regex to extract the networks
# 5.              134.                128.               0/          22

#wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules



if [[ -f "/tmp/emerging-drop.suricata.rules" ]]
then


        echo "The threat intel file already exists. Would you like to download it again? [Y/N] "
        read to_overwrite


        if [[ "${to_overwrite}" == "N" || ${to_overwrite} == "" ]]
        then


                echo "Thank you"
                sleep 3


        elif [[ "${to_overwrite}" == "Y"  ]]
        then

                echo "Downloading the file again. One moment please."
                sleep 3
                wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules
        fi
        else

                echo "Downloading the required files"
                wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules
fi



egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.suricata.rules | sort -u | tee badIPs.txt



# Create a firewall ruleset
for eachIP in $(cat badIPs.txt)
do


        echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPS.windows

done