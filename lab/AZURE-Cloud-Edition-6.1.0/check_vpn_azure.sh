#!/bin/bash
# Uncomment set command below for code debuging bash
#set -x

PREFIX="$(head -20 config.yml | grep PREFIX | awk '{ print $2}')"
PREFIXVPN="$PREFIX-vpn"

# Verify the VPN connection
az network vpn-connection show --name $PREFIXVPN --resource-group $PREFIX --output table

exit 0
