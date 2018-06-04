#!/bin/bash
# Uncomment set command below for code debugging bash
#set -x
# Uncomment set command below for code debugging ansible
#DEBUG_arg="-vvvv"

function pause(){
   read -p "$*"
}

c=$(grep '0.0.0.0' ./config.yml | wc -l)
c2=$(grep '<name>' ./config.yml | wc -l)
c3=$(grep '<nameoftheawskey>' ./config.yml | wc -l)

if [[ $c == 1 || $c2  == 1 || $c3  == 1 ]]; then
       echo -e "\nPlease, edit config.yml to configure:\n - AWS credential\n - AWS Region\n - Prefix\n - Key Name\n - Customer Gateway public IP address (SEA-vBIGIP01.termmarc.com's public IP)\n\n"
	   echo -e "\nOption to run the script:\n# ./000-RUN_ALL.sh lab (this will not create the SSG objects in BIG-IQ)"
	   echo -e "# ./000-RUN_ALL.sh nopause (the script will be executed with no breaks between the steps)\n\n"
       exit 1
fi


clear

## if any variables are passed to the script ./000-RUN_ALL.sh (e.g. 000-RUN_ALL.sh nopause), no pause will happen during the execution of the script

ansible-playbook $DEBUG_arg 00-install.yml

[[ $1 != "nopause" ]] && pause 'Press [Enter] key to continue... CTRL+C to Cancel'

ansible-playbook $DEBUG_arg 01-vpc-elb.yml

[[ $1 != "nopause" ]] && pause 'Press [Enter] key to continue... CTRL+C to Cancel'

ansible-playbook $DEBUG_arg 02-vpn.yml

./03-customerGatewayConfigExport.sh

[[ $1 != "nopause" ]] && pause 'Press [Enter] key to continue... CTRL+C to Cancel'

ansible-playbook $DEBUG_arg 04-configure-bigip.yml

echo "Wait 10 seconds"
sleep 10

ansible-playbook $DEBUG_arg 05-restart-bigip-services.yml

echo "Wait 20 seconds"
sleep 20

# WA Tunnel
ssh admin@10.1.1.7 tmsh modify net tunnels tunnel aws_conn_tun_1 mtu 1397
ssh admin@10.1.1.7 tmsh modify net tunnels tunnel aws_conn_tun_2 mtu 1397

# Add route to access AWS VPC from the Lamp server
sudo route add -net 172.17.0.0/16 gw 10.1.10.7

ansible-playbook $DEBUG_arg 06-ubuntu-apache2.yml

#[[ $1 != "nopause" ]] && pause 'Press [Enter] key to continue... CTRL+C to Cancel'

# Not needed, this playbook creates a service catalog template (custom)
#ansible-playbook $DEBUG_arg 07-create-aws-ssg-templates.yml -i ansible2.cfg

echo -e "IPsec logs on the BIG-IP SEA-vBIGIP01.termmarc.com"
ssh admin@10.1.1.7 tail -10 /var/log/racoon.log

echo "Wait 60 seconds"
sleep 60
aws ec2 describe-vpn-connections | grep -A 15 VgwTelemetry

echo -e "If the VPN is not UP, try restart again the ipsec services:\n\n# ansible-playbook 05-restart-bigip-services.yml\n"
echo -e "You can check also the BIG-IP logs:\n\n# ssh admin@10.1.1.7 tail -100 /var/log/racoon.log\n\n"

[[ $1 != "nopause" ]] && pause 'Press [Enter] key to continue... CTRL+C to Cancel'

[[ $1 != "lab" ]] && ansible-playbook $DEBUG_arg 08-create-aws-auto-scaling.yml -i ansible2.cfg

echo -e "\nIn order to follow the AWS SSG creation, tail the following logs in BIG-IQ: /var/log/restjavad.0.log and /var/log/orchestrator.log\n\n"

echo -e "\nPLAYBOOK COMPLETED, DO NOT FORGET TO TEAR DOWN EVERYTHING AT THE END OF YOUR DEMO\n\n # ./111-DELETE_ALL.sh\n\n"

exit 0
