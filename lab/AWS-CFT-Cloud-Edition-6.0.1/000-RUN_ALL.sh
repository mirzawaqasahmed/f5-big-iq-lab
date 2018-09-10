#!/bin/bash
# Uncomment set command below for code debugging bash
#set -x
# Uncomment set command below for code debugging ansible
#DEBUG_arg="-vvvv"

function pause(){
   read -p "$*"
}

c=$(grep CUSTOMER_GATEWAY_IP ./config.yml | grep '0.0.0.0' | wc -l)
c2=$(grep '<name>' ./config.yml | wc -l)
c3=$(grep '<name_of_the_aws_key>' ./config.yml | wc -l)
c4=$(grep '<key_id>' ./config.yml | wc -l)

if [[ $c == 1 || $c2  == 1 || $c3  == 1 || $c4  == 1 ]]; then
       echo -e "\nPlease, edit config.yml to configure:\n - AWS credential\n - AWS Region\n - Prefix\n - Key Name\n - Customer Gateway public IP address (SEA-vBIGIP01.termmarc.com's public IP)"
	     echo -e "\nOption to run the script:\n\n# ./000-RUN_ALL.sh\n\n or\n\n# nohup ./000-RUN_ALL.sh nopause & (the script will be executed with no breaks between the steps)\n\n"
       exit 1
fi

clear

## if any variables are passed to the script ./000-RUN_ALL.sh (e.g. 000-RUN_ALL.sh nopause), no pause will happen during the execution of the script

echo -e "\nDid you subscribed and agreed to the software terms for F5 BIG-IP Virtual Edition - BEST - (BYOL) in AWS Marketplace?\n\n"
echo -e "https://aws.amazon.com/marketplace/pp/B07G5MT2KT/\n\n"

echo -e "EXPECTED TIME: ~45 min\n\n"

[[ $1 != "nopause" ]] && pause 'Press [Enter] key to continue... CTRL+C to Cancel'

echo -e "\nTIME: $(date +"%H:%M")"
ansible-playbook $DEBUG_arg 01-install.yml
echo -e "\nTIME: $(date +"%H:%M")"

[[ $1 != "nopause" ]] && pause 'Press [Enter] key to continue... CTRL+C to Cancel'

echo -e "\nTIME: $(date +"%H:%M")"
ansible-playbook $DEBUG_arg 02-vpc-elb.yml
echo -e "\nTIME: $(date +"%H:%M")"

[[ $1 != "nopause" ]] && pause 'Press [Enter] key to continue... CTRL+C to Cancel'

echo -e "\nTIME: $(date +"%H:%M")"
ansible-playbook $DEBUG_arg 03-vpn.yml
echo -e "\nTIME: $(date +"%H:%M")"
./03-customerGatewayConfigExport.sh

[[ $1 != "nopause" ]] && pause 'Press [Enter] key to continue... CTRL+C to Cancel'

echo -e "\nTIME: $(date +"%H:%M")"
ansible-playbook $DEBUG_arg 04-configure-bigip.yml
echo -e "\nTIME: $(date +"%H:%M")"

echo -e "\nSleep 10 seconds"
sleep 10

echo -e "\nTIME: $(date +"%H:%M")"
ansible-playbook $DEBUG_arg 05-restart-bigip-services.yml
echo -e "\nTIME: $(date +"%H:%M")"

echo -e "\nSleep 20 seconds"
sleep 20

# WA Tunnel
ssh admin@10.1.1.7 tmsh modify net tunnels tunnel aws_conn_tun_1 mtu 1398
ssh admin@10.1.1.7 tmsh modify net tunnels tunnel aws_conn_tun_2 mtu 1398

echo -e "\nTIME: $(date +"%H:%M")"
ansible-playbook $DEBUG_arg 06-ubuntu-apache2.yml
echo -e "\nTIME: $(date +"%H:%M")"

#[[ $1 != "nopause" ]] && pause 'Press [Enter] key to continue... CTRL+C to Cancel'

