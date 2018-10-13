## =>>>>>>>>>>>>>>>>>>>>>>>>> to be replace with Ansible Role.
# Add DCD to CM
echo -e "\n${GREEN}Add DCD to BIG-IQ CM${NC}"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"

curl https://s3.amazonaws.com/big-iq-quickstart-cf-templates-aws/6.0.1.1/scripts.tar.gz > scripts.tar.gz
rm -rf scripts 
tar --strip-components=1 -xPvzf scripts.tar.gz 2> /dev/null &

for ip in $ip_cm1 $ip_dcd1; do
  echo "\nSet set-basic-auth on $ip"
  ssh root@$ip set-basic-auth on
done

echo "\nAdd DCD to BIG-IQ CM"
scp -rp scripts root@$ip_cm1:/root
ssh root@$ip_cm1 << EOF
  cd /root/scripts
  /usr/local/bin/python2.7 ./add-dcd.py --DCD_IP_ADDRESS $ip_dcd1 --DCD_USERNAME admin --DCD_PWD $pwd_dcd1
  sleep 5
  /usr/local/bin/python2.7 ./activate-dcd-services.py --DCD_IP_ADDRESS $ip_dcd1 --SERVICES asm access dos websafe ipsec afm
EOF

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

echo -e "\n${GREEN}Add & discover BIG-IPs to BIG-IQ CM${NC}"
[[ $1 != "nopause" ]] && pause "Press [Enter] key to continue... CTRL+C to Cancel"
# Add devices
### NEED TO ADD ENABLE STAT COLLECTION IN THE SCRIPT
scp -rp bulkDiscovery.pl inventory/$env-bigip.csv root@$ip_cm1:/root
ssh root@$ip_cm1 << EOF
  cd /root
  perl ./bulkDiscovery.pl -c $env-bigip.csv -l -s -q admin:$pwd_cm1
EOF

echo -e "\n${BLUE}TIME:: $(date +"%H:%M")${NC}"

## =>>>>>>>>>>>>>>>>>>>>>>>>> to be replace with Ansible Role.