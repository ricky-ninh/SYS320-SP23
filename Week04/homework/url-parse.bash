#!/bin/bash

# Deliverable 3
# Storyline: Script to pull bad urls from a threat website


#Example file
# "type","ioc","family","country","reference"
# "ip_address","216.6.0.28","XtremeRAT","Syria","https://www.f-secure.com/weblog/archives/00002356.html"



# Checking to see if the files are there
if [[ -f "/tmp/targetedthreats.csv" ]]
then


        echo "The threat file already exists. Would you like to download it again? [y/N]"
        read to_overwrite


        if [[ "${to_overwrite}" == "N" || "{to_overwrite}" == "" ]]
        then


                echo "Thank you"
                sleep 3


        elif [[ "${to_overwrite}" == "y" ]]
        then


                echo "Downloading the file again"
                sleep 3
                wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O /tmp/targetedthreats.csv


    fi
    else

        echo "Exiting."
        echo "Downloading the required files"
        wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O /tmp/targetedthreats.csv

fi



# Getting the domains out of the csv

egrep domain /tmp/targetedthreats.csv | tee badURLs.txt

echo "class-map match-any BAD_URLS" > badURLlist.conf

awk 'BEGIN { FS = "," } { print "match protocol http host" , $2 }' badURLs.txt >> badURLlist.conf

cat badURLlist.conf
