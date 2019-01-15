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

getPublicIP=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}')
if [[ ! -z $getPublicIP ]]; then
    sed -i "s/0.0.0.0/$getPublicIP/g" ./config.yml
fi

# Use UDF Cloud Account (under developement, only for AWS)
#./01-configure-cloud-udf.sh

# [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

c1=$(grep CUSTOMER_GATEWAY_IP ./config.yml | grep '0.0.0.0' | wc -l)
c2=$(grep '<name>' ./config.yml | wc -l)
c3=$(grep '<name_of_the_aws_key>' ./config.yml | wc -l)
c4=$(grep '<key_id>' ./config.yml | wc -l)
PREFIX="$(head -25 config.yml | grep PREFIX | awk '{ print $2}')"
MGT_NETWORK_UDF="$(cat config.yml | grep MGT_NETWORK_UDF | awk '{print $2}')"

if [[ $c1  == 1 || $c2  == 1 || $c3  == 1 || $c4  == 1 ]]; then
       echo -e "${RED}\nPlease, edit config.yml to configure:\n - AWS credential\n - AWS Region\n - SSH Key Name\n - Prefix (optional)"
	   echo -e "\nOption to run the script:\n\n# ./000-RUN_ALL_VPC_VPN.sh\n\n or\n\n# nohup ./000-RUN_ALL_VPC_VPN.sh nopause & (the script will be executed with no breaks between the steps)${NC}\n\n"
       exit 1
fi

clear

echo -e "${BLUE}EXPECTED TIME: ~45 min${NC}\n"

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

# WA Tunnel
sleep 20
./wa_aws_vpn_down_bigip.sh
../AZURE-Cloud-Edition/wa_azure_vpn_down_bigip.sh

echo -e "\nVPN Expected time: ${GREEN}10 min${NC}"
./check_vpn_aws.sh

echo -e "\n${GREEN}If the VPN is not UP, check previous playbooks execution are ALL successfull.\nIf they are, try to restart the ipsec services:\n\n# ansible-playbook -i inventory/hosts 05-restart-bigip-services.yml\nYou can also run ./wa_aws_vpn_down_bigip.sh\n"
echo -e "You can check also the BIG-IP logs:\n\n${RED}# ssh admin@$MGT_NETWORK_UDF tail -100 /var/log/racoon.log${NC}\n\n"

echo -e "${GREEN}Note: check if the VPN is up ${RED}# ./check_vpn_aws.sh${NC}"

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

echo -e "\nPLAYBOOK COMPLETED, DO NOT FORGET TO TEAR DOWN EVERYTHING AT THE END OF YOUR DEMO\n\n${RED}# ./111-DELETE_ALL.sh\n\n or\n\n# nohup ./111-DELETE_ALL.sh nopause &\n\n"
echo -e "/!\ The objects created in AWS will be automatically delete 23h after the deployment was started. /!\ "

echo -e "\n${GREEN}\ If you stop your deployment, the Customer Gateway public IP address will change (SEA-vBIGIP01.termmarc.com's public IP).\nRun the 111-DELETE_ALL.sh script and start a new fresh UDF deployment.${NC}\n\n"

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

exit 0