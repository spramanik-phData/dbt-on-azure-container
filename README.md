# Overview

**Scenerio :** Client wants a custom solution using dbt-core where they are charged for the comute only for the duration the transformation pipeline is running.

**Possible solution :** Run dbt on a continer service

**POC Design :** 
- We will use Azure Container Registery to hold the custom image
- Deploy the image on Azure Conteiner Instances, easier to get started with. Though if we need high scalabilty we can go for Azure Kubernetes Service (AKS).
- The container will use the compute only while the models are running
- Use Azure funtion as a trigger to start the Azure Container Instances
- Azure function can be included in ADF pipeline make the solution end to end for loading and transforming the data
- Decouple the code and container config so that same cluster/ container can be used for multiple implementation. We will keep our code in a github repo and mount the same as a volumne in our container
- Store the credentials for snowflake in Azure Vault and fetch it during cointer init

# Implementation
## Installations:
- [Python 3.8](https://www.python.org/downloads/release/python-380/)
- [Docker](https://docs.docker.com/engine/install/)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

## Steps:
1. Initialize and develop a dbt project
2. Create a docker file
3. Build image from docker file
4. [Create azure container registery using Azure CLI](#create-azure-container-registry-acr)
5. [Push local docker image to ACR](#push-local-container-image-to-acr)
5. [Enable 'admin' for ACR & fetch credentials](#enable-admin-in-acr)
5. [Deploy to azure container instance using Azure CLI](#deploy-to-aci)

## Login to Azure
login to azure account via azure-cli
```
az login
```
This pops up a seperate web browser window that authenticates your identity, it is a good idea to have your account logged in beforehand.

## Create Azure Container Registry [ACR]

List Azure Locations
```
az account list-locations --query "sort_by([].{DisplayName:displayName, LocationName:name}, &DisplayName)" --output table
```

Create Resource Group
```
az group create --name rg_dbtOnAzure --location centralindia
```

Create ACR object
```
az acr create --resource-group rg_dbtOnAzure --name acrdbtonazure --sku Basic
```

Login to ACR object
```
az acr login --name acrdbtonazure
```

## Push local container image to ACR
Create local docker image
```
docker build . -t dbt-on-container
```

Fetch Azure Conteiner Registry login server name
```
az acr show --name acrdbtonazure --query loginServer --output table
```

Find the docker image you created using 
```
docker images
```

Tag the local image to ACR login server name
```
docker tag dbt-on-container acrdbtonazure.azurecr.io/dbt-on-azure-app:latest
```

Push the tagged image to ACR
```
docker push acrdbtonazure.azurecr.io/dbt-on-azure-app:latest
```

Validate the image is properly psuhed by listing the images in ACR
```
az acr repository list --name acrdbtonazure --output table
```

## Enable 'admin' in ACR
Before we move to Azure Container Instances (ACI), let's enable the admin role in ACR. We'll need the creds for container creation process.

Enable 'admin'
```
az acr update -n acrdbtonazure --admin-enabled true
```

Fetch credentials
```
az acr credential show -n acrdbtonazure
```
This will return two passwords, you can use any one of them during container instance creation


## Deploy to ACI
Create container
```
az container create --resource-group rg_dbtOnAzure --name dbt-on-container-app --image acrdbtonazure.azurecr.io/dbt-on-azure-app:latest --cpu 1 --memory 1 --registry-login-server acrdbtonazure.azurecr.io --ports 80 --gitrepo-url https://github.com/spramanik-phData/dbt-on-azure-container.git --gitrepo-mount-path /mnt/github --registry-username <username_value> --registry-password <password_value> --ip-address Public --dns-name-label dbt-on-container --restart-policy Never
```

This packs a lot of parameter, you can read about each [here](https://learn.microsoft.com/en-us/cli/azure/container?view=azure-cli-latest).

Some of them are specific to our design:
- **gitrepo-url :** This is used to input the git repor that you want to mount
- **gitrepo-mount-path :** This is used to tell where in the container file system you want to have the repo mounted
- **restart-policy :** This is very crucial to keep in mind. This property tell container if it need to restart once the inital run is complete or not, since the default value is 'Alaways' it is very important to change it to 'Never' else it defeats the entire purpose of our design.

You can read more about using git repo as a volume [here](https://learn.microsoft.com/en-us/azure/container-instances/container-instances-volume-gitrepo).

