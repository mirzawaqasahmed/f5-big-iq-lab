#!/bin/bash

##### Install Artiom's awesome Demo App #####
# install Docker
apt-get -y install docker.io python-setuptools apache2-utils
# Spin up Docker Instances

# Hackazon for AS3 with WAF:
docker run --restart=unless-stopped --name=hackazon -d -p 80:80 mutzel/all-in-one-hackazon:postinstall supervisord -n
# F5-Hello-World for HTTP Sites:
docker run --restart=unless-stopped --name=f5-hello-world-blue -dit -p 8081:8080 -e NODE='Blue' f5devcentral/f5-hello-world
docker run --restart=unless-stopped --name=f5-hello-world-green -dit -p 8082:8080 -e NODE='Green' f5devcentral/f5-hello-world
# DVWA for f5.http iApp with WAF:
docker run --restart=unless-stopped --name=dvwa -d -p 8080:80 infoslack/dvwa
# ASM Policy Validator:
docker run --restart=unless-stopped --name=app-sec -dit -p 445:8443 artioml/f5-app-sec
