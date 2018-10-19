#!/bin/bash
# Uncomment set command below for code debuging bash
#set -x
# Uncomment set command below for code debuging ansible
#DEBUG_arg="-vvvv"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

ANSIBLE_PATH="/usr/local/bin"
PYTHON_PATH="/usr/bin"

PREFIX="$(head -25 config.yml | grep PREFIX | awk '{ print $2}')"
MGT_NETWORK_UDF="$(cat config.yml | grep MGT_NETWORK_UDF | awk '{print $2}')"

function pause(){
   read -p "$*"
}

#cd /home/f5/AWS-Cloud-Edition

getPublicIP=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}')
if [[ ! -z $getPublicIP ]]; then
    sed -i "s/$getPublicIP/0.0.0.0/g" ./config.yml
fi

c2=$(grep '<name>' ./config.yml | wc -l)
c3=$(grep '<name_of_the_aws_key>' ./config.yml | wc -l)
c4=$(grep '<key_id>' ./config.yml | wc -l)

if [[ $c2  == 1 || $c3  == 1 || $c4  == 1 ]]; then
       echo -e "${RED}\nNo AWS SSG created, nothing to tear down.\n${NC}"
       exit 1
fi

/usr/bin/wall "/!\ DELETION OF ALL AWS OBJECTS IN 1 MIN /!\  To stop it: # kill -9 $$" 2> /dev/null

sleep 60

echo -e "\n\n${RED}/!\ DELETION OF ALL AWS OBJECTS (Application/SSG/VPN/VPC) /!\ ${NC} \n"

[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

clear

echo -e "\n\nEXPECTED TIME: ~25 min\n\n"

echo -e "${BLUE}TIME: $(date +"%H:%M")${NC}"
$ANSIBLE_PATH/ansible-playbook $DEBUG_arg 10-delete-aws-app.yml -i inventory/hosts
echo -e "\n${BLUE}TIME: $(date +"%H:%M")${NC}"

echo -e "\n\n${RED}/!\ HAVE YOU DELETED THE APP CREATED ON YOUR SSG FROM BIG-IQ? /!\ \n"
echo -e "IF YOU HAVE NOT, PLEASE DELETE ANY APPLICATION(S) CREATED ON YOUR AWS SSG BEFORE PROCEEDING ${NC}\n\n"

[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

echo -e "\n${BLUE}TIME: $(date +"%H:%M")${NC}"
$ANSIBLE_PATH/ansible-playbook $DEBUG_arg 11-delete-aws-ssg-resources.yml -i inventory/hosts
echo -e "\n${BLUE}TIME: $(date +"%H:%M")${NC}"

echo -e "\n${BLUE}TIME: $(date +"%H:%M")${NC}"
$PYTHON_PATH/python 11-delete-aws-ssg-resources-check.py
echo -e "\n${BLUE}TIME: $(date +"%H:%M")${NC}"

[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

echo -e "${RED}/!\ IS YOUR SSG COMPLETLY REMOVED FROM YOUR AWS ACCOUNT? /!\ \n"
echo -e "MAKE SURE THE AWS SSG HAS BEEN REMOVED COMPLETLY BEFORE PROCEEDING${NC}\n"

[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

echo -e "\n${BLUE}TIME: $(date +"%H:%M")${NC}"
$ANSIBLE_PATH/ansible-playbook $DEBUG_arg 12-teardown-aws-vpn-vpc-ubuntu.yml
echo -e "\n${BLUE}TIME: $(date +"%H:%M")${NC}"

echo -e "\n${GREEN}Cleanup Customer Gateway (Seattle BIG-IP)${NC}\n"

IPSEC_DESTINATION_ADDRESSES=$(cat cache/$PREFIX/3-customer_gateway_configuration.xml | awk -F'[<>]' '/<ip_address>/{print $3}' | grep 169)

for ip in ${IPSEC_DESTINATION_ADDRESSES[@]}; do
  echo "ssh admin@$MGT_NETWORK_UDF tmsh delete net self $ip"
done

ssh admin@$MGT_NETWORK_UDF tmsh delete net tunnels tunnel aws_conn_tun_1
ssh admin@$MGT_NETWORK_UDF tmsh delete net tunnels tunnel aws_conn_tun_2
ssh admin@$MGT_NETWORK_UDF tmsh delete net tunnels ipsec aws_conn_tun_1_profile
ssh admin@$MGT_NETWORK_UDF tmsh delete net tunnels ipsec aws_conn_tun_2_profile
ssh admin@$MGT_NETWORK_UDF tmsh delete net ipsec ike-peer aws_vpn_conn_peer_1
ssh admin@$MGT_NETWORK_UDF tmsh delete net ipsec ike-peer aws_vpn_conn_peer_2
ssh admin@$MGT_NETWORK_UDF tmsh delete net ipsec traffic-selector aws_conn_tun_1_selector
ssh admin@$MGT_NETWORK_UDF tmsh delete net ipsec traffic-selector aws_conn_tun_2_selector
ssh admin@$MGT_NETWORK_UDF tmsh delete net ipsec ipsec-policy ipsec-policy-vpn-aws
ssh admin@$MGT_NETWORK_UDF tmsh save sys config

echo -e "\n${BLUE}TIME: $(date +"%H:%M")${NC}"

echo -e "Clear cache directory and *retry"
rm -rf cache *.retry nohup.out

echo -e "\n${RED}/!\ DOUBLE CHECK IN YOUR AWS ACCOUNT ALL THE RESOURCES CREATED FOR YOUR DEMO HAVE BEEN DELETED  /!\ ${NC}\n"

exit 0
