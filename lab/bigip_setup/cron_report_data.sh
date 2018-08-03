#!/bin/bash
cd /home/f5/bigip_setup
count=`shuf -i 1-150 -n 1`;
/home/f5/bigip_setup/generate_data.sh 10.1.10.222 access $count
#count=`shuf -i 1-150 -n 1`;
#/home/f5/bigip_setup/generate_data.sh 10.1.10.81 all $count
