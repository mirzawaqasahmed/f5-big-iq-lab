#!/bin/bash
# Uncomment set command below for code debuging bash
#set -x
# Uncomment set command below for code debuging ansible
#DEBUG_arg="-vvvv"

function pause(){
   read -p "$*"
}

c=$(grep '0.0.0.0' ./config.yml | wc -l)
if [  $c == 1 ]; then
	echo -e "\nPlease, configure your AWS credential, AWS Region, and Customer Gateway public IP address (SEA-vBIGIP01.termmarc.com)\n"
	exit 1
fi

clear

ansible-playbook $DEBUG_arg 00-install.yml

pause 'Press [Enter] key to continue... CTRL+C to Cancel'

ansible-playbook $DEBUG_arg 01-vpc-elb.yml

pause 'Press [Enter] key to continue... CTRL+C to Cancel'

ansible-playbook $DEBUG_arg 02-vpn.yml

./03-customerGatewayConfigExport.sh

pause 'Press [Enter] key to continue... CTRL+C to Cancel'

ansible-playbook $DEBUG_arg 04-configure-bigip.yml

pause 'Press [Enter] key to continue... CTRL+C to Cancel'

sleep 30

ansible-playbook $DEBUG_arg 05-restart-bigip-services.yml

echo -e "Watching the ipsec logs on the BIG-IP CTRL+C to Cancel"
pause 'Press [Enter] key to continue...'
watch -n 5 "ssh admin@10.1.1.7 tail -10 /var/log/racoon.log"

aws ec2 describe-vpn-connections | grep -A 15 VgwTelemetry

echo -e "If the VPN is not UP, try restart again the ipsec services: # ansible-playbook 05-restart-bigip-services.yml"
echo -e "You can check also the BIG-IP logs under # ssh admin@10.1.1.7 tail -100 /var/log/racoon.log"

pause 'If the VPN is UP, Press [Enter] key to continue... CTRL+C to Cancel'

ansible-playbook $DEBUG_arg 06-ubuntu-apache2.yml

pause 'Press [Enter] key to continue... CTRL+C to Cancel'

ansible-playbook $DEBUG_arg 07-create-aws-ssg-templates.yml -i ansible2.cfg

pause 'Press [Enter] key to continue... CTRL+C to Cancel'

ansible-playbook $DEBUG_arg 08-create-aws-auto-scaling.yml -i ansible2.cfg

echo -e "\nPLAYBOOK COMPLETED, DO NOT FORGET TO TEAR DOWN EVERYTHING AT THE END OF YOUR DEMO (./111-DELETE_ALL.sh)"

exit 0
