#!/bin/bash
# Provided by IRSOLS DevOps team 
# IRSOLS Inc @irsols 
# www.irsols.com / Your Cloud Native Edge
# MIT License. Attribution required 
# 
echo " Following are the list of Apps currently registered w/ default subscription ID"
az ad app list --query [*].[displayName,appId]

echo "Carefully review these Apps in AZ Portal and then delete unused/unwanted ones using"
echo "az ad app delete --id <App_Id>"

