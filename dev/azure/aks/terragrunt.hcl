locals {
  # Automatically load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

dependency "network" {
  config_path = "../network"
}

dependency "resource_group" {
  config_path = "../resource_group"
}

# Define where we are getting the Terraform module from
terraform {
  source = "git@github.com:Azure/terraform-azurerm-aks.git//?ref=master"
}

# Include terrgrunt.hcl files from all parent folders
include {
  path = find_in_parent_folders()
}

# Pass these vars as inputs to the module 
inputs = {
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  #  client_id                       = "your-service-principal-client-appid"
  #  client_secret                   = "your-service-principal-client-password"
  kubernetes_version              = "1.19.7"
  orchestrator_version            = "1.19.7"
  prefix                          = "dev"
  network_plugin                  = "azure"
  vnet_subnet_id                  = dependency.network.outputs.vnet_subnets[0]
  os_disk_size_gb                 = 50
  sku_tier                        = "Free" # defaults to Free
  enable_http_application_routing = true
  enable_azure_policy             = true
  enable_auto_scaling             = true
  agents_min_count                = 1
  agents_max_count                = 2
  agents_count                    = 2 # Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes.
  agents_pool_name                = "devnodepool"
  agents_availability_zones       = ["1", "2"]

  agents_labels = {
    "nodepool" : "devnodepool"
  }

  agents_tags = {
    "Agent" : "devnodepoolagent"
  }
  network_policy                 = "azure"
  net_profile_dns_service_ip     = "192.168.0.10"
  net_profile_docker_bridge_cidr = "170.10.0.1/16"
  net_profile_service_cidr       = "192.168.0.0/16"
}
