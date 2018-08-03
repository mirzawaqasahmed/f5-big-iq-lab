#!/usr/bin/env bash
#
# File: setup_bigip.sh
#
# Author: vishal chawathe (v.chawathe@f5.com)
#
# Description:
# This script will configure your BIGIP for basic Access enviornment. It will create access profiles for swg, access ,
# network access and portal accesss
#


#Configuration Type 

CONFIGURATION_TYPE="swg"   #Configuration can be all,swg,access
UPGRADE_CONFIGURATION="true" #This flag set to true will make sure your existing configuration is not lost and only neccessary configuration
                             #will up added.

# Network Configuration - Modify these variables for your specific BIGIP
BIGIQ_SELFIP=10.1.10.101           # BIG-IQ self ip for log publication.
HOSTNAME=vBIGIP03.termmarc.com   # Hostname of BIGIP mgmt
SELF_IP_ADDR=10.1.10.6           # Self-IP Address of you BIGIP
VIRTUAL_IP=10.1.10.250           # Virtual address for traffic for swg, access reports

DEFAULT_ROUTE=10.1.1.254           # Default Route. If not sure, contact your network administrator.

SELF_IP_MASK=24                     # Self-IP Address Mask
VLAN_INTERFACE=1.1                  # Active interface on BIGIP for internal VLAN
VLAN_TAGGED=tagged                # Is VLAN tagged or untagged (values: tagged/untagged)
VLAN_TAG=10                       # VLAN tag if VLAN is 'tagged'. Otherwise, no need to modify

DNS_SERVER=10.1.1.254 # You should modify this only if you are outside sjc dev lab. If outside sjc lab please check with you network administrator
NTP_SERVER=10.1.1.254 # No need to modify the NTP server. if outside sjc lab please check with you network administrator
SWG_PORT=3128  #No need to modify this



#you dont need to modify this unless you need to customize your policies

echo "Configuration type is $CONFIGURATION_TYPE"

echo "Upgrade configuration is set to $UPGRADE_CONFIGURATION"


SWG_POLICY_TAR_NAME=resources/profile-Common-swg_access_policy.conf.tar.gz  #SWG policy tar name  modify if using some other policy
SWG_POLICY_NAME=swg_access_policy #SWG policy name

SWG_PER_REQUEST_POLICY_TAR_NAME=resources/policy-Common-swg_demo_per_request_policy.conf.tar.gz #SWG per request policy modify if some other is required
SWG_PER_REQUEST_POLICY_NAME=swg_demo_per_request_policy # per request policy name


ACCESS_POLICY_TAR_NAME=resources/profile-Common-accessPolicy.conf.tar.gz #access profile name
ACCESS_POLICY_NAME=accessPolicy   #accessProfile1 name

SMALL_SAMPLE_POLICY_TAR_NAME=resources/profile-Common-smallpolicy.conf.tar.gz #small sample policy
SMALL_SAMPLE_POLICY_NAME=samplePolicy1  #name for the small sample policy


echo Verfying current configuration
ERROR=$(tmsh load sys config 2>&1 >/dev/null)
if [ "$ERROR" != "" ]; then
    echo "Please correct the following configuration errors before running this script:"
    echo "$ERROR"
    exit
fi

if [ "$UPGRADE_CONFIGURATION" == "false" ]; then
	echo "Cleaning the current configuration"
	tmsh load sys config default
	sleep 120
fi

echo Cleaning restjavad storage and restarting daemons
bash ./bigip_clean_restjavad.sh

echo Modifying hostname
tmsh modify sys global-settings { gui-setup disabled hostname $HOSTNAME }

echo Provisioning modules
tmsh modify sys provision apm { level nominal }
echo "Please wait for provisioning of apm to complete. This takes some time...Have patience"
sleep 120
tmsh modify sys provision ltm { level none }
echo "Please wait for provisioning of APM to complete. This takes some time...Have patience"
sleep 120
if [ "$CONFIGURATION_TYPE" == "all" ] || [ "$CONFIGURATION_TYPE" == "swg" ]
then
	tmsh modify sys provision swg { level nominal }
echo "Please wait for provisioning of swg to complete. This takes some time...Have patience"
sleep 120
fi
echo "Please wait for the provisioning to complete"
sleep 120
echo "Configuring VLAN/self-IP/Route"
if [[ $VLAN_TAGGED == "tagged" ]]; then
  VLAN_TAG_ATTR="tag $VLAN_TAG"
fi
tmsh create net vlan /Common/internal $VLAN_TAG_ATTR interfaces add {$VLAN_INTERFACE {$VLAN_TAGGED}}
tmsh create net self /Common/$SELF_IP_ADDR/$SELF_IP_MASK { address $SELF_IP_ADDR/$SELF_IP_MASK traffic-group /Common/traffic-group-local-only vlan /Common/internal allow-service add { default } }
tmsh create net route default { gw $DEFAULT_ROUTE network 0.0.0.0/0 }

