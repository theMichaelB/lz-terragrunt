


# Generate an Azure provider block
generate "provider" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<EOF

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.28.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
EOF
}