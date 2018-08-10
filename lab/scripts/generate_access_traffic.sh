#!/bin/bash
# Uncomment set command below for code debuging bash
# set -x

home="/home/f5/scripts"
dcdip="10.1.1.6"
#dcdip="10.192.75.181" # SJC
#dcdip="10.11.150.16" # SEA

already1=$(ps -ef | grep $0 | grep bash | grep -v grep | wc -l)
if [  $already1 -gt 1 ]; then
    echo "The script is already running $already1 time."
    exit 1
fi

cd $home/access

count=`shuf -i 1-3 -n 1`;
./generate_access_reports_data.sh accessmock 1.1.1.1 BOS-vBIGIP01.termmarc.com,BOS-vBIGIP02.termmarc.com $dcdip $count;
count=`shuf -i 1-3 -n 1`;
./generate_access_reports_data.sh access 10.1.10.222 BOS-vBIGIP01.termmarc.com,BOS-vBIGIP02.termmarc.com $dcdip $count;
count=`shuf -i 1-5 -n 1`;
./generate_access_reports_data.sh accesssessions 10.1.10.222 BOS-vBIGIP01.termmarc.com,BOS-vBIGIP02.termmarc.com $dcdip $count;

count=`shuf -i 1-100 -n 1`;
./generate_access_reports_mock_data.sh $dcdip BOS-vBIGIP01.termmarc.com $count
count=`shuf -i 1-100 -n 1`;
./generate_access_reports_mock_data.sh $dcdip BOS-vBIGIP02.termmarc.com $count
cd /home/f5/bigip_setup
./rate-ht-sender.py --log-iq $dcdip

count=`shuf -i 1-150 -n 1`;
./generate_data.sh 10.1.10.222 access $count
#count=`shuf -i 1-150 -n 1`;
./generate_data.sh 10.1.10.222 all $count

