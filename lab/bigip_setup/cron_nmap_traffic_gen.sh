#!/bin/bash
/usr/bin/nmap -p 80 -script http-enum -T5 -Pn 10.1.10.70
/usr/bin/nmap -p 8088 -script http-enum -T5 -Pn 10.1.10.200
/usr/bin/nmap -p 8088 -script http-enum -T5 -Pn 10.1.10.201
/usr/bin/nmap -p 80 -script http-waf-detect -T4 -Pn 10.1.10.70
/usr/bin/nmap -p 8088 -script http-waf-detect -T4 -Pn 10.1.10.200
/usr/bin/nmap -p 8088 -script http-waf-detect -T4 -Pn 10.1.10.201
