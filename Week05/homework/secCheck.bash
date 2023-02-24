 #!/bin/bash
 
 # Storyline: Script to perform local security checks

function checks() {

        if [[ $2 !=  $3  ]]
        then

				echo -e "\e[1;31mThe $1 is not compliant. The current policy should be: $2. The current value is: $3.\e[0m"
 
        else
 
                echo -e "\e[1;32mThe $1 is compliant. Current Value $3.\e[0m"
 
        fi
}
 
 # Check the password max days policy
 pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2 } ')
 
 # Check for password max
 #                 $1         $2      $3
 checks "Password Max Days" "365" "${pmax}"
 25
 # Checks the password minimum days between changes
 pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' { print $2 } ')
 checks "Password Minimum Days" "14" "${pmin}"
 
 # Checks the password warning age
 pwarn=$(egrep -i '^PASS_WARN_AGE' /etc/login.defs | awk ' { print $2 } ')
 checks "Password Warning Days" "7" "${pwarn}"
 
 # Checks the SSH UsePam configuration
chkSSHPAM=$(egrep -i "^UsePAM" /etc/ssh/sshd_config | awk ' { print $2 } ')
checks "SSH UsePAM" "yes" "${chkSSHPAM}"
 
# Check permissions on users home directory 
echo ""
for eachDir in $(ls -l /home | egrep '^d' | awk ' { print $3 } ')
do

        chDir=$(ls -ld /home/${eachDir} | awk ' { print $1 }')
        checks "Home directory ${eachDir}" "drwx------" "${chDir}"
done


# Week 5 Linux Audit Script Update Homework Assignment


# Ensure  IP forwarding is disabled
ipforward=$(egrep -i "^net.ipv4.ip_forward" /etc/sysctl.conf | awk ' { print $3 } ')
echo ""
checks "IP forwarding" "0" "${ipforward}" "Edit /etc/sysctl.conf and set: \nnet.ipv4.ip_forward = ${IPf}\nto\nnet.ipv4.ip_forward = 0\nThen run:\nsysctl -w net.ipv4.ip_forward=0\nAlso run:\nsysctl -w net.ipv4.route.flush=1"


# Ensure ICMP redirects aren't accepted
icmpa=$(egrep -i "^net.ipv4.conf.all.accept_redirects" /etc/sysctl.conf | awk ' { print $3 } ')
echo ""
checks "ICMP all redirects" "0" "${icmpa}" "Edit /etc/sysctl.conf and set: \nnet.ipv4.conf.all.accept_redirects = ${ICMPa}\nto\nnet.ipv4.conf.all.accept_redirects = 0\nThen run:\nsysctl -w net.ipv4.conf.all.accept_redirects=0\nsysctl -w net.ipv4.route.flush=1"


# Ensure permissions on /etc/crontab are configured
dir=$(ls -ld /etc/crontab | awk ' { print $1 } ' | cut -d. -f1 )
echo ""
checks "crontab file" "-rw-------" "${Dir}" "Run the command:\nsudo chmod 600 /etc/crontab"





# Ensure permissions on /etc/cron.hourly are configured
dir=$(ls -ld /etc/cron.hourly | awk ' { print $1 } ' | cut -d. -f1 )
echo ""
checks "cron.hourly file" "drwx------" "${Dir}" "Run the command:\nsudo chmod 700 /etc/cron.hourly"


# Ensure permissions on /etc/cron.daily are configured
dir=$(ls -ld /etc/cron.daily | awk ' { print $1 } ' | cut -d. -f1 )
echo ""
checks "cron.daily file" "drwx------" "${Dir}" "Run the command:\nsudo chmod 700 /etc/cron.daily"


# Ensure permissions on /etc/cron.weekly are configured
dir=$(ls -ld /etc/cron.weekly | awk ' { print $1 } ' | cut -d. -f1 )
echo ""
checks "cron.weekly file" "drwx------" "${Dir}" "Run the command:\nsudo chmod 700 /etc/cron.weekly"


# Ensure permissions on /etc/cron.monthly are configured
dir=$(ls -ld /etc/cron.monthly | awk ' { print $1 } ' | cut -d. -f1 )
echo ""
checks "cron.monthly file" "drwx------" "${Dir}" "Run the command:\nsudo chmod 700 /etc/cron.monthly"


# Ensure permissions on /etc/passwd are configured
dir=$(ls -ld /etc/passwd | awk ' { print $1 } ' | cut -d. -f1 )
echo ""
checks "passwd file" "-rw-r--r--" "${Dir}" "Run the command:\nsudo chmod 644 /etc/passwd"

# Ensure permissions on /etc/shadow are configured
dir=$(ls -ld /etc/shadow | awk ' { print $1 } ' | cut -d. -f1 )
echo ""
checks "shadow file" "-rw-r-----" "${Dir}" "Run the command:\nsudo chmod 640 /etc/shadow"


# Ensure permissions on /etc/group are configured
dir=$(ls -ld /etc/group | awk ' { print $1 } ' | cut -d. -f1 )
echo ""
checks "group file" "-rw-r--r--" "${Dir}" "Run the command:\nsudo chmod 644 /etc/group"


# Ensure permissions on /etc/gshadow are configured
Dir=$(ls -ld /etc/gshadow | awk ' { print $1 } ' | cut -d. -f3 )
echo ""
checks "gshadow file" "-rw-r-----" "${Dir}" "Run the command:\nsudo chmod 640 /etc/gshadow"

# Ensure permissions on /etc/passwd- are configured
Dir=$(ls -ld /etc/passwd- | awk ' { print $1 } ' | cut -d. -f1 )
echo ""
checks "passwd- file" "-rw-r--r--" "${Dir}" "Run the command:\nsudo chmod 644 /etc/passwd-"


# Ensure permissions on /etc/shadow- are configured
Dir=$(ls -ld /etc/shadow- | awk ' { print $1 } ' | cut -d. -f1 )
echo ""
checks "shadow- file" "-rw-r-----" "${Dir}" "Run the command:\nsudo chmod 640 /etc/shadow-"


# Ensure no legacy "+" entries exist in /etc/passwd
legchk=$(egrep -i '^\+:' /etc/passwd)
echo ""
checks "Legacy Entries /etc/passwd" "" "${legchk}" "Remove any legacy '+' entries from /etc/passwd if they exist"


# Ensure no legacy "+" entries exist in /etc/shadow
legshadow=$(egrep -i '^\+:' /etc/shadow)
echo ""
checks "Legacy Entries /etc/shadow" "" "${legshadow}" "Remove any legacy '+' entries from /etc/shadow if they exist"


# Ensure no legacy "+" entries exist in /etc/group
leggroup=$(egrep -i '^\+:' /etc/group)
echo ""
checks "Legacy Entries /etc/group" "" "${leggroup}" "Remove any legacy '+' entries from /etc/group if they exist"


# Ensure root is the only UID 0 account
uid=$(cat /etc/passwd | awk -F: '($3 == 0) { print $1 }')
echo ""
checks "Root UID" "root" "${uid}" "Remove any users other than root with UID 0 or assign them a new UID if appropriate"