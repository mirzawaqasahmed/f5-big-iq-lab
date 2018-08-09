#!/bin/bash
# Uncomment set command below for code debuging bash
# set -x

already=$(ps -ef | grep $0 | grep bash | grep -v grep | wc -l)
if [  $already -gt 3 ]; then
    echo "The script is already running $already time."
    exit 1
fi

sitelistener[1]="10.1.10.203"
sitelistener[2]="10.1.10.204"
sitelistener[3]="10.1.10.205"

# get length of the array
arraylength=${#sitelistener[@]}

for (( i=1; i<${arraylength}+1; i++ ));
do
    if [ ! -z "${sitelistener[$i]}" ]; then
        # Only generat traffic on alive VIP
        ip=${sitelistener[$i]}
        timeout 1 bash -c "cat < /dev/null > /dev/tcp/${ip:1:-1}/53"
        if [  $? == 0 ]; then
		    # Port 53 open
		    port=53
        else
            port=0
        fi

        if [[  $port == 53 ]]; then
            echo -e "\n# site $i ${sitelistener[$i]} dnsperf"
            count=`shuf -i 1-100 -n 1`;
            conc=`shuf -i 1-10 -n 1`; 
            /usr/bin/dnsperf -s $ip -d /home/f5/bigip_setup/dnstargets.txt -c $conc -n $count
            count=`shuf -i 1-100 -n 1`;
            conc=`shuf -i 1-10 -n 1`; 
            /usr/bin/dnsperf -s $ip -d /home/f5/bigip_setup/cachetarget.txt -c $conc -n $count
            count=`shuf -i 1-100 -n 1`;
            conc=`shuf -i 1-10 -n 1`; 
            /usr/bin/dnsperf -s $ip -d /home/f5/bigip_setup/ZRtargets.txt -c $conc -n $count

        else
                echo "SKIP ${sitelistener[$i]} not answering on port 53"
        fi
   fi
done
