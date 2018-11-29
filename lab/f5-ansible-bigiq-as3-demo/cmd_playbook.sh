#!/bin/bash
# Uncomment set command below for code debugging bash
#set -x
# Uncomment set command below for code debugging ansible
#DEBUG_arg="-vvvv"

# Default value set to UDF
if [ -z "$1" ]; then
  env="udf"
else
  #env="sjc"
  #env="sjc2"
  #env="sea"
  env=$1
fi

# Usage
if [[ -z $2 ]]; then
    echo -e "\nUsage: $0 <udf/sjc/sjc2/sea> <playbook.yml>\n"
    ls -lrt *.yml
    if [[  $env != "udf" ]]; then
        ls -lrt .*.yml
    fi
    exit 1;
fi

if [ ! -f $2 ]; then
    echo -e "\n$2 playbook does not exist.\n"
    ls -lrt *.yml
    if [[  $env != "udf" ]]; then
        ls -lrt .*.yml
    fi
    exit 2;
fi

ansible-playbook -i inventory/$env-hosts $2 $DEBUG_arg
