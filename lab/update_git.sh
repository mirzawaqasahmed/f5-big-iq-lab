#!/bin/bash

##### INSTALLATION
## Configured in /etc/rc.local
## /home/f5student/update_git.sh > //home/f5student/update_git.log
## chown -R f5student:f5student /home/f5student

#################### INFORMATION #################### 

# DEFAULT SSG ONBOARDING ARE 6.0.1 for AWS and 6.1.0 for Azure.
# If you need to force AWS to use 6.1.0 updated scripts run, prior saving the blueprint.
# echo "6.1.0" > ~/bigiq_version_aws

# BEFORE SAVING THE BLUEPRINT, DELETE udf_auto_update_git so new deployment will download the latest version of the lab scripts/tools.
# rm ~/udf_auto_update_git 

#####################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

if [ -z "$1" ]; then
  env="udf"
else
  #env="sjc"
  #env="sjc2"
  #env="sea"
  env=$1
fi

echo -e "Environement:${RED} $env ${NC}"

currentuser=$(whoami)
if [[  $currentuser == "f5" ]]; then
    # for SCJ & SEA lab
    user="f5"
else
    user="f5student"
fi

cd /home/$user

if [ -f /home/$user/udf_auto_update_git ]; then
    echo -e "\nIn order to force the scripts/tools updates, delete udf_auto_update_git and re-run update_git.sh (optional).\n"
