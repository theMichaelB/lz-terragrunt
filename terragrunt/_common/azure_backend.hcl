
# create azure tfstate config

locals {
  # Automatically load environment-level variables
  global                     = read_terragrunt_config(find_in_parent_folders("global.hcl"))
  #stage                      = read_terragrunt_config(find_in_parent_folders("stage.hcl"))
  #lz                         = read_terragrunt_config(find_in_parent_folders("lz.hcl"))
  providers                  = read_terragrunt_config(find_in_parent_folders("providers.hcl"))
  #subscription_id            = local.lz.locals.subscription_id
  management_subscription_id = local.providers.locals.management.subscription_id
  core_subscription_id       = local.providers.locals.core.subscription_id
  corp_subscription_id       = local.global.locals.corp_core_subscription.subscription_id
  location                   = local.global.locals.location
  #use_msi                    = local.stage.locals.use_msi
  use_msi                    = false

  backend                        = read_terragrunt_config(find_in_parent_folders("backend_vars.hcl"))
  storage_account_name           = local.backend.locals.storage_account_name
  storage_account_resource_group = local.backend.locals.storage_account_resource_group
}




remote_state {
  backend = "azurerm"
  config = {
    use_msi              = "${local.use_msi}"
    subscription_id      = "${local.management_subscription_id}"
    key                  = "/${path_relative_to_include()}/terraform.tfstate"
    resource_group_name  = "${local.storage_account_resource_group}"
    storage_account_name = "${local.storage_account_name}"
    container_name       = "tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}