#!/bin/bash
# Uncomment set command below for code debuging bash
#set -x
# Uncomment set command below for code debuging ansible
#DEBUG_arg="-vvvv"

function pause(){
   read -p "$*"
}

clear

echo -e "\n\n/!\ HAVE YOU DELETED THE APP CREATED ON YOUR SSG FROM BIG-IQ? /!\ \n"
echo -e "IF YOU HAVE NOT, PLEASE DELETE ANY APPLICATION(S) CREATED ON YOUR AWS SSG BEFORE PROCEEDING\n\n"

pause 'Press [Enter] key to continue... CTRL+C to Cancel'

echo -e "\n\n/!\ HAVE YOU DELETED THE SSG CREATED FROM BIG-IQ? /!\ \n"
echo -e "IF YOU HAVE NOT, PLEASE DELETE THE AWS SSG BEFORE PROCEEDING\n\n"

#ansible-playbook $DEBUG_arg 09-delete-aws-ssg-resources.yml -i ansible2.cfg
#AWS SSG MUST BE DELETED MANUALLY FOR NOW

pause 'Press [Enter] key to continue... CTRL+C to Cancel'

echo -e "/!\ IS YOUR SSG COMPLETLY REMOVED FROM YOUR AWS ACCOUNT? /!\ \n"
echo -e "MAKE SURE THE AWS SSG HAS BEEN REMOVED COMPLETLY BEFORE PROCEEDING\n"

pause 'Press [Enter] key to continue... CTRL+X to Cancel'

ansible-playbook $DEBUG_arg 10-teardown-aws-vpn-vpc-ubuntu.yml -i ansible2.cfg

echo -e "/!\ DOUBLE CHECK IN YOUR AWS ACCOUNT ALL THE RESOURCES CREATED FOR YOUR DEMO HAVE BEEN DELETED  /!\ \n"

exit 0
