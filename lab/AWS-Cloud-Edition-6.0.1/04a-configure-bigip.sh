#!/bin/bash
# Uncomment set command below for code debuging bash
#set -x

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

VPC_CIDR_BLOCK="$(cat config.yml | grep VPC_CIDR_BLOCK | awk '{ print $2}')"
MGT_NETWORK_UDF="$(cat config.yml | grep MGT_NETWORK_UDF | awk '{ print $2}')"

ssh admin@$MGT_NETWORK_UDF tmsh modify sys db config.allow.rfc3927 { value "enable" } 
ssh admin@$MGT_NETWORK_UDF tmsh modify sys db ipsec.if.checkpolicy { value "disable" }
ssh admin@$MGT_NETWORK_UDF tmsh modify sys db connection.vlankeyed { value "disable" }

ssh admin@$MGT_NETWORK_UDF tmsh create ltm profile fastL4 aws-vpn loose-close enabled loose-initialization enabled reset-on-timeout disabled
ssh admin@$MGT_NETWORK_UDF tmsh create ltm virtual azure-vpn destination $VPC_CIDR_BLOCK:any ip-forward profiles add { azure-vpn }

ssh admin@$MGT_NETWORK_UDF tmsh modify net route-domain 0 routing-protocol add { BGP }


exit 0