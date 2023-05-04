#!/bin/bash


TEMPLATE_DIR="scripts/templates/"
. ./.env

cat $TEMPLATE_DIR/global.hcl.tmpl | envsubst > "terragrunt/global.hcl"

cat ./terragrunt/global.hcl
export MANAGEMENT_SUBSCRIPTION_ID

cat $TEMPLATE_DIR/backend_vars.hcl.tmpl | envsubst > "terragrunt/backend_vars.hcl"

cat ./terragrunt/backend_vars.hcl

cp ./terragrunt/backend_vars.hcl ./artifacts/backend_vars.hcl
cp ./terragrunt/global.hcl ./artifacts/global.hcl
