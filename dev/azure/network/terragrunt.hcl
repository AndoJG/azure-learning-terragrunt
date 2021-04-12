locals {
  # Automatically load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

dependency "resource_group" {
  config_path = "../resource_group"
}

# Define where we are getting the Terraform module from
terraform {
  source = "git@github.com:Azure/terraform-azurerm-vnet.git//?ref=master"
}

# Include terrgrunt.hcl files from all parent folders
include {
  path = find_in_parent_folders()
}

# Pass these vars as inputs to the module 
inputs = {
  vnet_name           = "${local.env_vars.locals.env}_vnet"
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  subnet_names        = ["subnet-1", "subnet-2"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24"]
}
