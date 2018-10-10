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

env="udf"
#env="sjc2"

ip_cm1="$(cat inventory/group_vars/$env-bigiq-cm-01.yml| grep bigiq_onboard_server | awk '{print $2}')"
ip_dcd1="$(cat inventory/group_vars/$env-bigiq-dcd-01.yml| grep bigiq_onboard_server | awk '{print $2}')"

echo -e "\n${RED}Delete Applications${NC}"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

# Delete apps
if [[  $env == "udf" ]]; then
  ansible-playbook -i notahost, delete_default_apps.yml $DEBUG_arg
else
  ansible-playbook -i notahost, .delete_default_apps_$env.yaml $DEBUG_arg
fi

echo -e "\n${RED}clear-rest-storage -d on both BIG-IQ CM and DCD${NC}"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
# basic auth needs to be turn on on BIG-IQ.
for ip in $ip_cm1 $ip_dcd1; do
  ssh root@$ip clear-rest-storage -d
done

echo -e "\n${RED}Un-install ansible-galaxy module${NC}"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
ansible-galaxy remove f5devcentral.bigiq_onboard