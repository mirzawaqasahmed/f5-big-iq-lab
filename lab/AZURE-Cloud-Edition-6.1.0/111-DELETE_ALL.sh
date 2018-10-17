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
PREFIX="$(head -40 config.yml | grep PREFIX | awk '{ print $2}')"

if [[ $c == 1 || $c  == 1 || $c4  == 1 || $c5  == 1 || $c6  == 1 || $c7  == 1 ]]; then
       echo -e "${RED}\nNo Azure SSG created, nothing to tear down.\n${NC}"
       exit 1
fi

/usr/bin/wall "/!\ DELETION OF ALL AZURE OBJECTS IN 1 MIN /!\  To stop it: # kill -9 $$" 2> /dev/null

sleep 60

echo -e "\n\n${RED}/!\ DELETION OF ALL AZURE OBJECTS (Application/SSG/VPN/VNET) /!\ ${NC} \n"

[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

clear

echo -e "\n\nEXPECTED TIME: ~25 min\n\n"

echo -e "${BLUE}TIME: $(date +"%H:%M")${NC}"
$ANSIBLE_PATH/ansible-playbook $DEBUG_arg 10-delete-azure-app.yml -i inventory/hosts
echo -e "\n${BLUE}TIME: $(date +"%H:%M")${NC}"

echo -e "\n\n${RED}/!\ HAVE YOU DELETED THE APP CREATED ON YOUR SSG FROM BIG-IQ? /!\ \n"
echo -e "IF YOU HAVE NOT, PLEASE DELETE ANY APPLICATION(S) CREATED ON YOUR AZURE SSG BEFORE PROCEEDING ${NC}\n\n"

[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

echo -e "\n${BLUE}TIME: $(date +"%H:%M")${NC}"
$ANSIBLE_PATH/ansible-playbook $DEBUG_arg 11-delete-azure-ssg-resources.yml -i inventory/hosts
echo -e "\n${BLUE}TIME: $(date +"%H:%M")${NC}"

echo -e "\n${BLUE}TIME: $(date +"%H:%M")${NC}"
$PYTHON_PATH/python 11-delete-azure-ssg-resources-check.py
echo -e "\n${BLUE}TIME: $(date +"%H:%M")${NC}"

[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

echo -e "${RED}/!\ IS YOUR SSG COMPLETLY REMOVED FROM YOUR AZURE ACCOUNT? /!\ \n"
echo -e "MAKE SURE THE AZURE SSG HAS BEEN REMOVED COMPLETLY BEFORE PROCEEDING${NC}\n"

[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

echo -e "\n${BLUE}TIME: $(date +"%H:%M")${NC}"
az group delete --name $PREFIX --yes
echo -e "\n${BLUE}TIME: $(date +"%H:%M")${NC}"

echo -e "Clear cache directory and *retry"
rm -rf *.retry nohup.out

echo -e "\n${RED}/!\ DOUBLE CHECK IN YOUR AZURE ACCOUNT ALL THE RESOURCES CREATED FOR YOUR DEMO HAVE BEEN DELETED  /!\ ${NC}\n"

exit 0
