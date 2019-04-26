#!/bin/bash
#set -x

newRPM="$1"
oldRPM="$2" #optional for initial install
# new RPM needs to be in uploaded in /home/admin
home="/home/admin"

if [ -f $home/$newRPM ]; then
    echo "Installing latest RPM: ${newRPM}"
    latestVersion=$(curl http://localhost:8105/shared/appsvcs/info)
    echo 'AS3 Info: '
    echo "$latestVersion"
    if rpm -Uv --force "$newRPM" ; then
        mount -o remount,rw /usr
        echo 'Updating restjavad props to point to new RPM'
        if [ -z "$oldRPM" ]; then
            oldRPM=$newRPM
        fi
        c=$(grep $oldRPM /var/config/rest/config/restjavad.properties.json | wc -l)
        if [[ $c == 1 ]]; then
            sed -i "s/$oldRPM/$newRPM/g" /var/config/rest/config/restjavad.properties.json
            rm -rf /usr/lib/dco/packages/f5-appsvcs/$oldRPM
            mv $home/$newRPM /usr/lib/dco/packages/f5-appsvcs/
        else
            sed -i "s#\"appMappingPollingTimeOutSeconds\" : 180#\"appMappingPollingTimeOutSeconds\" : 180,\"rpmFilePath\" : \"/usr/lib/dco/packages/f5-appsvcs/$newRPM\"#g" /var/config/rest/config/restjavad.properties.json
            mv $home/$newRPM /usr/lib/dco/packages/f5-appsvcs/
        fi
        mount -o remount,ro /usr
        bigstart restart restjavad &
        restartProc=$!
        wait $restartProc
        sleep 5
        bigstart restart restnoded &
        restartProc=$!
        wait $restartProc
        echo 'Finished restarting services'
    else
        'Failed to install latest RPM';
        exit 1;
    fi
fi