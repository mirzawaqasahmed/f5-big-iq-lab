#!/bin/bash
cd /home/f5/bigip_setup2
count=`shuf -i 1-3 -n 1`;
/home/f5/bigip_setup2/generate_access_reports_data.sh accessmock 1.1.1.1 BOS-vBIGIP01.termmarc.com,BOS-vBIGIP02.termmarc.com 10.1.1.6 $count;
count=`shuf -i 1-3 -n 1`;
/home/f5/bigip_setup2/generate_access_reports_data.sh access 10.1.10.222 BOS-vBIGIP01.termmarc.com,BOS-vBIGIP02.termmarc.com 10.1.1.6 $count;
count=`shuf -i 1-5 -n 1`;
/home/f5/bigip_setup2/generate_access_reports_data.sh accesssessions 10.1.10.222 BOS-vBIGIP01.termmarc.com,BOS-vBIGIP02.termmarc.com 10.1.1.6 $count;