echo "Configuring NTP server"
tmsh modify sys dns name-servers add { $DNS_SERVER } search add { olympus.f5net.com lab.fp.f5net.com fp.f5net.com f5net.com f5.com }
tmsh modify sys ntp servers add { $NTP_SERVER }

echo "Configuring Log Configuration"
tmsh create /ltm node /Common/remote_syslog_node { address $BIGIQ_SELFIP }
tmsh create /ltm pool /Common/remote_syslog_pool members add { /Common/remote_syslog_node:9999 { address $BIGIQ_SELFIP } }
tmsh create /sys log-config publisher /Common/remote_syslog_pub
tmsh create /sys log-config filter /Common/remote_apm_filter { level notice publisher /Common/remote_syslog_pub source accesscontrol }
tmsh create /sys log-config destination remote-high-speed-log /Common/remote_syslog-hsl { pool-name /Common/remote_syslog_pool }
tmsh create /sys log-config destination splunk /Common/remote_syslog_destination { forward-to /Common/remote_syslog-hsl }
tmsh modify /sys log-config publisher /Common/remote_syslog_pub add destinations add { remote_syslog_destination }
echo "Creating remote-logging log setting configuration"
tmsh create /apm log-setting remote-log-setting access add { remote-logging_access { publisher remote_syslog_pub } } url-filters add { remote_logging_swg { publisher remote_syslog_pub filter { log-allowed-url true } } } 
tmsh create /apm log-setting local-syslog-setting access add { local-syslog-setting_access { publisher sys-db-access-publisher}} url-filters add { local-syslog-setting_swg { publisher sys-db-access-publisher { log-allowed-url true}}}


echo "Creating tunnels for swg"
tmsh create /net tunnels tunnel /Common/swg_tunnel  profile tcp-forward 


echo "Creating dns-resolvers"
tmsh create /net dns-resolver /Common/dns-resolver-lab forward-zones add   { . { nameservers add { $DNS_SERVER:53  }} }route-domain /Common/0 

echo "Creating http profile"
tmsh create /ltm profile http /Common/http_swg {    app-service none    defaults-from /Common/http-explicit    explicit-proxy {  tunnel-name /Common/swg_tunnel default-connect-handling allow      dns-resolver /Common/dns-resolver-lab    }    proxy-type explicit}


echo "Creating access policies "
if [ "$CONFIGURATION_TYPE" == "all" ] || [ "$CONFIGURATION_TYPE" == "swg" ]
then
	ng_import -s $SWG_POLICY_TAR_NAME $SWG_POLICY_NAME 

	sleep 2

	ng_import -s $SWG_PER_REQUEST_POLICY_TAR_NAME $SWG_PER_REQUEST_POLICY_NAME 

	sleep 2

	tmsh modify /apm profile access $SWG_POLICY_NAME  log-settings replace-all-with { default-log-setting remote-log-setting }
fi

if [ "$CONFIGURATION_TYPE" == "all" ] || [ "$CONFIGURATION_TYPE" == "access" ]
then

	ng_import -s $ACCESS_POLICY_TAR_NAME $ACCESS_POLICY_NAME 

	sleep 2
	tmsh modify /apm profile access $ACCESS_POLICY_NAME   log-settings replace-all-with { default-log-setting remote-log-setting }
fi


if [ "$CONFIGURATION_TYPE" == "all" ] || [ "$CONFIGURATION_TYPE" == "swg" ]
then

	echo "Creating virtual server for swg policy"

	tmsh create /ltm virtual /Common/swg_virtual destination $VIRTUAL_IP:$SWG_PORT ip-protocol tcp per-flow-request-access-policy $SWG_PER_REQUEST_POLICY_NAME  profiles add { http_swg  $SWG_POLICY_NAME { } classification { context clientside }} policies add { _sys_CEC_video_policy {}} source-address-translation { type automap } source 0.0.0.0/0 
fi

if [ "$CONFIGURATION_TYPE" == "all" ] || [ "$CONFIGURATION_TYPE" == "access" ]
then
	echo "Creating virtual for access policy"
	tmsh create /ltm virtual /Common/access_virtual destination $VIRTUAL_IP:443 ip-protocol tcp   profiles add { http {}  $ACCESS_POLICY_NAME {} clientssl {  context clientside } } source-address-translation { type automap } source 0.0.0.0/0 
fi


echo "Saving config"
tmsh save sys config
sleep 5



echo "Changing file permissin on VERSION.LTM for VPE"
chmod 644 /VERSION.LTM

bigstart stop urldbmgrd urldb
tmsh modify sys url-db download-schedule urldb status false
bigstart start urldbmgrd urldb


  



