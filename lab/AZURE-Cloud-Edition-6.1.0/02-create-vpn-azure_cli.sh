#!/bin/bash
# Uncomment set command below for code debuging bash
#set -x

PREFIX="$(head -20 config.yml | grep PREFIX | awk '{ print $2}')"
PREFIXVPN="$PREFIX-vpn"

VNET_CIDR_BLOCK="$(cat config.yml | grep VNET_CIDR_BLOCK | awk '{ print $2}')"
SUBNET1_CIDR_BLOCK="$(cat config.yml | grep SUBNET1_CIDR_BLOCK | awk '{ print $2}')"
SUBNET2_CIDR_BLOCK="$(cat config.yml | grep SUBNET2_CIDR_BLOCK | awk '{ print $2}')"
SUBNET3_CIDR_BLOCK="$(cat config.yml | grep SUBNET3_CIDR_BLOCK | awk '{ print $2}')"
CUSTOMER_GATEWAY_IP="$(cat config.yml | grep CUSTOMER_GATEWAY_IP | awk '{ print $2}')"
EXT_NETWORK_UDF_VPN="$(cat config.yml | grep EXT_NETWORK_UDF_VPN | awk '{ print $2}')"
DEFAULT_REGION="$(cat config.yml | grep DEFAULT_REGION| awk '{ print $2}')"

# https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-cli

# Create a resource group
az group create --name $PREFIX --location eastus

# Create a virtual network and subnet 1
az network vnet create \
  -n VNet1 \
  -g $PREFIX \
  -l $DEFAULT_REGION \
  --address-prefix $VNET_CIDR_BLOCK \
  --subnet-name Subnet1 \
  --subnet-prefix $SUBNET1_CIDR_BLOCK

# Create subnet 2
az network vnet subnet create \
  --vnet-name VNet1 \
  -n Subnet2 \
  -g $PREFIX \
  --address-prefix $SUBNET2_CIDR_BLOCK

# Add a gateway subnet
az network vnet subnet create \
  --vnet-name VNet1 \
  -n GatewaySubnet \
  -g $PREFIX \
  --address-prefix $SUBNET3_CIDR_BLOCK

# Create the local network gateway
az network local-gateway create \
   --gateway-ip-address $CUSTOMER_GATEWAY_IP --name UDF --resource-group $PREFIX \
   --local-address-prefixes $EXT_NETWORK_UDF_VPN

# To modify the local network gateway 'gatewayIpAddress'
# az network local-gateway update --gateway-ip-address 23.99.222.170 --name Site2 --resource-group TestRG1

# View the subnets
az network vnet subnet list -g $PREFIX --vnet-name VNet1 --output table

# Request a public IP address
az network public-ip create \
  -n VNet1GWIP \
  -g $PREFIX \
  --allocation-method Dynamic 

# Create the VPN gateway
az network vnet-gateway create \
  -n VNet1GW \
  -l eastus \
  --public-ip-address VNet1GWIP \
  -g $PREFIX \
  --vnet VNet1 \
  --gateway-type Vpn \
  --sku VpnGw1 \
  --vpn-type RouteBased \
  --no-wait

# View the VPN gateway
az network vnet-gateway show \
  -n VNet1GW \
  -g $PREFIX \
  --output table

# View the public IP address
az network public-ip show \
  --name VNet1GWIP \
  --resource-group $PREFIX \
  --output table

# Create the VPN connection
az network vpn-connection create --name $PREFIXVPN -resource-group $PREFIX --vnet-gateway1 VNet1GW -l eastus --shared-key abc123 --local-gateway2 UDF --enable-bgp

# Verify the VPN connection
az network vpn-connection show --name $PREFIXVPN --resource-group $PREFIX --output table

exit 0