else
    # create default BIG-IQ version file (min)
    if [ ! -f /home/$user/bigiq_version_aws ]; then
        echo "6.0.1" > /home/$user/bigiq_version_aws
    fi
    if [ ! -f /home/$user/bigiq_version_azure ]; then
        echo "6.1.0" > /home/$user/bigiq_version_azure
    fi

    bigiq_version_aws=$(cat /home/$user/bigiq_version_aws)
    bigiq_version_azure=$(cat /home/$user/bigiq_version_azure)

    echo "Cleanup previous files..."
    rm -rf AWS* AZURE* f5-ansi* f5-bigiq-onboarding f5-ansible-bigiq-as3-demo scripts* class1* Common* crontab* f5-big-iq-lab vmware-ansible demo-app-troubleshooting
    echo "Install new scripts..."
    #git clone https://github.com/f5devcentral/f5-big-iq-lab.git --branch master
    git clone https://github.com/f5devcentral/f5-big-iq-lab.git --branch develop
    mv /home/$user/f5-big-iq-lab/lab/* /home/$user
    rm -rf /home/$user/f5-big-iq-lab
    echo "AWS scripts"
    mv AWS-Cloud-Edition-$bigiq_version_aws AWS-Cloud-Edition
    echo "Azure scripts"
    mv AZURE-Cloud-Edition-$bigiq_version_azure AZURE-Cloud-Edition
    # cleanup other versions
    rm -rf AWS-Cloud-Edition-* AZURE-Cloud-Edition-*
    echo "Fixing permissions..."
    chmod +x *py *sh scripts/*sh scripts/*py scripts/*/*sh scripts/*/*py f5-*/*sh f5-*/*pl AWS*/*sh AWS*/*py  AZURE*/*sh AZURE*/*py vmware-ansible/*sh demo-app-troubleshooting/*sh > /dev/null 2>&1
    chown -R $user:$user . > /dev/null 2>&1
    echo "Installing new crontab"
    if [ "$(whoami)" == "$user" ]; then
        crontab < crontab.txt
    else
        # as root
        su - $user -c "crontab < crontab.txt"
    fi

    # Cleanup AWS and Azure credentials
    rm -f /home/$user/.aws/*
    rm -fr /home/$user/.azure/*

    if [[  $env == "sjc" ]]; then
        # for SCJ - DCD lab IP
        sed -i 's/10.1.10.6/10.192.75.181/g' /home/$user/scripts/*sh
        sed -i 's/10.1.10.4/10.192.75.180/g' /home/$user/scripts/*sh
    fi
    if [[  $env == "sjc2" ]]; then
        # for SCJ - DCD lab IP
        sed -i 's/10.1.10.6/10.192.75.186/g' /home/$user/scripts/*sh
        sed -i 's/10.1.10.4/10.192.75.185/g' /home/$user/scripts/*sh
    fi
    if [[  $env == "sea" ]]; then
        # for SEA - DCD lab IP
        sed -i 's/10.1.10.6/10.11.150.16/g' /home/$user/scripts/*sh
        sed -i 's/10.1.10.4/10.11.150.14/g' /home/$user/scripts/*sh
    fi
    
    touch udf_auto_update_git
    rm -f last_update_*
    touch last_update_$(date +%Y-%m-%d_%H-%M)

fi

# run only when server boots (through /etc/rc.local as root)
currentuser=$(whoami)
if [[  $currentuser == "root" ]]; then
    # Cleanup docker
    sudo docker kill $(sudo docker ps -q)
    sudo docker rm $(sudo docker ps -a -q)
    sudo docker rmi $(sudo docker images -q) -f
    sudo /home/$user/scripts/cleanup-docker.sh

    # Installing docker images
    sudo docker run --restart=always --name=hackazon -d -p 80:80 mutzel/all-in-one-hackazon:postinstall supervisord -n
    sudo docker run --restart=always --name=dvwa -dit -p 8080:80 infoslack/dvwa
    sudo docker run --restart=always --name=f5-hello-world-blue -dit -p 8081:8080 -e NODE='Blue' f5devcentral/f5-hello-world
    sudo docker run --restart=always --name=f5website -dit -p 8082:80 -e F5DEMO_APP=website f5devcentral/f5-demo-httpd
    # ASM Policy Validator:
    sudo docker run --restart=unless-stopped --name=app-sec -dit -p 445:8443 artioml/f5-app-sec

    docker_hackazon_id=$(sudo docker ps | grep hackazon | awk '{print $1}')
    sudo docker cp demo-app-troubleshooting/f5_browser_issue.php $docker_hackazon_id:/var/www/hackazon/web
    sudo docker cp demo-app-troubleshooting/f5-logo-black-and-white.png $docker_hackazon_id:/var/www/hackazon/web
    sudo docker cp demo-app-troubleshooting/f5-logo.png $docker_hackazon_id:/var/www/hackazon/web
    sudo docker exec -i -t $docker_hackazon_id sh -c "chown -R www-data:www-data /var/www/hackazon/web"

    # Install AS3 Validator
    # https://github.com/F5Networks/f5-appsvcs-extension/tree/master/AS3-schema-validator
    sudo docker run --restart=always --name=as3validatortool -dit -p 5000:5000 node
    docker_as3validatortool_id=$(sudo docker ps | grep as3validatortool | awk '{print $1}')
    wget https://github.com/F5Networks/f5-appsvcs-extension/raw/master/AS3-schema-validator/3.6.0/build.zip
    rm -rf build
    unzip build.zip
    sudo docker cp build $docker_as3validatortool_id:/
    sudo docker exec -i -t $docker_as3validatortool_id sh -c "yarn global add serve"
    sudo docker exec -i -t $docker_as3validatortool_id sh -c "npm install -g serve"
    sudo docker exec -i -t $docker_as3validatortool_id sh -c "apt-get update"
    sudo docker exec -i -t $docker_as3validatortool_id sh -c "apt install xsel -y"
    sudo docker exec -i -t $docker_as3validatortool_id sh -c "cd /build; serve -s build -p 5000 &"

    sudo docker ps

    # Restart VM in case any are powered off (for VMware SSG if deployment was shutdown)
    # wait 15 min for ESX to boot
    sleep 900 && /home/$user/vmware-ansible/cmd_power_on_vm.sh > /home/$user/vmware-ansible/cmd_power_on_vm.log 2> /dev/null &
    sleep 1100 && sudo chown -R $user:$user /home/$user/vmware-ansible/cmd_power_on_vm.log 2> /dev/null &
fi