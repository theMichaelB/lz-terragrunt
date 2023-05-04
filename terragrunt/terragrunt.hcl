# Generate an Azure provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
      terraform {
        required_version = ">= 0.13.9"
    }

EOF
}

