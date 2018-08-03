#!/usr/bin/env bash
#
# File: setup_bigip.sh
#
# Author: vishal chawathe (v.chawathe@f5.com)
#
# Description:
# This script will generate data for SWG and access reports.
# please run this script where you have JAVA running in the path. For example sjcdev07 or seadev01 (shared dev servers)
# Alternatively have java installed on your mac workstations and you can run the script from there
#

CONFIGURATION_TYPE="all"  #Configuration can be all,swg or access
VIRTUAL_IP=10.144.8.65  #Add your virtual ip which you used to configure your BIGIP

#No need to modify this the below params unless you want to have custom swg data.
SWG_DATA_TRAFFIC_FILE=resources/swg_traffic_data.txt   #file from which the swg requests are made
SWG_PORT=3128							

if [ "$CONFIGURATION_TYPE" == "all" ] || [ "$CONFIGURATION_TYPE" == "access" ]
then
	echo "Generating Access Data"
	java -jar resources/SessionGen.jar --host $VIRTUAL_IP --sessions 57
fi


if [ "$CONFIGURATION_TYPE" == "all" ] || [ "$CONFIGURATION_TYPE" == "swg" ]
then
	echo "Generating SWG Data"
	while read line 
	do
	 	urlName=$line
	 	echo "Traffic generated for url: $urlName"
	 	curl -x $VIRTUAL_IP:$SWG_PORT $urlName
	 	echo "Sleeping 2 seconds"
	    sleep 2
	done < $SWG_DATA_TRAFFIC_FILE
fi
echo "Completed generating Data generation for Reports"
