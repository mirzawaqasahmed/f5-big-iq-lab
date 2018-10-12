#!/bin/bash
# Uncomment set command below for code debugging bash
#set -x

function pause(){
   read -p "$*"
}

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

if [[ -z $1 ]]; then
    echo -e "\nUsage: ${RED} $0 <pause/nopause> <udf/sjc/sjc2/sea> ${NC} (1st parameter mandatory)\n"
    exit 1;
fi

if [ -z "$2" ]; then
  env="udf"
else
  #env="sjc"
  #env="sjc2"
  #env="sea"
  env=$2
fi

echo -e "Environement:${RED} $env ${NC}"

ip_cm1="$(cat inventory/group_vars/$env-bigiq-cm-01.yml| grep bigiq_onboard_server | awk '{print $2}')"
ip_dcd1="$(cat inventory/group_vars/$env-bigiq-dcd-01.yml| grep bigiq_onboard_server | awk '{print $2}')"

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

echo -e "\n${RED}Delete Applications${NC}"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

# Delete apps
if [[  $env == "udf" ]]; then
  ansible-playbook -i notahost, delete_default_apps.yml $DEBUG_arg
else
  ansible-playbook -i notahost, .delete_default_apps_$env.yml $DEBUG_arg
fi

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

echo -e "${RED} /!\ CHECK IF THE APPLICATIONS ARE CORRECTLY DELETED IN BIG-IQ. MAY NEED TO RETRY. /!\ ${NC}"

echo -e "\n${RED}clear-rest-storage -d on both BIG-IQ CM and DCD ${NC}"
for ip in $ip_cm1 $ip_dcd1; do
  echo -e "\n---- ${RED} $ip ${NC} ----"
  [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
  echo "Type $ip root password."
  ssh root@$ip clear-rest-storage -d
done

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

echo -e "\n${RED}Uninstall ansible-galaxy module ${NC}"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
ansible-galaxy remove f5devcentral.bigiq_onboard
ansible-galaxy remove f5devcentral.register_dcd

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"