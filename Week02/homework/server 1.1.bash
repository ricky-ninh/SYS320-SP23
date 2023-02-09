#!/bin/bash
# Correct wireguard server configuration file
# Storyline: Script to create a wireguard server

# Create a private key
p="$(wg genkey)"

# Create a public key
pub="$(echo ${p} | wg pubkey)"


# Set the addresses
Address="10.254.132.0/24,172.16.20.0/24"

# Set Server IP addresses
ServerAddress="10.254.132.1/24,172.16.20.1/24"

# Set the listen port
lport="51820"

# Create the format for the client configuration options
peerInfo="# ${address} 192.199.97.163:4282 ${pub} 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0" 

# Example Server configuration file
# 10.254.132.0/24,172.16.28.0/24,162.243.2.92:4282 /y6z1o8iyo+Jp2KFNByKbe7ysaR6nmYnwKGiU5Zq5BA= 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0
#[Interface]
#Address = 10.254.132.1
#PostUp = /etc/wireguard/wg-up.bash
#PostDown = /etc/wireguard/wg-down.bash
#ListenPort = 4282
#PrivateKey = sD6H1S6BqUnOzhJVM07XScmte367eZ7eW4dWGkfnhGU=
#" > wg0.conf


echo "${peerInfo}
[Interface]
Address = ${ServerAddress}
#PostUp = /etc/wireguard/wg-up.bash
#PostDown = /etc/wireguard/wg-down.bash
ListenPort = ${lport} 
PrivateKey = ${p}
" > wg0.conf