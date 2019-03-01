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
ip_cm2="$(cat inventory/group_vars/$env-bigiq-cm-02.yml| grep bigiq_onboard_server | awk '{print $2}')"
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

# SECONDS used for total execution time (see end of the script)
SECONDS=0

echo -e "\nEnvironement:${RED} $env ${NC}"

echo -e "Exchange ssh keys with BIG-IQ & DCD:"
if [[  $env == "udf" ]]; then
  for ip in "${ips[@]}"; do
    echo "$ip"
    sshpass -p purple123 ssh-copy-id -o StrictHostKeyChecking=no -i /home/f5/.ssh/id_rsa.pub root@$ip > /dev/null 2>&1
  done
fi

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

#touch delete_default_bigiq_apps.retry
# run delete playbook, if fails, a .retry file is created, so re-try forever until the apps deletion are successful
#echo -e "\n${RED}Delete BIG-IQ Applications${NC}"
#[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
#while [ -f delete_default_bigiq_apps.retry ]
#do
#  echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
#  rm *.retry
#  ansible-playbook -i notahost, delete_default_bigiq_apps.yml $DEBUG_arg
#  echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
#done

echo -e "\n${RED}=>>> clear-rest-storage -d${NC} on both BIG-IQ CM and DCD"

for ip in "${ips[@]}"; do
  echo -e "\n---- ${RED} $ip ${NC} ----"
  [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
  echo "clear-rest-storag"
  ssh -o StrictHostKeyChecking=no root@$ip clear-rest-storage -d
done

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
        sshpass -p $c ssh-copy-id -o StrictHostKeyChecking=no -i /home/f5/.ssh/id_rsa.pub $b@$a > /dev/null 2>&1

        echo "Cleanup AS3 on $a"
        ssh -o StrictHostKeyChecking=no $b@$a bigstart stop restjavad restnoded < /dev/null
        ssh -o StrictHostKeyChecking=no $b@$a rm -rf /var/config/rest/storage < /dev/null
        ssh -o StrictHostKeyChecking=no $b@$a rm -rf /var/config/rest/index < /dev/null
        ssh -o StrictHostKeyChecking=no $b@$a bigstart start restjavad restnoded < /dev/null
        ssh -o StrictHostKeyChecking=no $b@$a rm -f /var/config/rest/downloads/*.rpm < /dev/null
        ssh -o StrictHostKeyChecking=no $b@$a rm -f /var/config/rest/iapps/RPMS/*.rpm < /dev/null
    done < inventory/$env-bigip.csv
fi

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

# total script execution time
echo -e "$(date +'%Y-%d-%m %H:%M'): elapsed time:${RED} $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec${NC}"