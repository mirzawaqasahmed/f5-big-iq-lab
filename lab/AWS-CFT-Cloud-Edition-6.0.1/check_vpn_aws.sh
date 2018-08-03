#!/bin/bash
# Uncomment set command below for code debuging bash
#set -x

aws ec2 describe-vpn-connections | grep -A 15 VgwTelemetry

exit 0
