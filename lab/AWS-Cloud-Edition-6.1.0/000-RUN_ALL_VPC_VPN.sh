#!/bin/bash
# Uncomment set command below for code debugging bash
#set -x
# Uncomment set command below for code debugging ansible
#DEBUG_arg="-vvvv"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

function pause(){
   read -p "$*"
}

cd /home/f5/AWS-Cloud-Edition

c=$(grep CUSTOMER_GATEWAY_IP ./config.yml | grep '0.0.0.0' | wc -l)
c2=$(grep '<name>' ./config.yml | wc -l)
c3=$(grep '<name_of_the_aws_key>' ./config.yml | wc -l)
c4=$(grep '<key_id>' ./config.yml | wc -l)
PREFIX="$(head -20 config.yml | grep PREFIX | awk '{ print $2}')"
MGT_NETWORK_UDF="$(cat config.yml | grep MGT_NETWORK_UDF | awk '{print $2}')"

if [[ $c == 1 || $c2  == 1 || $c3  == 1 || $c4  == 1 ]]; then
       echo -e "${RED}\nPlease, edit config.yml to configure:\n - AWS credential\n - AWS Region\n - Prefix\n - Key Name\n - Customer Gateway public IP address (SEA-vBIGIP01.termmarc.com's public IP)"
	     echo -e "\nOption to run the script:\n\n# ./000-RUN_ALL_VPC_VPN.sh\n\n or\n\n# nohup ./000-RUN_ALL.sh nopause & (the script will be executed with no breaks between the steps)${NC}\n\n"
       exit 1
fi

clear

## if any variables are passed to the script ./000-RUN_ALL.sh (e.g. 000-RUN_ALL.sh nopause), no pause will happen during the execution of the script
echo -e "\n${GREEN}Did you subscribed and agreed to the software terms for F5 BIG-IP VE - ALL (BYOL, 1 Boot Location) in AWS Marketplace?\n\n"
echo -e "https://aws.amazon.com/marketplace/pp/B07G5MT2KT\n\n${NC}"

echo -e "${BLUE}EXPECTED TIME: ~45 min${NC}\n\n"

[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
#sudo apt-get install python-setuptools
#sudo easy_install pip
#sudo pip install ansible
#sudo apt-get install sshpass
#sudo ansible-playbook $DEBUG_arg 01a-install-pip.yml
ansible-playbook $DEBUG_arg 01b-install-aws.yml
echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
ansible-playbook $DEBUG_arg 02-vpc-elb.yml
echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
ansible-playbook $DEBUG_arg 03-vpn.yml
echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
./03-customerGatewayConfigExport.sh

[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
./04a-configure-bigip.sh

[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

ansible-playbook $DEBUG_arg 04b-configure-bigip.yml -i inventory/hosts

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

echo -e "\nSleep 10 seconds"
sleep 10

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
ansible-playbook $DEBUG_arg 05-restart-bigip-services.yml -i inventory/hosts
echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

echo -e "\nSleep 20 seconds"
sleep 20

# WA Tunnel
ssh admin@$MGT_NETWORK_UDF tmsh modify net tunnels tunnel aws_conn_tun_1 mtu 1350
ssh admin@$MGT_NETWORK_UDF tmsh modify net tunnels tunnel aws_conn_tun_2 mtu 1350

echo -e "\n${GREEN}Sleep 3 min (to allow some time for the VPN to come up)${NC}"
sleep 180

echo -e "\n${GREEN}VPN status:${NC}\n"
./check_vpn_aws.sh

echo -e "\n${GREEN}IPsec logs on the BIG-IP SEA-vBIGIP01.termmarc.com${NC}"
ssh admin@$MGT_NETWORK_UDF tail -10 /var/log/racoon.log

echo -e "\n${GREEN}If the VPN is not UP, check previous playbooks execution are ALL successfull.\nIf they are, try to restart the ipsec services:\n\n# ansible-playbook 05-restart-bigip-services.yml\n"
echo -e "You can check also the BIG-IP logs:\n\n${RED}# ssh admin@$MGT_NETWORK_UDF tail -100 /var/log/racoon.log${NC}\n\n"

echo -e "${GREEN}Note: check if the VPN is up ${RED}# ./check_vpn_aws.sh${NC}"

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

echo -e "\nPLAYBOOK COMPLETED, DO NOT FORGET TO TEAR DOWN EVERYTHING AT THE END OF YOUR DEMO\n\n${RED}# ./111-DELETE_ALL.sh\n\n or\n\n# nohup ./111-DELETE_ALL.sh nopause &\n\n"
echo -e "/!\ The objects created in AWS will be automatically delete 23h after the deployment was started. /!\ "

echo -e "\n${GREEN}\ If you stop your deployment, the Customer Gateway public IP address will change (SEA-vBIGIP01.termmarc.com's public IP).\nRun the 111-DELETE_ALL.sh script and start a new fresh UDF deployment.${NC}\n\n"

exit 0