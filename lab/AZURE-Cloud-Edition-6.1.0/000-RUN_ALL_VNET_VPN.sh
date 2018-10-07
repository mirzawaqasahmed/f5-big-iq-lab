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

cd /home/f5/AZURE-Cloud-Edition

c=$(grep CUSTOMER_GATEWAY_IP ./config.yml | grep '0.0.0.0' | wc -l)
c2=$(grep '<name>' ./config.yml | wc -l)
c4=$(grep '<Subscription Id>' ./config.yml | wc -l)
c5=$(grep '<Tenant Id>' ./config.yml | wc -l)
c6=$(grep '<Client Id>' ./config.yml | wc -l)
c7=$(grep '<Service Principal Secret>' ./config.yml | wc -l)
PREFIX="$(head -20 config.yml | grep PREFIX | awk '{ print $2}')"
MGT_NETWORK_UDF="$(cat config.yml | grep MGT_NETWORK_UDF | awk '{print $2}')"

if [[ $c == 1 || $c  == 1 || $c4  == 1 || $c5  == 1 || $c6  == 1 || $c7  == 1 ]]; then
       echo -e "${RED}\nPlease, edit config.yml to configure:\n - Credential\n - Azure Region\n - Prefix\n - Customer Gateway public IP address (SEA-vBIGIP01.termmarc.com's public IP)"
	     echo -e "\nOption to run the script:\n\n# ./000-RUN_ALL_VNET_VPN.sh\n\n or\n\n# nohup ./000-RUN_ALL.sh nopause & (the script will be executed with no breaks between the steps)${NC}\n\n"
       exit 1
fi

clear

## if any variables are passed to the script ./000-RUN_ALL.sh (e.g. 000-RUN_ALL.sh nopause), no pause will happen during the execution of the script

echo -e "${BLUE}EXPECTED TIME: ~45 min${NC}\n\n"

[[ $1 != "nopause" ]] && pause 'Press [Enter] key to continue... CTRL+C to Cancel'

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
./01-install_azure_cli.sh
echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

[[ $1 != "nopause" ]] && pause 'Press [Enter] key to continue... CTRL+C to Cancel'

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
./02-create-vpn-azure_cli.sh
echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

[[ $1 != "nopause" ]] && pause 'Press [Enter] key to continue... CTRL+C to Cancel'

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
./03-configure-bigip.sh
echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

echo -e "\n${GREEN}VPN status:${NC}\n"
./check_vpn_azure.sh

echo -e "\n${GREEN}IPsec logs on the BIG-IP SEA-vBIGIP01.termmarc.com${NC}"
ssh admin@$MGT_NETWORK_UDF tail -10 /var/log/ipsec.log

echo -e "\n${GREEN}If the VPN is not UP, check the BIG-IP logs:\n\n${RED}# ssh admin@$MGT_NETWORK_UDF tail -100 /var/log/ipsec.log${NC}\n\n"

echo -e "${GREEN}Note: check if the VPN is up ${RED}# ./check_vpn_azure..sh${NC}"

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

echo -e "\nPLAYBOOK COMPLETED, DO NOT FORGET TO TEAR DOWN EVERYTHING AT THE END OF YOUR DEMO\n\n${RED}# ./111-DELETE_ALL.sh\n\n or\n\n# nohup ./111-DELETE_ALL.sh nopause &\n\n"
echo -e "/!\ The objects created in Azure will be automatically delete 23h after the deployment was started. /!\ "

echo -e "\n${GREEN}\ If you stop your deployment, the Customer Gateway public IP address will change (SEA-vBIGIP01.termmarc.com's public IP).\nRun the 111-DELETE_ALL.sh script and start a new fresh UDF deployment.${NC}\n\n"

exit 0