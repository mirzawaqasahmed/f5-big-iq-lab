#!/bin/bash
# Uncomment set command below for code debugging bash
#set -x

ip_cm1="$(cat bigiq_onboard_var/bigiq-cm-01.yml| grep bigiq_onboard_server | awk '{print $2}')"
ip_dcd1="$(cat bigiq_onboard_var/bigiq-dcd-01.yml| grep bigiq_onboard_server | awk '{print $2}')"

# basic auth needs to be turn on on BIG-IQ.
ssh root@$ip_cm1 clear-rest-storage -d
ssh root@$ip_dcd1 clear-rest-storage -d

ansible-galaxy remove f5devcentral.bigiq_onboard