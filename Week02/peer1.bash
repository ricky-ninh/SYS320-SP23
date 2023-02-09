#!/bin/bash

# Storyline: Create a peer VPN configuration file



# What is peer's name
echo -n "What is the peer's name? "
read the_client

# Filename variable
pFile="${the_client}-wg0.conf"

echo "${pFile}"

# Check if the peer file exists
if [[ -f "${pFile}"  ]]
then 

	# Prompt if we need to overwrite the file
	echo "The file ${pFile} exists."
	echo -n "Do you want to overwrite it? [y|N]"
	read to_overwrite

	if [[  "${to_overwrite}" == "N" || "${to_overwrite}" == ""  ]]
	then

		echo "Exit..."
		exit 0

	elif [[ "${to_overwrite}" == "y" ]]

		echo "Creating the wireguard configuration file..."

        # If the admin doesn't specify a y or N then error.
        else


		echo "Invalid value"
		exit 1

	fi

fi


# Create a private key
p="$(wg genkey)"

# Create a public key
clientPub="$(echo ${p} | wg pubkey)"


# Generate a preshared key
pre="$(wg genpsk)"

# Client configuration sample 10.0.0.1/24,172.16.28.0/24,162.243.2.92:51820 /y6z1o8iyo+Jp2KFNByKbe7ysaR6nmYnwKGiU5Zq5BA= 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0"

# Endpoint
end="$(head -1 wg0.conf | awk ' { print $3 } ')"

# Server Public Key
pub="$(head -1 wg0.conf | awk ' { print $4 } ')"

# DNS servers
dns="$(head -1 wg0.conf | awk ' { print $5 } ')"

# MTU
mtu="$(head -1 wg0.conf | awk ' { print $6 } ')"

# KeepAlive
keep="$(head -1 wg0.conf | awk ' { print $7 } ')"

# ListenPort
lport="$(shuf -n1 -i 40000-50000)"

# Default routes for VPN
routes="$(head -1 wg0.conf | awk ' { print $8 } '))"


# Create the client configuration file


echo "[Interface]
Address = 10.0.0.1/24
DNS = ${dns}
ListenPort = ${lport}
MTU = ${mtu}
PrivateKey = ${p}


[Peer]
AllowedIPs = ${routes} 
PersistentKeepalive = ${keep} 
PresharedKey = ${pre}
PublicKey = ${pub}
Endpoint = ${end}
" > ${pFile}

# Add our peer configuration to the server config
echo "
# ricky begin
[Peer]
PublicKey = ${clientPub}
PresharedKey = ${pre}
AllowedIPs = 10.0.0.1/24
# ricky end" | tee -a wg0.conf



echo "
sudo cp wg0.conf /etc/wireguard
sudo wg addconf wg0 <(wg-quick strip wg0)