# Not needed, this playbook creates a service catalog template (custom)
#ansible-playbook $DEBUG_arg 07-create-aws-ssg-templates.yml -i ansible2.cfg

echo -e "\nSleep 3 min (to allow time for the VPN to come up)"
sleep 180

echo -e "\nVPN status:\n"
aws ec2 describe-vpn-connections | grep -A 15 VgwTelemetry

echo -e "\nIPsec logs on the BIG-IP SEA-vBIGIP01.termmarc.com"
ssh admin@10.1.1.7 tail -10 /var/log/racoon.log

echo -e "\nIf the VPN is not UP, check previous playbooks execution are ALL successfull.\nIf they are, try to restart the ipsec services:\n\n# ansible-playbook 05-restart-bigip-services.yml\n"
echo -e "You can check also the BIG-IP logs:\n\n# ssh admin@10.1.1.7 tail -100 /var/log/racoon.log\n\n"

echo -e "Note: check if the VPN is up (./check_vpn_aws.sh)."

echo -e "\nTIME: $(date +"%H:%M")"

[[ $1 != "nopause" ]] && pause 'Press [Enter] key to continue... CTRL+C to Cancel'

echo -e "\nTIME: $(date +"%H:%M")"
ansible-playbook $DEBUG_arg 08-create-aws-auto-scaling.yml -i ansible2.cfg
echo -e "\nTIME: $(date +"%H:%M")"

echo -e "\nIn order to follow the AWS SSG creation, tail the following logs in BIG-IQ:\n/var/log/restjavad.0.log and /var/log/orchestrator.log\n"

[[ $1 != "nopause" ]] && pause 'Press [Enter] key to continue... CTRL+C to Cancel'

echo -e "\nTIME: $(date +"%H:%M")"

echo -e "\nApplication Creation: (it will start once AWS SSG creation is completed)\n"
python 09-create-aws-waf-app.py
echo -e "\nTIME: $(date +"%H:%M")"

# add ab in crontab to simulate traffic
echo -e "\nAdding traffic generator in crontab."
PREFIX="$(head -30 config.yml | grep PREFIX | awk '{ print $2}')"
if [ -f ./cache/$PREFIX/1-vpc.yml ]; then
   ELB_DNS="$(head -10 ./cache/$PREFIX/1-vpc.yml | grep ELB_DNS | awk '{ print $2}' | cut -d '"' -f 2)"
   (crontab -l ; echo "* * * * * /usr/bin/ab -n 1000 -c 500 https://$ELB_DNS/" ) | crontab -
   echo -e "\nAplication URL: $ELB_DNS"
else
   echo "Something wrong happen, no ./cache/$PREFIX/1-vpc.yml"
fi

echo -e "\nTIME: $(date +"%H:%M")"

echo -e "\nNEXT STEPS ON BIG-IQ:\n\n1. Allow Paul to manage the Application previously created:\n  - Connect as admin in BIG-IQ and go to : System > User Management > Users and select Paul.\n  - Select the Role udf-<yourname>-elb, drag it to the right\n  - Save & Close.\n"

echo -e "2. Allow Paul to use the AWS SSG previously  created:\n  - Connect as admin in BIG-IQ and go to : System > Role Management > Roles and\n  select CUSTOM ROLES > Application Roles > Application Creator AWS role.\n  - Select the Service Scaling Groups udf-<yourname>-aws-ssg, drag it to the right\n  - Save & Close.\n"

echo -e "\nPLAYBOOK COMPLETED, DO NOT FORGET TO TEAR DOWN EVERYTHING AT THE END OF YOUR DEMO\n\n# ./111-DELETE_ALL.sh\n\n or\n\n# nohup ./111-DELETE_ALL.sh nopause &\n\n"

echo -e "\n/!\ If you stop your deployment, the Customer Gateway public IP address will change (SEA-vBIGIP01.termmarc.com's public IP).\nRun the 111-DELETE_ALL.sh script and start a new fresh UDF deployment.\n\n"

exit 0
