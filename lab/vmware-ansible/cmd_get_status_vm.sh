#!/bin/bash
# Uncomment set command below for code debuging bash
#set -x

cd /home/f5/vmware-ansible

ansible-playbook -i notahost, get_status_vm.yaml

jq '.virtual_machines' vmfact.json | grep uuid | awk -F: '{print $2}' | sed -n 's/^.*"\(.*\)".*$/\1/p' > uuid.txt

n=$(wc -l uuid.txt | awk '{ print $1 }')

if [ "$n" -gt "1" ]; then
    while IFS= read -r uuid
    do
        echo -e "\n#### $uuid"
        ansible-playbook -i notahost, power_on_vm.yaml --extra-vars "uuid=$uuid"
    done < uuid.txt
else
    echo "No SSG VM to power on."
fi

rm -f vmfact.json uuid.txt