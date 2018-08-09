#!/bin/bash
# Uncomment set command below for code debuging bash
# set -x

home="/home/f5/scripts"

already=$(ps -ef | grep $0 | grep bash | grep -v grep | wc -l)
if [  $already -gt 3 ]; then
    echo "The script is already running $already time."
    exit 1
fi

sitelistener[1]="10.1.10.203"
sitelistener[2]="10.1.10.204"

widip[1]="site36.example.com A"
widip[2]="f5.udf.example.com A"
widip[3]="notthere.example.com A"
widip[4]="site40.example.com A"
widip[5]="site42.example.com A"
widip[6]="site38.example.com A"

# get length of the array
arraylength=${#sitelistener[@]}
arraylength2=${#widip[@]}

for (( i=1; i<${arraylength}+1; i++ ));
do
    if [ ! -z "${sitelistener[$i]}" ]; then
        # Only generat traffic on alive VIP
        ip=${sitelistener[$i]}
        timeout 1 bash -c "cat < /dev/null > /dev/udp/${ip:1:-1}/53"
        if [  $? == 0 ]; then
		    # Port 53 open
		    port=53
        else
            port=0
        fi

        if [[  $port == 53 ]]; then
            # Build dns target file and do dig
            for (( i=1; i<${arraylength2}+1; i++ ));
            do
                echo "Loop $k"
                echo ${widip[$i]} >> $home/dnstargets.txt
                wip=$(echo ${widip[$i]} | awk '{print $1}')
                dig @${sitelistener[$i]} $wip
            done
            echo -e "\n# site $i ${sitelistener[$i]} dnsperf"
            count=`shuf -i 1-100 -n 1`;
            conc=`shuf -i 1-10 -n 1`; 
            dnsperf -s ${sitelistener[$i]} -d $home/dnstargets.txt -c $conc -n $count
            
        else
                echo "SKIP ${sitelistener[$i]} not answering on port 53"
        fi
   fi
done

rm -f $home/dnstargets.txt