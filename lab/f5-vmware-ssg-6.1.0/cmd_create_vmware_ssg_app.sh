#!/bin/bash
# Uncomment set command below for code debugging bash
#set -x
# Uncomment set command below for code debugging ansible
#DEBUG_arg="-vvvv"


ansible-playbook -i inventory/hosts create_vmware-auto-scaling.yml $DEBUG_arg

ansible-playbook -i notahost, create_http_bigiq_app_ssg.yaml $DEBUG_arg
