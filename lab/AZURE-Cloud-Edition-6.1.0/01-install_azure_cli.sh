#!/bin/bash
# Uncomment set command below for code debuging bash
#set -x

USE_TOKEN=$(grep USE_TOKEN ./config.yml | grep yes | wc -l)
AZURE_CLOUD="$(cat config.yml | grep AZURE_CLOUD | awk '{ print $2}')"
SUBSCRIPTION_ID=$(grep SUBSCRIPTION_ID ./config.yml | awk '{ print $2}')
TENANT_ID=$(grep TENANT_ID ./config.yml | awk '{ print $2}')
CLIENT_ID=$(grep CLIENT_ID ./config.yml | awk '{ print $2}')
SERVICE_PRINCIPAL_SECRET=$(grep SERVICE_PRINCIPAL_SECRET ./config.yml | awk '{ print $2}')

if [ ! -f /usr/bin/az ]; then
  echo -e "\n${GREEN}Installation Azure CLI${NC}"
  # Update sources list:
  AZ_REPO=$(lsb_release -cs)
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
      sudo tee /etc/apt/sources.list.d/azure-cli.list

  # Get the Microsoft signing key:
  curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

  # Install the CLI:
  sudo apt-get update
  sudo apt-get install apt-transport-https azure-cli -y
fi

echo -e "\n${GREEN}Set Cloud Name${NC}"
az cloud set --name $AZURE_CLOUD

echo -e "\n${GREEN}Login${NC}"
if [[ $USE_TOKEN == 1 ]]; then
  az login
else
  az login --service-principal -u $CLIENT_ID --password $SERVICE_PRINCIPAL_SECRET --tenant $TENANT_ID --subscription $SUBSCRIPTION_ID
  az role assignment list --assignee $CLIENT_ID
fi

#az account show
echo -e "\n${GREEN}Account list${NC}"
az account list --all --output table

echo -e "\n${GREEN}Account Location${NC}"
az account list-locations --output table

exit 0
