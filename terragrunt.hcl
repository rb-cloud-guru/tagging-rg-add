
#backend
remote_state {
    backend = "azurerm"
    config = {
        resource_group_name = "tfstorage"
        storage_account_name = "terraformrocks"
        container_name = "hamza"
        key = "${path_relative_to_include()}/terraform.tfstate"
    }
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
  }
}

#var sthg like tfvars
inputs = {
    location = "eastus"
    mandatory_tag_keys = [
    "Application",
    "CostCenter",
    "Environment",
    "ManagedBy",
    "Owner",
    "Support"
  ]
    #mandatory_tag_value = "TBC"
    policy_definition_category = "custom"
    mgmt_name = "MadeFromMorocco"
}
 

