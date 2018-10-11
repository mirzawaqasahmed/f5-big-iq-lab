#!/bin/bash
# Uncomment set command below for code debugging bash
#set -x
# Uncomment set command below for code debugging ansible
#DEBUG_arg="-vvvv"

function pause(){
   read -p "$*"
}

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

## Usage:
## ./cmd_bigiq_onboard.sh nopause sjc
## ./cmd_bigiq_onboard.sh pause sjc

if [ -z "$2" ]; then
  env="udf"
else
  #env="sjc"
  #env="sjc2"
  #env="sea"
  env=$2
fi

echo -e "Environement:${RED} $env ${NC}"

ip_cm1="$(cat inventory/group_vars/$env-bigiq-cm-01.yml| grep bigiq_onboard_server | awk '{print $2}')"
pwd_cm1="$(cat inventory/group_vars/$env-bigiq-cm-01.yml| grep bigiq_onboard_new_admin_password | awk '{print $2}')"
ip_dcd1="$(cat inventory/group_vars/$env-bigiq-dcd-01.yml| grep bigiq_onboard_server | awk '{print $2}')"
pwd_dcd1="$(cat inventory/group_vars/$env-bigiq-dcd-01.yml| grep bigiq_onboard_new_admin_password | awk '{print $2}')"

for ip in $ip_cm1 $ip_dcd1; do
  echo "Type $ip root password."
  ssh-copy-id root@$ip > /dev/null 2>&1
done

