#!/bin/bash
# Provided by IRSOLS DevOps team
# IRSOLS Inc @irsols
# www.irsols.com / Your Cloud Native Edge
# MIT License. Attribution required
# References:
# Azure CLI: https://docs.microsoft.com/en-us/cli/azure/ad?view=azure-cli-latest
# AZ Service Principal : https://docs.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals
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
#Login to the Azure CLI using:
# az login
# Once logged in - get list of all Subscriptions associated with the account using:
# az account list
export current_time=$(date "+%Y.%m.%d-%H.%M.%S")
export appcredsfile="AppCreds$current_time.txt"
export defaultSubId=`az account list | grep -4 isDefault | grep -2 true | grep id | awk '{ print $2 }'| sed 's/\"//g
'| sed 's/,//g'`

echo "Default Subscription ID is: $defaultSubId"
echo "Creating the Service Principal and associated App Id, Passwd and Tokens"
echo " Will be stored in the same directory with suffix AppCredsDDTT.txt"
az account set --subscription="$defaultSubId"
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$defaultSubId" -n $1 > $appcredsfile

# At this point the application exists in Azure Active Directory
# we can now use it to modify  resources in the Subscription by setting following env variables
# These will be ephemeral in the command window which is preferred
# ** not recommended to set in the TF files.

#export ARM_SUBSCRIPTION_ID="$defaultSubId"
#export ARM_CLIENT_ID="<appId>"
#export ARM_CLIENT_SECRET="<password>"
#export ARM_TENANT_ID="<tenant>"
export clientID=`grep appId $appcredsfile        | awk '{print $2}'| sed s/\"//g | sed s/,//g`
export clientSecret=`grep password $appcredsfile | awk '{print $2}'| sed s/\"//g | sed s/,//g`
export tenantId=`grep tenant $appcredsfile       | awk '{print $2}'| sed s/\"//g | sed s/,//g`


echo "export ARM_SUBSCRIPTION_ID=\"$defaultSubId\"" > set_azvars_for_tf.txt
echo "export ARM_CLIENT_ID=$clientID" >> set_azvars_for_tf.txt
echo "export ARM_CLIENT_SECRET=$clientSecret" >> set_azvars_for_tf.txt
echo "export ARM_TENANT_ID=$tenantId" >> set_azvars_for_tf.txt

echo "Final manual step is to execute:"
echo "source ./set_azvars_for_tf.txt" 
