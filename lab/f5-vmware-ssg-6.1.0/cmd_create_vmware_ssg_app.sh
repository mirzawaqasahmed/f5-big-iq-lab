#!/bin/bash
# Uncomment set command below for code debugging bash
#set -x
# Uncomment set command below for code debugging ansible
#DEBUG_arg="-vvvv"


ansible-playbook $DEBUG_arg create_vmware-auto-scaling.yml -i inventory/hosts

ansible-playbook $DEBUG_arg -i notahost, create_http_bigiq_app_ssg.yaml

./cmd_get_status_vm.sh
