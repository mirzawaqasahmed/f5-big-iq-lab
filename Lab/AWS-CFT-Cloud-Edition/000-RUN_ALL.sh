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
       echo -e "\nPlease, edit config.yml to configure:\n - AWS credential\n - AWS Region\n - Customer Gateway public IP address (SEA-vBIGIP01.termmarc.com's public IP)\n"
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

echo "Wait 30 seconds"
sleep 30

ansible-playbook $DEBUG_arg 05-restart-bigip-services.yml

echo "Wait 30 seconds"
sleep 30

# WA Tunnel
ssh admin@10.1.1.7 tmsh modify net tunnels tunnel aws_conn_tun_1 mtu 1397
ssh admin@10.1.1.7 tmsh modify net tunnels tunnel aws_conn_tun_2 mtu 1397

echo "Wait 30 seconds"
sleep 30

echo -e "ipsec logs on the BIG-IP"
pause 'Press [Enter] key to continue...'
ssh admin@10.1.1.7 tail -10 /var/log/racoon.log

echo "Wait 30 seconds"
sleep 30

ssh admin@10.1.1.7 tail -10 /var/log/racoon.log

aws ec2 describe-vpn-connections | grep -A 15 VgwTelemetry

echo -e "If the VPN is not UP (open a new putty window), try restart again the ipsec services:\n\n# ansible-playbook 05-restart-bigip-services.yml\n"
echo -e "You can check also the BIG-IP logs:\n\n# ssh admin@10.1.1.7 tail -100 /var/log/racoon.log\n"

pause 'If the VPN is UP, Press [Enter] key to continue... CTRL+C to Cancel'

# Add route to access AWS VPC
sudo route add -net 172.17.0.0/16 gw 10.1.10.7

ansible-playbook $DEBUG_arg 06-ubuntu-apache2.yml

pause 'Press [Enter] key to continue... CTRL+C to Cancel'

ansible-playbook $DEBUG_arg 07-create-aws-ssg-templates.yml -i ansible2.cfg

pause 'Press [Enter] key to continue... CTRL+C to Cancel'

ansible-playbook $DEBUG_arg 08-create-aws-auto-scaling.yml -i ansible2.cfg

echo -e "\nPLAYBOOK COMPLETED, DO NOT FORGET TO TEAR DOWN EVERYTHING AT THE END OF YOUR DEMO\n\n # ./111-DELETE_ALL.sh\n\n"

exit 0
