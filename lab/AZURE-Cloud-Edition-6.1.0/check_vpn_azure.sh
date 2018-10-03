#!/bin/bash
# Uncomment set command below for code debuging bash
#set -x

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PREFIX="$(head -20 config.yml | grep PREFIX | awk '{ print $2}')"
PREFIXVPN="$PREFIX-vpn"

echo -e "\n${GREEN}View the VPN gateway${NC}"
az network vnet-gateway show \
  -n VNet1GW \
  -g $PREFIX \
  --output table

bgpPeeringAddress=$(az network vnet-gateway show -n VNet1GW -g $PREFIX | jq '.bgpSettings.bgpPeeringAddress')
bgpPeeringAddress=${bgpPeeringAddress:1:${#bgpPeeringAddress}-2}
echo -e "\nbgpPeeringAddress =${BLUE} $bgpPeeringAddress ${NC}"

echo -e "\n${GREEN}View the public IP address${NC}"
az network public-ip show \
  --name VNet1GWIP \
  --resource-group $PREFIX \
  --output table

publicIpAddress=$(az network public-ip show --name VNet1GWIP --resource-group $PREFIX | jq '.ipAddress')
publicIpAddress=${publicIpAddress:1:${#publicIpAddress}-2}
echo -e "\npublicIpAddress = ${BLUE} $publicIpAddress ${NC}\n"

echo -e "\n${GREEN}Verify the VPN connection${NC}"
az network vpn-connection show --name $PREFIXVPN --resource-group $PREFIX --output table

while [[ $connectionStatus != "Connected" ]] 
do
    sleep 5
    connectionStatus=$(az network vpn-connection show --name $PREFIXVPN --resource-group $PREFIX  | jq '.connectionStatus')
    connectionStatus=${connectionStatus:1:${#connectionStatus}-2}
    echo -e "connectionStatus =${RED} $connectionStatus ${NC}"
done

exit 0
