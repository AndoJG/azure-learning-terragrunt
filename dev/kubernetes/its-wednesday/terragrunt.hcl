dependency "aks" {
  config_path = "../../azure/aks"
}

# Generate a kubconfig file in the local dir to be used with our provider
generate "kubeconfig" {
  path      = "kubeconfig"
  if_exists = "overwrite_terragrunt"
  contents  = dependency.aks.outputs.kube_config_raw
}

# Define where we are getting the Terraform module from
terraform {
  source = "git@github.com:breadwatcher/azure-learning-terraform.git//modules/kubernetes_its_wednesday?ref=main"
}

# Include terrgrunt.hcl files from all parent folders
include {
  path = find_in_parent_folders()
}
