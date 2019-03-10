#!/bin/bash

##### INSTALLATION
## Configured in /etc/rc.local
## curl -o /home/f5student/update_git.sh https://raw.githubusercontent.com/f5devcentral/f5-big-iq-lab/develop/lab/update_git.sh
## /home/f5student/update_git.sh > /home/f5student/update_git.log
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
  user="f5student"
else
  #env="sjc"
  #env="sjc2"
  env=$1
  user="f5"
fi

echo -e "Environement:${RED} $env ${NC}"

cd /home/$user

if [ -f /home/$user/udf_auto_update_git ]; then
    echo -e "\nIn order to force the scripts/tools updates, delete udf_auto_update_git and re-run update_git.sh (optional).\n"
else
    # create default BIG-IQ version file
    if [ ! -f /home/$user/bigiq_version_aws ]; then
        echo "6.1.0" > /home/$user/bigiq_version_aws
    fi
    if [ ! -f /home/$user/bigiq_version_azure ]; then
        echo "6.1.0" > /home/$user/bigiq_version_azure
    fi
    if [ ! -f /home/$user/bigiq_version_vmware ]; then
        echo "6.1.0" > /home/$user/bigiq_version_vmware
    fi

    bigiq_version_aws=$(cat /home/$user/bigiq_version_aws)
    bigiq_version_azure=$(cat /home/$user/bigiq_version_azure)
    bigiq_version_vmware=$(cat /home/$user/bigiq_version_vmware)

    echo "Cleanup previous files..."
    rm -rf build* f5-* scripts* class1* Common* crontab* > /dev/null 2>&1
    echo "Install new scripts..."
    #git clone https://github.com/f5devcentral/f5-big-iq-lab.git --branch master
    git clone https://github.com/f5devcentral/f5-big-iq-lab.git --branch develop
    mv /home/$user/f5-big-iq-lab/lab/* /home/$user

    if [[  $env == "udf" ]]; then
        # remove repo directory only if UDF, keep it for PME lab so people can run the ./containthedocs-cleanbuild.sh to validate lab guide
        rm -rf /home/$user/f5-big-iq-lab
    fi

    echo "AWS scripts"
    mv f5-aws-vpn-ssg-$bigiq_version_aws f5-aws-vpn-ssg > /dev/null 2>&1
    echo "Azure scripts"
    mv f5-azure-vpn-ssg-$bigiq_version_azure f5-azure-vpn-ssg > /dev/null 2>&1
    echo "Vmware scripts"
    mv f5-vmware-ssg-$bigiq_version_vmware f5-vmware-ssg > /dev/null 2>&1

    # cleanup other versions
    rm -rf f5-aws-vpn-ssg-* f5-azure-vpn-ssg-* > /dev/null 2>&1
    echo "Fixing permissions..."
    chmod +x *py *sh scripts/*sh scripts/*/*sh scripts/*py scripts/*/*py f5-*/*sh f5-*/*pl > /dev/null 2>&1
    chown -R $user:$user . > /dev/null 2>&1

    # Cleanup Clouds credentials
    rm -f /home/$user/.aws/*
    rm -fr /home/$user/.azure/*

    if [[  $env == "sjc" ]]; then
        # for SCJ - DCD lab IP
        sed -i 's/10.1.10.6/10.192.75.181/g' /home/$user/scripts/*sh
        sed -i 's/10.1.10.4/10.192.75.180/g' /home/$user/scripts/*sh
        sed -i '13,$d' /home/$user/crontab.txt
    fi
    if [[  $env == "sjc2" ]]; then
        # for SCJ - DCD lab IP
        sed -i 's/10.1.10.6/10.192.75.186/g' /home/$user/scripts/*sh
        sed -i 's/10.1.10.4/10.192.75.185/g' /home/$user/scripts/*sh
        sed -i '13,$d' /home/$user/crontab.txt
    fi

    echo "Installing new crontab"
    if [ "$(whoami)" == "$user" ]; then
        crontab < crontab.txt
    else
        # as root
        su - $user -c "crontab < crontab.txt"
    fi
 
    touch udf_auto_update_git
    rm -f last_update_*
    touch last_update_$(date +%Y-%m-%d_%H-%M)
fi

# run only when server boots (through /etc/rc.local as root)
currentuser=$(whoami)
if [[  $currentuser == "root" ]]; then
    # Cleanup docker
    docker kill $(docker ps -q)
    docker stop $(docker ps -q)
    docker rm $(docker ps -a -q)
    docker rmi $(docker images -q) -f
    /home/$user/scripts/cleanup-docker.sh

    # Starting docker images
    docker run --restart=always --name=hackazon -d -p 80:80 mutzel/all-in-one-hackazon:postinstall supervisord -n
    docker run --restart=always --name=dvwa -dit -p 8080:80 infoslack/dvwa
    docker run --restart=always --name=f5-hello-world-blue -dit -p 8081:8080 -e NODE='Blue' f5devcentral/f5-hello-world
    docker run --restart=always --name=f5website -dit -p 8082:80 -e F5DEMO_APP=website f5devcentral/f5-demo-httpd
    # ASM Policy Validator
    docker run --restart=unless-stopped --name=app-sec -dit -p 445:8443 artioml/f5-app-sec
    # ASM Brute Force
    docker build /home/$user/scripts/asm-brute-force -t asm-brute-force
    docker run --restart=always --name=asm-brute-force -dit asm-brute-force

    docker_hackazon_id=$(docker ps | grep hackazon | awk '{print $1}')
    docker cp f5-demo-app-troubleshooting/f5_browser_issue.php $docker_hackazon_id:/var/www/hackazon/web
    docker cp f5-demo-app-troubleshooting/f5-logo-black-and-white.png $docker_hackazon_id:/var/www/hackazon/web
    docker cp f5-demo-app-troubleshooting/f5-logo.png $docker_hackazon_id:/var/www/hackazon/web
    docker cp f5-demo-app-troubleshooting/f5_capacity_issue.php $docker_hackazon_id:/var/www/hackazon/web
    docker exec -i -t $docker_hackazon_id sh -c "chown -R www-data:www-data /var/www/hackazon/web"

    docker images
    docker ps -a
    docker ps

    # Create default SSG at the boot and restart the VM if already created
    sleep 900 && /home/$user/f5-vmware-ssg/cmd_create_vmware_ssg_app.sh > /home/$user/f5-vmware-ssg/cmd_create_vmware_ssg_app.log 2> /dev/null &
    sleep 1100 && sudo chown -R $user:$user /home/$user/f5-vmware-ssg/*.log 2> /dev/null &
fi

exit 0