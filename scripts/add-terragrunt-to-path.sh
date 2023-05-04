# ---------------------------------------------------------------------------------------------------------------------
# THIS SCRIPT WILL ADD THE TERRAGRUNT BINARY TO PATH
# ---------------------------------------------------------------------------------------------------------------------

#!/usr/bin/env bash
set -euo pipefail


    cd download
    ls -al

    #check if terraform.zip exists unzip if it does
    if [ -f terraform.zip ]; then
        echo "terraform.zip exists"
        unzip terraform.zip
        rm terraform.zip
    fi

    sudo cp -a terraform /usr/local/bin

    chmod +x /usr/local/bin/terraform

    # Copy the file to /usr/local/bin so we don't have to specify the full path
    sudo cp -a terragrunt /usr/local/bin

    # Make the file executable
    chmod +x /usr/local/bin/terragrunt
    cd ..

    # Test if it works, by printing out the version of terragrunt, terraform, and az
    terragrunt --version
    terraform --version
    az --version 

