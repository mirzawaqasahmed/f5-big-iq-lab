#!/bin/bash

cd /home/f5

if [ -f ~/udf_auto_update_git ]; then
    echo -e "\n\nIn order to force the updates, delete udf_auto_update_git and re-run update_git.sh\n\n"
else
    echo "Cleanup previous scripts..."
    rm -rf AWS* f5-ansi* scripts* class1* Common* crontab* f5-big-iq-lab
    echo "Install new scripts..."
    #git clone https://github.com/f5devcentral/f5-big-iq-lab.git --branch master
    git clone https://github.com/f5devcentral/f5-big-iq-lab.git --branch develop
    mv /home/f5/f5-big-iq-lab/lab/* /home/f5
    rm -rf /home/f5/f5-big-iq-lab
    # delete AWS 6.0.0
    echo "AWS scripts"
    rm -rf AWS-CFT-Cloud-Edition-6.0.0
    mv AWS-CFT-Cloud-Edition-6.0.1 AWS-CFT-Cloud-Edition
    echo "Fixing permissions..."
    chmod +x *py scripts/*sh scripts/*py scripts/access/*sh scripts/fps/*py f5-ansible-demo/*sh *sh AWS*/*sh AWS*/*py
    # Cleanup AWS credentials
    rm -f /home/f5student/.aws/*

    # for SCJ - DCD IP
    #sed -i 's/10.1.10.6/10.192.75.181/g' /home/f5/scripts/*sh

    # for SEA - DCD IP
    #sed -i 's/10.1.10.6/10.11.150.16/g' /home/f5/scripts/*sh

    touch udf_auto_update_git
    rm -f last_update_*
    touch last_update_$(date +%Y-%m-%d_%k-%M)
fi