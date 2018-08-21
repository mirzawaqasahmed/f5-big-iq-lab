#!/bin/bash
# Uncomment set command below for code debuging bash
#set -x

cd /home/f5/vmware-ansible

ansible-playbook -i notahost, get_status_vm.yaml

jq '.virtual_machines' vmfact.json

rm -f vmfact.json