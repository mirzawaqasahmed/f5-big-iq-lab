#!/bin/bash
# Uncomment set command below for code debugging bash
#set -x
# Uncomment set command below for code debugging ansible
#DEBUG_arg="-vvvv"

# Default value set to UDF
if [ -z "$2" ]; then
  env="udf"
else
  #env="sjc"
  #env="sjc2"
  env=$2
fi

############################################################################################
# CONFIGURATION
ip_cm1="$(cat inventory/group_vars/$env-bigiq-cm-01.yml| grep bigiq_onboard_server | awk '{print $2}')"
ip_dcd1="$(cat inventory/group_vars/$env-bigiq-dcd-01.yml| grep bigiq_onboard_server | awk '{print $2}')"

declare -a ips=("$ip_cm1" "$ip_dcd1")
############################################################################################

function pause(){
   read -p "$*"
}

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Usage
if [[ -z $1 ]]; then
    echo -e "\nUsage: ${RED} $0 <pause/nopause> <udf/sjc/sjc2> ${NC} (1st parameter mandatory)\n"
    exit 1;
fi

echo -e "\nEnvironement:${RED} $env ${NC}"

echo -e "Exchange ssh keys with BIG-IQ & DCD:"
for ip in "${ips[@]}"; do
  echo "Type $ip root password (if asked)"
  sshpass -p purple123 ssh-copy-id root@$ip > /dev/null 2>&1
done

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

# Delete apps only for UDF/Ravello BP
if [[  $env == "udf" ]]; then
  echo -e "\n${RED}Delete Applications${NC}"
  [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

  touch delete_default_apps.retry
  touch delete_default_as3_app.retry

  # run delete playbook, if fails, a .retry file is created, so re-try forever until the apps deletion are successful
  echo -e "\n${RED}BIG-IQ Applications${NC}"
  while [ -f delete_default_apps.retry ]
  do
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    rm *.retry
    ansible-playbook -i notahost, delete_default_apps.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
  done

  echo -e "\n${RED}AS3 Applications${NC}"
  while [ -f delete_default_as3_app.retry ]
  do
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    rm *.retry
    ansible-playbook -i notahost, delete_default_as3_app.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
  done
fi

echo -e "\n${RED} /!\ CHECK IF THE APPLICATIONS ARE CORRECTLY DELETED IN BIG-IQ. MAY NEED TO RETRY. /!\ ${NC}"

echo -e "\n${RED}=>>> clear-rest-storage -d${NC} on both BIG-IQ CM and DCD"

for ip in "${ips[@]}"; do
  echo -e "\n---- ${RED} $ip ${NC} ----"
  [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
  echo "Type $ip root password."
  ssh root@$ip clear-rest-storage -d
done

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

### CUSTOMIZATION - F5 INTERNAL LAB ONLY

if [[  $env != "udf" ]]; then

    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    echo -e "\n${RED}Uninstall ansible-galaxy roles${NC}"
    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    ansible-galaxy remove f5devcentral.bigiq_onboard
    ansible-galaxy remove f5devcentral.register_dcd

    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    # Cleanup AS3 on the BIG-IP
    while IFS="," read -r a b c;
    do
        echo -e "Exchange ssh keys with BIG-IP:"
        echo "Type $a root password (if asked)"
        ssh-copy-id root@$a > /dev/null 2>&1

        echo "Cleanup AS3 on $a"
        ssh root@$a bigstart stop restjavad restnoded; 
        ssh root@$a rm -rf /var/config/rest/storage; 
        ssh root@$a rm -rf /var/config/rest/index; 
        ssh root@$a bigstart start restjavad restnoded; 
        ssh root@$a rm -f /var/config/rest/downloads/*.rpm; 
        ssh root@$a rm -f /var/config/rest/iapps/RPMS/*.rpm;
    done < inventory/$env-bigip.csv
fi

