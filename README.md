# azureAcctSetups
## Description:

Collection of different tools to setup the Azure environment for use with Terraform automation and Infra as code 

### Important
After clonning check the version you're on using : 
git tag -ln

### Instructions
 Azure uses service principal concept .
 First run the `sp_create_config.sh`
 from directory using an app name as argument 
 This will create a source file `set_azvars_for_tf.txt` which will need to be manually source'd in the shell .
 \r
 Change to the directory for TF scripts and do tf init, plan etc
 Ths way TF will only be using the app credentials created using the Service Principal construct.
 
~                             
