#!/bin/bash
# Uncomment set command below for code debuging bash
#set -x

PREFIX="$(head -10 config.yml | grep PREFIX | awk '{ print $2}')"
PREFIXVPN="$(head -10 config.yml | grep PREFIX | awk '{ print $2}')-vpn"

aws ec2 describe-vpn-connections --query 'VpnConnections[*].{ID:CustomerGatewayConfiguration}' --filters Name=tag:Name,Values=$PREFIXVPN --output text > ./cache/$PREFIX/3-customer_gateway_configuration.xml

if [ -f ./cache/$PREFIX/3-customer_gateway_configuration.xml ]; then

   sed -i '1d' ./cache/$PREFIX/3-customer_gateway_configuration.xml
   #sed -i '/None/d' ./cache/$PREFIX/3-customer_gateway_configuration.xml
   echo "Customer Gateway Configuration file export OK"

else

   echo "Customer Gateway Configuration file export NOK. Check if you VPN connection was created successfully"

fi

exit 0
