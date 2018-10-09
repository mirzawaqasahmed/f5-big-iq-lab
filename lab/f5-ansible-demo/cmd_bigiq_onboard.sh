#!/bin/bash
# Uncomment set command below for code debugging bash
#set -x
# Uncomment set command below for code debugging ansible
#DEBUG_arg="-vvvv"

ip_cm1="$(cat bigiq_onboard_var/bigiq-cm-01.yml| grep bigiq_onboard_server | awk '{print $2}')"
ip_dcd1="$(cat bigiq_onboard_var/bigiq-dcd-01.yml| grep bigiq_onboard_server | awk '{print $2}')"

# basic auth needs to be turn on on BIG-IQ.
ssh root@$ip_cm1 set-basic-auth on
ssh root@$ip_dcd1 set-basic-auth on

ansible-galaxy install f5devcentral.bigiq_onboard --force

ansible-playbook -i bigiq_onboard_var/hosts bigiq_onboard.yaml $DEBUG_arg

# SJC lab 2
# ansible-playbook -i bigiq_onboard_var/hosts .bigiq_onboard_sjc2.yaml $DEBUG_arg