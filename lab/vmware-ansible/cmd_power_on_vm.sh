#!/bin/bash
# Uncomment set command below for code debuging bash
#set -x

cd /home/f5/vmware-ansible

ansible-playbook -i notahost, facts_vm.yaml

jq '.virtual_machines' vmfact.json | grep uuid | awk -F: '{print $2}' | sed -n 's/^.*"\(.*\)".*$/\1/p' > uuid.txt

while IFS= read -r uuid
do
  echo "$uuid"
  ansible-playbook -i inventory_vm.ini, power_on_vm.yaml --extra-vars "uuid=$uuid" -vvvv
done < uuid.txt

rm -f vmfact.json uuid.txt