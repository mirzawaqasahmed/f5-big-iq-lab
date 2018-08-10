#!/bin/bash
cd /home/f5
rm -rf AWS* bigip* f5-ansi* scripts* class1* Common* crontab* f5-big-iq-lab
#git clone https://github.com/f5devcentral/f5-big-iq-lab.git --branch master
git clone https://github.com/f5devcentral/f5-big-iq-lab.git --branch develop
mv /home/f5/f5-big-iq-lab/lab/* /home/f5
rm -rf /home/f5/f5-big-iq-lab
chmod +x *py scripts/*sh scripts/*py scripts/access/*sh scripts/access/*py f5-ansible-demo/*sh *sh AWS*/*sh AWS*/*py

# for SCJ - DCD IP
#sed -i 's/10.1.1.6/10.192.75.181/g' /home/f5/scripts/*sh

# for SEA - DCD IP
#sed -i 's/10.1.1.6/10.11.150.16/g' /home/f5/scripts/*sh