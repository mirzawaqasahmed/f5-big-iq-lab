#!/bin/bash
cd /home/f5
rm -rf AWS* bigip* f5-ansi* scripts* class1* Common* crontab* f5-big-iq-lab
#git clone https://github.com/f5devcentral/f5-big-iq-lab.git --branch master
git clone https://github.com/f5devcentral/f5-big-iq-lab.git --branch develop
mv /home/f5/f5-big-iq-lab/lab/* /home/f5
rm -rf /home/f5/f5-big-iq-lab
chmod +x *py scripts/*sh scripts/*py f5-ansible-demo/*sh *sh AWS*/*sh AWS*/*py