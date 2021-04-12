locals {
  # Automatically load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

# Define where we are getting the Terraform module from
terraform {
  source = "git@github.com:breadwatcher/azure-learning-terraform.git//modules/azurerm_resource_group?ref=main"
}

# Include terrgrunt.hcl files from all parent folders
include {
  path = find_in_parent_folders()
}

# Pass these vars as inputs to the module 
inputs = {
  name     = "${local.env_vars.locals.env}_rg"
  location = local.env_vars.locals.location
}
