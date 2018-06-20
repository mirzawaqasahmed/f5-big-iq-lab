#!/bin/bash
# Uncomment set command below for code debuging bash
#set -x
# Uncomment set command below for code debuging ansible
#DEBUG_arg="-vvvv"

function pause(){
   read -p "$*"
}
echo -e "\n\n/!\ DELETION OF ALL AWS OBJECTS (Application/SSG/VPN/VPC) /!\ \n"

[[ $1 != "nopause" ]] && pause 'Press [Enter] key to continue... CTRL+C to Cancel'

clear

echo -e "\n\nEXPECTED TIME: ~25 min\n\n"

echo -e "TIME: $(date +"%H:%M")"
ansible-playbook -i notahost, 10-delete-aws-waf-app.yml
echo -e "\nTIME: $(date +"%H:%M")"

echo -e "\n\n/!\ HAVE YOU DELETED THE APP CREATED ON YOUR SSG FROM BIG-IQ? /!\ \n"
echo -e "IF YOU HAVE NOT, PLEASE DELETE ANY APPLICATION(S) CREATED ON YOUR AWS SSG BEFORE PROCEEDING\n\n"

# Need to add an sleep of 2 min before attempting SSG deletion
#[[ $1 != "nopause" ]] && sleep 120

[[ $1 != "nopause" ]] && pause 'Press [Enter] key to continue... CTRL+C to Cancel'

echo -e "\nTIME: $(date +"%H:%M")"
ansible-playbook $DEBUG_arg 11-delete-aws-ssg-resources.yml -i ansible2.cfg
echo -e "\nTIME: $(date +"%H:%M")"

echo -e "\nTIME: $(date +"%H:%M")"
python 11-delete-aws-ssg-resources-check.py
echo -e "\nTIME: $(date +"%H:%M")"

[[ $1 != "nopause" ]] && pause 'Press [Enter] key to continue... CTRL+C to Cancel'

echo -e "/!\ IS YOUR SSG COMPLETLY REMOVED FROM YOUR AWS ACCOUNT? /!\ \n"
echo -e "MAKE SURE THE AWS SSG HAS BEEN REMOVED COMPLETLY BEFORE PROCEEDING\n"

[[ $1 != "nopause" ]] && pause 'Press [Enter] key to continue... CTRL+X to Cancel'

echo -e "\nTIME: $(date +"%H:%M")"
ansible-playbook $DEBUG_arg 12-teardown-aws-vpn-vpc-ubuntu.yml -i ansible2.cfg
echo -e "\nTIME: $(date +"%H:%M")"

echo -e "\n/!\ DOUBLE CHECK IN YOUR AWS ACCOUNT ALL THE RESOURCES CREATED FOR YOUR DEMO HAVE BEEN DELETED  /!\ \n"

exit 0
