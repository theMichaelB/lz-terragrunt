# ---------------------------------------------------------------------------------------------------------------------
# THIS SCRIPT DOWNLOADS AND INSTALLS TERRAGRUNT
#
# Required envirnoment variable:
# TERRAGRUNT_VERSION      - The version of terragrunt
# TERRAGRUNT_DOWNLOAD_SHA - The sha256sum of the downloaded file
# ---------------------------------------------------------------------------------------------------------------------

#!/usr/bin/env bash
set -euo pipefail

# check for parameter named 'cached'


    echo "Downloading terragrunt and terraform binaries"
    # Download the binary file and save it as 'terragrunt'
    ls -al 
    mkdir -p download
    cd download
    curl -SL "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64" --output terragrunt

    # Verify the sha256sum of the downloaded file
    echo "${TERRAGRUNT_DOWNLOAD_SHA} terragrunt" | sha256sum -c -



    curl -SL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip --output terraform.zip
