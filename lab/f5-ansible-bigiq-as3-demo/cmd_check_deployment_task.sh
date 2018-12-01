#!/bin/bash
# Uncomment set command below for code debugging bash
#set -x
# Uncomment set command below for code debugging ansible
#DEBUG_arg="-vvvv"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default value set to UDF
if [ -z "$2" ]; then
  env="udf"
else
  #env="sjc"
  #env="sjc2"
  #env="sea"
  env=$2
fi

echo -e "\nEnvironement:${RED} $env ${NC}\n"

# Usage
if [[ -z $1 ]]; then
    echo -e "\nUsage: ${RED} $0 <task ID> <udf/sjc/sjc2/sea> ${NC} (1st parameter mandatory)\n"
    exit 1;
fi

# pass a variable in Ansible playbook
if [[  $env != "udf" ]]; then
    ansible-playbook -i inventory/$env-hosts .as3_bigiq_check_task_status_$env.yml $DEBUG_arg --extra-vars "taskid=$1"
else
    ansible-playbook -i inventory/$env-hosts as3_bigiq_check_task_status.yml $DEBUG_arg --extra-vars "taskid=$1"
fi



