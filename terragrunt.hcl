locals {
  # import provider variables to pass to our provider generator
  provider_vars = read_terragrunt_config(find_in_parent_folders("provider.hcl"))

  provider_name = local.provider_vars.locals.provider_name
}

#Templatize the provider generator so it can be used for different providers
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "${local.provider_name}" {
  %{if "${local.provider_name}" == "azurerm"}
  features {}
  %{endif}
  %{if "${local.provider_name}" == "kubernetes"}
  config_path = "./kubeconfig"
  %{endif}
}
EOF
}

remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    key                  = "${path_relative_to_include()}.terraform.tfstate"
    resource_group_name  = "tfstate"
    storage_account_name = "agdevtfstate"
    container_name       = "grunttfstate"
  }
}