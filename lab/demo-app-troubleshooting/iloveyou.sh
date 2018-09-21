#!/bin/bash
# Uncomment set command below for code debuging bash
# set -x

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

[ -z "$1" ] && url="site40.example.com"
url=$1
[ -z "$2" ] && client="213.187.116.138"
client=$1

echo -e "\nTarget:${RED} $url ${NC}- Source:${RED} $client ${NC}\n"

for ((n=0;n<5;n++));
do
        curl -k -s -m 10 -o /dev/null --header "X-Forwarded-For: $client" -A "Mozilla/5.0 (compatible; MSIE 7.01; Windows NT 5.0)" -w "iloveyou.exe\tstatus: %{http_code}\tbytes: %{size_download}\ttime: %{time_total} source ip: $client\n" https://$url/iloveyou.exe
        sleep 2;
done