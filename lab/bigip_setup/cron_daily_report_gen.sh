#!/bin/bash
cd /home/f5/bigip_setup2
count=`shuf -i 1-100 -n 1`;
/home/f5/bigip_setup2/generate_access_reports_mock_data.sh 10.1.1.6 BOS-vBIGIP01.termmarc.com $count
count=`shuf -i 1-100 -n 1`;
/home/f5/bigip_setup2/generate_access_reports_mock_data.sh 10.1.1.6 BOS-vBIGIP02.termmarc.com $count
cd /home/f5/bigip_setup
python rate-ht-sender.py --log-iq 10.1.10.6
