# Terraform Project
---
### Table of contents
* [General info](#general-info)
* [Create Logic App](#create-logic-app)
* [Create Logic App Route Through API Gateway](#create-logic-app-route-through-api-gateway)
* [Logic App for connecting to storage account](#logic-app-for-connecting-to-storage-account)
* [App Service With Custom DNS for Blazor](#app-service-with-custom-dns-for-blazor)
* [Author](#author)
---
## General info
This repo holds some basic terraform templates I have created over time working with DevOps and Azure. These are fantastic when set up correctly in DevOps to deal with disaster recovery. You can easily change the variables to destroy and redeploy app services or logic apps in any region or subscription in Azure. I find that setting up logic apps is a very quick way to get an API set up in the cloud.

#### Information
All of the templates have a very common structure to them:
* backend.tf - (Holds connection information to an azure storage account needed for saving state files)
* be_data.tf - (back end information needed for deployment such as resource groups and objects in azure)
* main.tf - (sometimes used to switch between azure subscriptions)
* outputs.tf - (Information you would like to output on completion such as connection strings or identity information)
* variables.tf - (To hold needed information such as resource group names but also customizable information such as what you would like to name the logic app)

#### DevOps
I use DevOps CI/CD pipelines for all these terraform scripts. You will need an app registered in Azure and contributor permission given to the app for any subscription you wish to release to. Once set up you will then need to set up a service connection using the app information in DevOps. That service connection will be used when running the terraform steps in the CD pipeline.


## Create Logic App
This is a a fairly simple to understand flow. The steps involved are in the logicApp_setup.tf file. The logic app is created in azure using the name and resource group you have set in the variables file. The next step is to release a basic ARM template into the new logic app. This will initiate a basic api that will respond with a health check when the endpoint is hit.
The terraform script will then output the endpoints for the new api. 

## Create Logic App Route Through API Gateway
This one is a little more complex 

## Logic App for connecting to storage account
This one makes use of azures trusted connections. This means you can completely lock off a storage account and only allow requests that come from this logic app.

## App Service With Custom DNS for Blazor
This script follows a very specific process. 

## Author
Steven Dangerfield-Kerr <br />
Developer | Information Technology <br />
