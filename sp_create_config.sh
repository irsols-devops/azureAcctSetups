#!/bin/bash
# Provided by IRSOLS DevOps team 
# IRSOLS Inc @irsols 
# www.irsols.com / Your Cloud Native Edge
# MIT License. Attribution required 
# 
if [ -z "$1" ]
   then
     echo
     echo " Please Specify an App name"
     echo " Usage : sp_create_config.sh \"App_Name_To_Use_With_ServicePrincipal\" "
     exit
 fi
echo " This tool will setup a Service Principal with Client Secret for TF"
#

#Note: If you're using the China, German or Government Azure Clouds - you'll need to first configure the Azure CLI to work with that Cloud. You can do this by running:
# Uncomment this for GovCloud accounts
# az cloud set --name AzureChinaCloud|AzureGermanCloud|AzureUSGovernment
#
#Firstly, login to the Azure CLI using:
# az login
# Once logged in - it's possible to list the Subscriptions associated with the account via:
# az account list
export current_time=$(date "+%Y.%m.%d-%H.%M.%S")
export defaultSubId=`az account list | grep -4 isDefault | grep -2 true | grep id | awk '{ print $2 }'| sed 's/\"//g
'| sed 's/,//g'`

echo "Default Subscription ID is: $defaultSubId"
echo "Creating the Service Principal and associated App Id, Passwd and Tokens"
echo " Will be stored in the same directory with suffix AppCredsDDTT.txt"
az account set --subscription="$defaultSubId"
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$defaultSubId" -n $1 > AppCreds$current_time.txt