############### ONLY FOR PME LAB START
if [[  $env != "udf" ]]; then
  ############################# PART TO REMOVE IN PME SEATTLE LAB AS NO ACCESS TO BUILD SERVER
  ############## MANUALLY TRANSFER THE ISO FILE
  echo -e "\n${GREEN}Download iso from nibs.f5net.com${NC}"
  [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
  ## Cleanup
  rm -f *iso* cookie activeVolume status
  ## download iso file
  # Corporate user/password to download the latest iso
  echo -e "Corporate F5 username:"
  read f5user
  echo -e "Corporate F5 password:"
  read -s f5pass
  release="v6.1.0"
  curl "https://weblogin.f5net.com/sso/login.php?redir=https://nibs.f5net.com/build" -H "Connection: keep-alive" -H "Pragma: no-cache" -H "Cache-Control: no-cache" -H "Origin: https://weblogin.f5net.com" -H "Upgrade-Insecure-Requests: 1" -H "DNT: 1" -H "Content-Type: application/x-www-form-urlencoded" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" -H "Referer: https://weblogin.f5net.com/sso/login.php?msg=Invalid%20Credentials&redir=https://nibs.f5net.com/build" -H "Accept-Encoding: gzip, deflate, br" -H "Accept-Language: en-US,en;q=0.9,fr-FR;q=0.8,fr;q=0.7" --data "user=$f5user&pass=$f5pass&submit_form=Submit" --compressed -c ./cookie
  curl -b ./cookie -o - https://nibs.f5net.com/build/bigiq/$release/daily/current/ | grep BIG-IQ | grep 'iso"'  | awk '{print $6}' | cut -b 7-41 > iso.txt
  iso=$(cat iso.txt)
  curl -b ./cookie -o - https://nibs.f5net.com/build/bigiq/$release/daily/current/$iso > $iso
  curl -b ./cookie -o - https://nibs.f5net.com/build/bigiq/$release/daily/current/$iso.md5 > $iso.md5
  md5sum $iso > $iso.md5.verify
  DIFF=$(diff $iso.md5.verify $iso.md5) 
  if [[  "$DIFF" != "" ]]; then
      echo "The md5 is different."
      cat $iso.md5
      cat $iso.md5.verify
      exit 2;
  else
      echo "Iso is good"
      ls -lrt $iso*
  fi
  
  ############################# PART TO REMOVE IN PME SEATTLE LAB AS NO ACCESS TO BUILD SERVER

  if [ -f $iso ]; then
      # loop around the BIG-IQ CM/DCD
      for ip in $ip_cm1 $ip_dcd1; do
        # transfer iso image
        echo -e "\n${GREEN}Transfer iso on $ip ${NC}"
        [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
        ssh root@$ip rm -f /shared/images/*.iso
        scp $iso root@$ip:/shared/images/
        echo -e "\n${GREEN}Install on $ip ${NC}"
        [[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
        # check active volum and install
        ssh root@$ip tmsh show sys software status > activeVolume
        activeVolume=$(cat activeVolume | grep yes | awk '{print $1}')
        if [[  $activeVolume == "HD1.1" ]]; then
          ssh root@$ip tmsh delete sys software volume HD1.2
          ssh root@$ip tmsh modify sys db liveinstall.saveconfig value disable
          ssh root@$ip tmsh modify sys db liveinstall.moveconfig value disable
          ssh root@$ip tmsh install sys software image $iso volume HD1.2 create-volume reboot
        else
          ssh root@$ip tmsh delete sys software volume HD1.1
          ssh root@$ip tmsh modify sys db liveinstall.saveconfig value disable
          ssh root@$ip tmsh modify sys db liveinstall.moveconfig value disable
          ssh root@$ip tmsh install sys software image $iso volume HD1.1 create-volume reboot
        fi
        while [[ $status != "complete" ]] 
          do
              ssh root@$ip tmsh show sys software status > status
              status=$(cat status | grep no | awk '{print $6}')
              percentage=$(cat status | grep no | awk '{print $7 $8}')
              if [[ $status == "complete" ]]; then
                echo -e "install status =${GREEN} $status - $percentage ${NC}"
              else
                echo -e "install status =${RED} $status - $percentage ${NC}"
              fi
              sleep 30
          done
        done
  fi
fi
############### ONLY FOR PME LAB END

# wait 15 min
sleep 900

echo -e "\n${GREEN}Install ansible-galaxy module${NC}"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
ansible-galaxy install f5devcentral.bigiq_onboard --force

echo -e "\n${GREEN}Onboarding BIG-IQ CM and DCD${NC}"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
if [[  $env == "udf" ]]; then
  ansible-playbook -i inventory/$env-hosts bigiq_onboard.yml $DEBUG_arg
else
  ansible-playbook -i inventory/$env-hosts .bigiq_onboard_$env.yml $DEBUG_arg
fi

echo -e "\n${GREEN}Add DCD to BIG-IQ CM${NC}"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
# Add DCD to CM
curl https://s3.amazonaws.com/big-iq-quickstart-cf-templates-aws/6.0.1.1/scripts.tar.gz > scripts.tar.gz
rm -rf scripts 
tar --strip-components=1 -xPvzf scripts.tar.gz 2> /dev/null &

scp -rp scripts root@$ip_cm1:/root
ssh root@$ip_cm1 << EOF
  cd /root/scripts
  set-basic-auth on
  /usr/local/bin/python2.7 ./add-dcd.py --DCD_IP_ADDRESS $ip_dcd1 --DCD_USERNAME admin --DCD_PWD $pwd_dcd1
  sleep 5
  /usr/local/bin/python2.7 ./activate-dcd-services.py --DCD_IP_ADDRESS $ip_dcd1 --SERVICES asm access dos websafe ipsec afm
EOF

echo -e "\n${GREEN}Add & discover BIG-IPs to BIG-IQ CM${NC}"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
# Add devices
scp -rp bulkDiscovery.pl inventory/$env-bigip.csv root@$ip_cm1:/root
ssh root@$ip_cm1 << EOF
  cd /root
  perl ./bulkDiscovery.pl -c $env-bigip.csv -l -s -q admin:$pwd_cm1
EOF

echo -e "\n${GREEN}Create Applications${NC}"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
# Create apps
if [[  $env == "udf" ]]; then
  ansible-playbook -i notahost, create_default_apps.yml $DEBUG_arg
else
  ansible-playbook -i notahost, .create_default_apps_$env.yml $DEBUG_arg
fi