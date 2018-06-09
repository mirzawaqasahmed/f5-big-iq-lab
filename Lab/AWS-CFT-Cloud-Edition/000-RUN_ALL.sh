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
       echo -e "\nPlease, edit config.yml to configure:\n - AWS credential\n - AWS Region\n - Prefix\n - Key Name\n - Customer Gateway public IP address (SEA-vBIGIP01.termmarc.com's public IP)\n\n"
	   echo -e "\nOption to run the script:\n# ./000-RUN_ALL.sh lab (this will not create the SSG objects in BIG-IQ)"
	   echo -e "# ./000-RUN_ALL.sh nopause (the script will be executed with no breaks between the steps)\n\n"
       exit 1
fi


clear

## if any variables are passed to the script ./000-RUN_ALL.sh (e.g. 000-RUN_ALL.sh nopause), no pause will happen during the execution of the script

echo -e "Did you subscribed and agreed to the software terms in AWS Marketplace?"
echo -e "https://aws.amazon.com/marketplace/search/results?page=1&filters=pricing_plan_attributes&pricing_plan_attributes=BYOL&searchTerms=F5+BIG-IP"

pause 'Press [Enter] key to continue... CTRL+C to Cancel'

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

echo -e "\nIn order to follow the AWS SSG creation, tail the following logs in BIG-IQ: /var/log/restjavad.0.log and /var/log/orchestrator.log\n"

echo -e "\nPLAYBOOK COMPLETED, DO NOT FORGET TO TEAR DOWN EVERYTHING AT THE END OF YOUR DEMO\n\n # ./111-DELETE_ALL.sh\n\n"

echo -e "NEXT STEPS ON BIG-IQ:\n\n1. Allow Paul to use the AWS SSG previously created:\n  - Connect as admin in BIG-IQ and go to : System > Role Management > Roles and\n  select CUSTOM ROLES > Application Roles > Application Creator AWS role.\n  - Select the Service Scaling Groups udf-<yourname>-aws-ssg, drag it to the right\n  - Save & Close.\n"

echo -e "2. Create an Application:\n  Once the AWS SSG is ready (showing green in the UI), connect as paul (password paul) in BIG-IQ and\n  go to Application > Applications, click on Create and select the template Default-AWS-f5-HTTPS-WAF-lb-template.\n  - Set App name\n  - Set ELB FQDN in Domain Names\n  - Select the AWS SSG udf-<yourname>-aws-ssg\n  - Set ELB name udf-<yourname>-elb\n  - Create 2 listeners:\n     TCP 443 - TCP 443\n     TCP 80  - TCP 80\n  - Application Server: 172.17.2.50\n\n"

exit 0
