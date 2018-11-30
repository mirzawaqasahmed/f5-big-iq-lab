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
    echo -e "\nUsage: ${RED} $0 <playbook.yml> <udf/sjc/sjc2/sea> ${NC} (1st parameter mandatory)\n"
    if [[  $env != "udf" ]]; then
        ls -l .*.yml
    else
        ls -lrt *.yml
    fi
    exit 1;
fi

if [ ! -f $1 ]; then
    echo -e "\n${RED} $1 playbook ${NC} does not exist.\n"
    if [[  $env != "udf" ]]; then
        ls -l .*.yml
    else
        ls -lrt *.yml
    fi
    exit 2;
fi

ansible-playbook -i inventory/$env-hosts $1 $DEBUG_arg
