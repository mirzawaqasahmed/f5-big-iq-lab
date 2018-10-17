apt-get -y update
apt-get -y install python-setuptools docker.io apache2-utils
docker run -d -p 80:80 --net=host --restart unless-stopped -e F5DEMO_APP=website -e F5DEMO_NODENAME='F5 AWS' -e F5DEMO_COLOR=ffd734 -e F5DEMO_NODENAME_SSL='F5 AWS (SSL)' -e F5DEMO_COLOR_SSL=a0bf37 f5devcentral/f5-demo-httpd