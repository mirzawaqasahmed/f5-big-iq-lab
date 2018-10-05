#!/bin/bash
# Uncomment set command below for code debuging bash
#set -x

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color


EXT_NETWORK_UDF_PEERING="$(cat config.yml | grep EXT_NETWORK_UDF_PEERING | awk '{ print $2}')"
MGT_NETWORK_UDF="$(cat config.yml | grep MGT_NETWORK_UDF | awk '{ print $2}')"
SHARED_KEY="$(cat config.yml | grep SHARED_KEY | awk '{ print $2}')"
VNET_CIDR_BLOCK="$(cat config.yml | grep VNET_CIDR_BLOCK | awk '{ print $2}')"

publicIpAddress=$(az network public-ip show --name VNet1GWIP --resource-group $PREFIX | jq '.ipAddress')
publicIpAddress=${publicIpAddress:1:${#publicIpAddress}-2}
echo -e "\npublicIpAddress = ${BLUE} $publicIpAddress ${NC}"

ssh admin@$MGT_NETWORK_UDF tmsh modify sys db config.allow.rfc3927 { value "enable" } 
ssh admin@$MGT_NETWORK_UDF tmsh modify sys db ipsec.if.checkpolicy { value "disable" }
ssh admin@$MGT_NETWORK_UDF tmsh modify sys db connection.vlankeyed { value "disable" }

ssh admin@$MGT_NETWORK_UDF tmsh modify net route-domain 0 routing-protocol add { BGP }

ssh admin@$MGT_NETWORK_UDF tmsh create net ipsec ike-peer peer-vpn-azure lifetime 480 my-id-type address my-id-value $EXT_NETWORK_UDF_PEERING peers-id-type address peers-id-value $publicIpAddress phase1-auth-method pre-shared-key phase1-encrypt-algorithm aes256 remote-address $publicIpAddress verify-cert true version add { v1 v2 } preshared-key $SHARED_KEY nat-traversal on

ssh admin@$MGT_NETWORK_UDF tmsh create net ipsec ipsec-policy ipsec-policy-vpn-azure ike-phase2-auth-algorithm sha1 ike-phase2-encrypt-algorithm aes256 ike-phase2-lifetime 60 ike-phase2-perfect-forward-secrecy modp1024 mode interface

ssh admin@$MGT_NETWORK_UDF tmsh create net ipsec traffic-selector selector-vpn-azure destination-address 169.254.12.32/30 ipsec-policy ipsec-policy-vpn-azuresource-address 169.254.12.32/30 

ssh admin@$MGT_NETWORK_UDF tmsh create net tunnels ipsec profile-vpn-azure app-service none defaults-from ipsec traffic-selector selector-vpn-azure

ssh admin@$MGT_NETWORK_UDF tmsh create net tunnels tunnel tunnel-azure local-address $EXT_NETWORK_UDF_PEERING mtu 1400 profile profile-vpn-azure remote-address $publicIpAddress
ssh admin@$MGT_NETWORK_UDF tmsh create net self 169.254.12.34  address 169.254.12.34/30 allow-service all traffic-group traffic-group-local-only vlan tunnel-vpn-azure

ssh admin@$MGT_NETWORK_UDF tmsh create ltm pool keepalive-vpn-azure members add { 169.254.12.33:179 { address 169.254.12.33 } } monitor tcp_half_open and gateway_icmp

ssh admin@$MGT_NETWORK_UDF tmsh create ltm profile fastL4 azure-vpn loose-close enabled loose-initialization enabled reset-on-timeout disabled
ssh admin@$MGT_NETWORK_UDF tmsh create ltm virtual azure-vpn destination $VNET_CIDR_BLOCK:any ip-forward profiles add { azure-vpn }

exit 0