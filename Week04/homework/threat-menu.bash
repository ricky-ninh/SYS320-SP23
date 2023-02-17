#!/bin/bash

# Deliverable 2
# Storyline: Menu for getting all of the parsing threat tools together.


while getopts 'MLUWCH:' OPTION ; do

        case "$OPTION" in


                        M|m) mac_fw=${OPTION}
                        ;;
                        L|l) linux_fw=${OPTION}
                        ;;
                        U|u) url_parsing=${OPTION}
                        ;;
                        W|w) windows_parsing=${OPTION}
                        ;;
                        C|c) cisco_parsing=${OPTION}
                        ;;
                        H|h)

                                echo ""
                                echo "Usage: -M for Mac firewall parsing, -L for Linux firewall parsing, -W for Windows firewall parsing,-C for cisoco parsing, and -U for url parsing."
                                echo ""
                                exit 1

                        ;;

                        *)

                                echo "Invalid value."
                                exit 1

                        ;;
        esac

done


# Check to see if a choice was made

if [[ (${mac_fw} == "" && ${linux_fw} == "" && ${url_parsing}  == "" &&  ${windows_parsing} == "" &&  ${cisco_parsing} == ""  ) ]]
then

        echo "Please specify an option, press H for options"

fi

# Calls the bash script for Mac option

if [[ ${mac_fw} ]]
then

        bash parse-threat-mac.bash
        exit 0
fi


# Calls the bash script for the Linux option
if [[ ${linux_fw} ]]
then

        bash parse-threat-linux.bash
        exit 0

fi


# Calls the bash script for the URL option
if [[ ${url_parsing} ]]
then

        bash url-parse.bash
        exit 0

fi


# Calls the bash script for the Windows option
if [[ ${windows_parsing} ]]
then

        bash parse-threat-windows.bash
        exit 0


# Calls the bash script for the Cisco option
if [[ ${cisco_parsing} ]]
then

         bash parse-threat-cisco.bash
         exit 0





fi
