#!/bin/bash
# Uncomment set command below for code debuging bash
#set -x

AZURE_CLOUD="$(cat config.yml | grep AZURE_CLOUD | awk '{ print $2}')"
USE_TOKEN=$(grep USE_TOKEN ./config.yml | grep yes | wc -l)
USERNAME="$(cat config.yml | grep USERNAME | awk '{ print $2}')"
PASSWORD="$(cat config.yml | grep PASSWORD | awk '{ print $2}')"

if [ ! -f /usr/bin/az ]; then
  # Update sources list:
  AZ_REPO=$(lsb_release -cs)
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
      sudo tee /etc/apt/sources.list.d/azure-cli.list

  # Get the Microsoft signing key:
  curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

  # Install the CLI:
  apt-get update
  apt-get install apt-transport-https azure-cli
fi

az cloud set --name $AZURE_CLOUD

if [[ $USE_TOKEN == 1 ]]; then
  az login
else
  az login -u $USERNAME -p $PASSWORD
fi

az account list --all --output table
az account list-locations --output table

exit 0
