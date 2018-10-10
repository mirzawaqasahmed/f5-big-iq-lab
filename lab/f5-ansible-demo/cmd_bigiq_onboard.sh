#!/bin/bash
# Uncomment set command below for code debugging bash
#set -x
# Uncomment set command below for code debugging ansible
#DEBUG_arg="-vvvv"

env="udf"
#env="sjc2"

ip_cm1="$(cat inventory/group_vars/$env-bigiq-cm-01.yml| grep bigiq_onboard_server | awk '{print $2}')"
ip_dcd1="$(cat inventory/group_vars/$env-bigiq-dcd-01.yml| grep bigiq_onboard_server | awk '{print $2}')"

# basic auth needs to be turn on on BIG-IQ.
#ssh root@$ip_cm1 set-basic-auth on
#ssh root@$ip_dcd1 set-basic-auth on

ansible-galaxy install f5devcentral.bigiq_onboard --force

ansible-playbook -i inventory/$env-hosts bigiq_onboard.yaml $DEBUG_arg

# SJC lab 2
# ansible-playbook -i inventory/$env-hosts .bigiq_onboard_sjc2.yaml $DEBUG_arg

# Add DCD to CM
curl https://s3.amazonaws.com/big-iq-quickstart-cf-templates-aws/6.0.1.1/scripts.tar.gz > scripts.tar.gz
rm -rf scripts 
tar --strip-components=1 -xPvzf scripts.tar.gz 2> /dev/null &

echo "Type BIG-IQ CM root password:"
ssh-copy-id root@$ip_cm1
echo "Type BIG-IQ DCD root password:"
ssh-copy-id root@$ip_dcd1

scp -rp scripts root@$ip_cm1:/root
ssh root@$ip_cm1 << EOF
  cd /root/scripts
  /usr/local/bin/python2.7 ./add-dcd.py --DCD_IP_ADDRESS $ip_dcd1
  sleep 5
  /usr/local/bin/python2.7 ./activate-dcd-services.py --DCD_IP_ADDRESS $ip_dcd1 --LIST_SERVICES asm
  /usr/local/bin/python2.7 ./activate-dcd-services.py --DCD_IP_ADDRESS $ip_dcd1 --LIST_SERVICES access
  /usr/local/bin/python2.7 ./activate-dcd-services.py --DCD_IP_ADDRESS $ip_dcd1 --LIST_SERVICES dos
  /usr/local/bin/python2.7 ./activate-dcd-services.py --DCD_IP_ADDRESS $ip_dcd1 --LIST_SERVICES websafe
  /usr/local/bin/python2.7 ./activate-dcd-services.py --DCD_IP_ADDRESS $ip_dcd1 --LIST_SERVICES ipsec
  /usr/local/bin/python2.7 ./activate-dcd-services.py --DCD_IP_ADDRESS $ip_dcd1 --LIST_SERVICES afm
EOF