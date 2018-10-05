#!/bin/bash

## Configured in /etc/rc.local
## /home/f5student/update_git.sh > //home/f5student/update_git.log
## chown -R f5student:f5student /home/f5student

# for SCJ & SEA lab
#user="f5"
user="f5student"

cd /home/$user

if [ -f /home/$user/udf_auto_update_git ]; then
    echo -e "\nIn order to force the scripts/tools updates, delete udf_auto_update_git and re-run update_git.sh (optional).\n"
else
    echo "Cleanup previous files..."
    rm -rf AWS* f5-ansi* scripts* class1* Common* crontab* f5-big-iq-lab vmware-ansible demo-app-troubleshooting
    echo "Install new scripts..."
    #git clone https://github.com/f5devcentral/f5-big-iq-lab.git --branch master
    git clone https://github.com/f5devcentral/f5-big-iq-lab.git --branch develop
    mv /home/$user/f5-big-iq-lab/lab/* /home/$user
    rm -rf /home/$user/f5-big-iq-lab
    echo "AWS scripts"
    mv AWS-Cloud-Edition-6.0.1 AWS-Cloud-Edition
    echo "Azure scripts"
    mv AZURE-Cloud-Edition-6.1.0 AZURE-Cloud-Edition
    echo "Fixing permissions..."
    chmod +x *py scripts/*sh scripts/*py scripts/access/*sh scripts/access/*py scripts/fps/*py f5-ansible-demo/*sh *sh AWS*/*sh AWS*/*py  AZURE*/*sh AZURE*/*py vmware-ansible/*sh demo-app-troubleshooting/*sh
    chown -R $user:$user .
    echo "Installing new crontab"
    if [ "$(whoami)" == "$user" ]; then
        crontab < crontab.txt
    else
        # as root
        su - $user -c "crontab < crontab.txt"
    fi

    # Cleanup AWS credentials
    rm -f /home/$user/.aws/*
    rm -f /home/$user/.azure/*
    # for SCJ - DCD lab IP
    #sed -i 's/10.1.10.6/10.192.75.181/g' /home/$user/scripts/*sh

    # for SEA - DCD lab IP
    #sed -i 's/10.1.10.6/10.11.150.16/g' /home/$user/scripts/*sh

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
    sudo docker pull mutzel/all-in-one-hackazon:postinstall
    sudo docker run --name hackazon2 -d -p 80:80 --restart=always mutzel/all-in-one-hackazon:postinstall supervisord -n
    docker_hackazon_id=$(sudo docker ps | grep hackazon | awk '{print $1}')
    sudo docker cp demo-app-troubleshooting/f5_browser_issue.php $docker_hackazon_id:/var/www/hackazon/web
    sudo docker cp demo-app-troubleshooting/f5-logo-black-and-white.png $docker_hackazon_id:/var/www/hackazon/web
    sudo docker cp demo-app-troubleshooting/f5-logo.png $docker_hackazon_id:/var/www/hackazon/web
    sudo docker exec -i -t $docker_hackazon_id sh -c "chown -R www-data:www-data /var/www/hackazon/web"

    sudo docker run -dit -p 8080:80 --name dvwa --restart=always citizenstig/dvwa 
    sudo docker run -dit -p 8081:8080 --restart=always f5devcentral/f5-hello-world
    sudo docker run -dit -p 8082:80 --restart=always -e F5DEMO_APP=website f5devcentral/f5-demo-httpd
    sudo docker run -dit -p 8083:80 --restart=always -e F5DEMO_APP=frontend f5devcentral/f5-demo-httpd
    sudo docker run -dit -p 8084:80 --restart=always -e F5DEMO_APP=backend f5devcentral/f5-demo-httpd

    sudo docker ps

    # Restart VM in case any are powered off (for VMware SSG if deployment was shutdown)
    # wait 15 min for ESX to boot
    sleep 900 && /home/$user/vmware-ansible/cmd_power_on_vm.sh > /home/$user/vmware-ansible/cmd_power_on_vm.log 2> /dev/null &
    sleep 1100 && sudo chown -R $user:$user /home/$user/vmware-ansible/cmd_power_on_vm.log 2> /dev/null &
fi