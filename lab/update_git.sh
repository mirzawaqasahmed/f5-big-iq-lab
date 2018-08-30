#!/bin/bash

## Configured in /etc/rc.local
## /home/f5student/update_git.sh
## chown -R f5student:f5student /home/f5student

# for SCJ & SEA lab
#user="f5"
user="f5student"

cd /home/$user

if [ -f ~/udf_auto_update_git ]; then
    echo -e "\nIn order to force the scripts/tools updates, delete udf_auto_update_git and re-run update_git.sh (optional).\n"
else
    echo "Cleanup previous scripts..."
    rm -rf AWS* f5-ansi* scripts* class1* Common* crontab* f5-big-iq-lab vmware-ansible
    echo "Install new scripts..."
    #git clone https://github.com/f5devcentral/f5-big-iq-lab.git --branch master
    git clone https://github.com/f5devcentral/f5-big-iq-lab.git --branch develop
    mv /home/$user/f5-big-iq-lab/lab/* /home/$user
    rm -rf /home/$user/f5-big-iq-lab
    # delete AWS 6.0.0
    echo "AWS scripts"
    rm -rf AWS-CFT-Cloud-Edition-6.0.0
    mv AWS-CFT-Cloud-Edition-6.0.1 AWS-CFT-Cloud-Edition
    echo "Fixing permissions..."
    chmod +x *py scripts/*sh scripts/*py scripts/access/*sh scripts/fps/*py f5-ansible-demo/*sh *sh AWS*/*sh AWS*/*py vmware-ansible/*sh
    echo "Installing new crontab"
    if [ "$(whoami)" == "$user" ]; then
        crontab < crontab.txt
    else
        # as root
        su - $user -c "crontab < crontab.txt"
    fi
    # Cleanup AWS credentials
    rm -f /home/$user/.aws/*

    # for SCJ - DCD lab IP
    #sed -i 's/10.1.10.6/10.192.75.181/g' /home/$user/scripts/*sh

    # for SEA - DCD lab IP
    #sed -i 's/10.1.10.6/10.11.150.16/g' /home/$user/scripts/*sh

    touch udf_auto_update_git
    rm -f last_update_*
    touch last_update_$(date +%Y-%m-%d_%H-%M)
fi

# Restart VM in case any are powered off (for VMware SSG if deployment was shutdown)
# wait 15 min for ESX to boot
sleep 900 && /home/$user/vmware-ansible/cmd_power_on_vm.sh > /home/$user/vmware-ansible/cmd_power_on_vm.log &
sleep 1100 sudo chown -R $user:$user /home/$user/vmware-ansible/cmd_power_on_vm.log 2> /dev/null
