#!/bin/bash
count=`shuf -i 1-100 -n 1`;
conc=`shuf -i 1-10 -n 1`; 
/usr/bin/dnsperf -s 10.1.10.203 -d /home/f5/bigip_setup/dnstargets.txt -c $conc -n $count
#ab -n $count -c $conc http://10.1.10.81/
count=`shuf -i 1-100 -n 1`;
conc=`shuf -i 1-10 -n 1`; 
/usr/bin/dnsperf -s 10.1.10.203 -d /home/f5/bigip_setup/cachetarget.txt -c $conc -n $count
count=`shuf -i 1-100 -n 1`;
conc=`shuf -i 1-10 -n 1`; 
/usr/bin/dnsperf -s 10.1.10.203 -d /home/f5/bigip_setup/ZRtargets.txt -c $conc -n $count
