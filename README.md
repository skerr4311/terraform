# Terraform Project
---
### Table of contents
* [General info](#general-info)
* [Create Logic App](#create-logic-app)
* [Create Logic App Route Through API Gateway](#create-logic-app-route-through-api-gateway)
* [Logic App for connecting to storage account](#logic-app-for-connecting-to-storage-account)
* [App Service With Custom DNS for Blazor](#app-service-with-custom-dns-for-blazor)
---
## General info
This repo holds some basic terraform templates I have created over time working with DevOps and Azure. These are fantastic when set up correctly in DevOps to deal with disaster recovery. You can easily change the variables to destroy and redeploy app services or logic apps in any region or subscription in Azure. I find that setting up logic apps is a very quick way to get an API set up in the cloud.

#### Information
All of the templates have a very common structure to them:
* backend.tf - (Holds connection information to an azure storage account needed for saving state files)
* be_data.tf - (back-end information needed for deployment such as resource groups and objects in azure)
* main.tf - (sometimes used to switch between azure subscriptions)
* outputs.tf - (Information you would like to output on completion such as connection strings or identity information)
* variables.tf - (To hold needed information such as resource group names but also customizable information such as what you would like to name the logic app)

#### Running Localy
I run these on VS Code. You will need the following:
* Azure Terraform - extension installed on VSCode.
* HashiCorp Terraform - extension installed on VSCode.
* Terraform - extension installed on VSCode.
* Azure CLI Tools - extension installed on VSCode.
* Terraform installed on your device https://learn.hashicorp.com/tutorials/terraform/install-cli
* Azure CLI installed on your device https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
* You will need contributer or higer permissions on any subscription you wish to deploy to.

Start by running:
```
az login
```
in the terminal and go through the login process.


#### DevOps
I use DevOps CI/CD pipelines for all these terraform scripts. You will need an app registered in Azure and contributor permission given to the app for any subscription you wish to release to. Once set up you will then need to set up a service connection using the app information in DevOps. That service connection will be used when running the terraform steps in the CD pipeline.


## Create Logic App
This is a a fairly simple to understand flow. The steps involved are in the logicApp_setup.tf file. The logic app is created in azure using the name and resource group you have set in the variables file. The next step is to release a basic ARM template into the new logic app. This will initiate a basic api that will respond with a health check when the endpoint is hit.
The terraform script will then output the endpoints for the new api. 

## Create Logic App Route Through API Gateway
This one is a little more complex. It starts with the same steps above, creating a logic app and setting up a basic api. 
Once the above steps are completed the apim_apiSetup.tf file kicks in an completes the following:
* Sets up a backend connection using information defined in the variables file and from the created logic app
* Builds the connection settings for the api
* The creates and stores sas connection information to connect with the logic app
* Sets up backend policies in api management
* Set up the api operation responses
* Sets up the api operation policy (checks tokens sent to the endpoint and verifies them before allowing traffic through to the logic app)
* Set up the api schema defined in schemaTemplate

## Logic App for connecting to storage account
This one makes use of azures trusted connections. This means you can completely lock off a storage account and only allow requests that come from this logic app.
For this to work the executer of this script will need to have owner privileges over the storage account. The role assignment can be found at the last step of logic_app.tf and can be applied to any of the scripts here.

## App Service With Custom DNS for Blazor
This script follows a very specific process.
* AppService_setup.tf is run and the app service is created in azure.
* Using the main.tf file the script switches subscriptions to the dns subscription. (if your DNS is located in a different subscription)
* DSN_setup.tf starts
* A new DNS entry is created using the custom dns name assigned in the variables file.
* A new TXT record is created to quickly verify ownership of the dns entry.
* Swich back to the app service connection.
* The custom name is added to the app service.
* An app managed cert is created for the app service.
* The cert is then bound to the custom url.

