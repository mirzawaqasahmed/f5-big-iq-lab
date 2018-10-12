#!/bin/bash
# Uncomment set command below for code debuging bash
#set -x

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PREFIX="$(head -20 config.yml | grep PREFIX | awk '{ print $2}')"
PREFIXVPN="$PREFIX-vpn"

echo -e "\n${BLUE}VPN Azure <-> UDF${NC}"

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

echo -e "\n(refresh every 30 seconds)"
while [[ $connectionStatus != "Connected" ]] 
do
    connectionStatus=$(az network vpn-connection show --name $PREFIXVPN --resource-group $PREFIX  | jq '.connectionStatus')
    connectionStatus=${connectionStatus:1:${#connectionStatus}-2}
    if [[ $connectionStatus == "Connected" ]]; then
      echo -e "connectionStatus =${GREEN} $connectionStatus ${NC}"
    else
      echo -e "connectionStatus =${RED} $connectionStatus ${NC}"
    fi
    sleep 30
done

#echo -e "\n${GREEN}Verify the BGP peer status${NC}"
#az network vnet-gateway list-bgp-peer-status -g $PREFIX -n VNet1GW

#echo -e "\n${GREEN}Verify the Learned routes${NC}"
#az network vnet-gateway list-learned-routes -g  $PREFIX -n VNet1GW

exit 0
