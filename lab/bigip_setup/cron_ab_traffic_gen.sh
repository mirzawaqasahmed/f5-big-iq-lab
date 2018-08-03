#!/bin/bash
count=`shuf -i 1-100 -n 1`;
conc=`shuf -i 1-10 -n 1`; 
ab -n $count -c $conc http://10.1.10.81/
count=`shuf -i 1-100 -n 1`;
conc=`shuf -i 1-10 -n 1`; 
ab -n $count -c $conc http://10.1.10.70/
count=`shuf -i 1-100 -n 1`;
conc=`shuf -i 1-10 -n 1`; 
ab -n $count -c $conc http://10.1.10.200/
count=`shuf -i 1-100 -n 1`;
conc=`shuf -i 1-10 -n 1`; 
ab -n $count -c $conc http://10.1.10.201/
