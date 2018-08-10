#!/bin/bash
# Uncomment set command below for code debuging bash
# set -x

home="/home/f5/scripts"

already2=$(ps -ef | grep $0 | grep bash | grep -v grep | wc -l)
if [  $already2 -gt 1 ]; then
    echo "The script is already running $already2 time."
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
widip[7]="site36.example.com A"
widip[8]="www.abc.com CNAME"
widip[9]="www.google.com MX"
widip[10]="www.yahoo.com TXT"

# get length of the array
arraylength=${#sitelistener[@]}
arraylength2=${#widip[@]}

for (( i=1; i<${arraylength}+1; i++ ));
do
    if [ ! -z "${sitelistener[$i]}" ]; then
        # test of listener is responding
        dig @${sitelistener[$i]}
        if [  $? == 0 ]; then
             # Build dns target file and do dig
            for (( j=1; j<${arraylength2}+1; j++ ));
            do
                echo -e "\n# site $i ${sitelistener[$i]} ${widip[$j]} dnstargets.txt"
                echo ${widip[$j]} >> $home/dnstargets.txt
                wip=$(echo ${widip[$j]} | awk '{print $1}')
                dig @${sitelistener[$i]} $wip
            done
            echo -e "\n# site $i ${sitelistener[$i]} dnsperf"
            count=`shuf -i 1-100 -n 1`;
            conc=`shuf -i 1-10 -n 1`; 
            dnsperf -s ${sitelistener[$i]} -d $home/dnstargets.txt -c $conc -n $count
        else
            echo "SKIP ${sitelistener[$i]} - not answering on port 53"
        fi
   fi
done

rm -f $home/dnstargets.txt