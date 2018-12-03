#!/bin/bash
# Uncomment set command below for code debugging bash
#set -x
# Uncomment set command below for code debugging ansible
#DEBUG_arg="-vvvv"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

function pause(){
   read -p "$*"
}

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
    echo -e "\nUsage: ${RED} $0 <pause/nopause> <udf/sjc/sjc2/sea> ${NC}\n"
    exit 1;
fi

[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

if [[  $env != "udf" ]]; then
    ansible-playbook -i inventory/$env-hosts .as3_bigiq_task01_create_http_app_$env.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    sleep 10

    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    ansible-playbook -i inventory/$env-hosts .as3_bigiq_task02_create_https_app_$env.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    sleep 10

    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    ansible-playbook -i inventory/$env-hosts .as3_bigiq_task03a_create_waf_app_$env.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    sleep 10

    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    ansible-playbook -i inventory/$env-hosts .as3_bigiq_task03b_create_waf_ext_policy_app_$env.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    sleep 10

    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    ansible-playbook -i inventory/$env-hosts .as3_bigiq_task04_create_generic_app_$env.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    sleep 10

    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    ansible-playbook -i inventory/$env-hosts .as3_bigiq_task05a_modify_post_http_app_$env.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    sleep 10

    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    ansible-playbook -i inventory/$env-hosts .as3_bigiq_task05b_modify_patch_http_app_$env.yml $DEBUG_arg
    sleep 10

    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    ansible-playbook -i inventory/$env-hosts .as3_bigiq_task06_create_template_$env.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    sleep 10

    # echo -e "\n${RED}Warning${NC}: Follow Task 8 from the lab guide:\n Assign ${BLUE}HTTPcustomTemplateTask6${NC} template to Applicator Creator AS3 custom role and remove the ${BLUE}default${NC} template from the allowed list).\n"
    pause "Press [Enter] key to continue... CTRL+C to Cancel"
    ansible-playbook -i inventory/$env-hosts .as3_bigiq_task08_create_http_app_$env.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    sleep 10

    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    ansible-playbook -i inventory/$env-hosts .as3_bigiq_task10_create_http_app_fqdn_nodes_$env.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
else
    ansible-playbook -i inventory/$env-hosts as3_bigiq_task01_create_http_app.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    sleep 10

    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    ansible-playbook -i inventory/$env-hosts as3_bigiq_task02_create_https_app.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    sleep 10

    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    ansible-playbook -i inventory/$env-hosts as3_bigiq_task03a_create_waf_app.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    sleep 10

    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    ansible-playbook -i inventory/$env-hosts as3_bigiq_task03b_create_waf_ext_policy_app.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    sleep 10


    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    ansible-playbook -i inventory/$env-hosts as3_bigiq_task04_create_generic_app.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    sleep 10

    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    ansible-playbook -i inventory/$env-hosts as3_bigiq_task05a_modify_post_http_app.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    sleep 10

    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    ansible-playbook -i inventory/$env-hosts as3_bigiq_task05b_modify_patch_http_app.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    sleep 10

    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    ansible-playbook -i inventory/$env-hosts as3_bigiq_task06_create_template.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    sleep 10

    echo -e "\n${RED}Warning${NC}: Follow Task 8 from the lab guide:\n Assign ${BLUE}HTTPcustomTemplateTask6${NC} template to Applicator Creator AS3 custom role and remove the ${BLUE}default${NC} template from the allowed list).\n"
    pause "Press [Enter] key to continue... CTRL+C to Cancel"
    ansible-playbook -i inventory/$env-hosts as3_bigiq_task08_create_http_app.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    sleep 10

    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
    [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
    ansible-playbook -i inventory/$env-hosts as3_bigiq_task10_create_http_app_fqdn_nodes.yml $DEBUG_arg
    echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"
fi

