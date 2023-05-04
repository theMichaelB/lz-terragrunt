#/bin/bash

# list azure management groups under named management group

#!/usr/bin/env bash
set -euo pipefail

# Login into Azure using a service principal

az login --service-principal --username "${ARM_CLIENT_ID}" --password "${ARM_CLIENT_SECRET}" --tenant "${ARM_TENANT_ID}"
mg=$(az account management-group show --name alz-landing-zones -e)

mg_list=$(echo $mg | jq -r '.children[].name')
providers="locals {"
# loop through management groups
for mg in $mg_list
do
    echo $mg
    sub_list=$(az account management-group subscription show-sub-under-mg --name $mg)
    echo $sub_list > /dev/null
    id=$(echo $sub_list | jq -r '.[].name')
    name=$(echo $sub_list | jq -r '.[].displayName')

    if [ -z "$name" ]
    then
        echo "No subscription found" > /dev/null
    else
        sub_list_count=$(echo $sub_list | jq -r '. | length')

        for (( i=0; i<$sub_list_count; i++ ))
        do
            id=$(echo $sub_list | jq -r ".[$i].name")
            name=$(echo $sub_list | jq -r ".[$i].displayName")
            echo $name
            PROVIDER="$name = { \nname = \"$name\"\n display_name = \"$name\"\n subscription_id = \"$id\"\n }"
            providers="$providers\n$PROVIDER"
        done
    fi
done


sub_list=$(az account management-group subscription show-sub-under-mg --name "alz-connectivity")
echo $sub_list > /dev/null
id=$(echo $sub_list | jq -r '.[].name')
name=$(echo $sub_list | jq -r '.[].displayName')

if [ -z "$name" ]
then
    echo "No subscription found" > /dev/null
else
    sub_list_count=$(echo $sub_list | jq -r '. | length')

    for (( i=0; i<$sub_list_count; i++ ))
    do
        id=$(echo $sub_list | jq -r ".[$i].name")
        name=$(echo $sub_list | jq -r ".[$i].displayName")
        echo $name
        PROVIDER="core = { \nname = \"core\"\n display_name = \"$name\"\n subscription_id = \"$id\"\n }"
        providers="$providers\n$PROVIDER"
    done
fi

sub_list=$(az account management-group subscription show-sub-under-mg --name "alz-management")
echo $sub_list > /dev/null
id=$(echo $sub_list | jq -r '.[].name')
name=$(echo $sub_list | jq -r '.[].displayName')

if [ -z "$name" ]
then
    echo "No subscription found" > /dev/null
else
    sub_list_count=$(echo $sub_list | jq -r '. | length')

    for (( i=0; i<$sub_list_count; i++ ))
    do
        id=$(echo $sub_list | jq -r ".[$i].name")
        name=$(echo $sub_list | jq -r ".[$i].displayName")
        echo $name
        PROVIDER="management = { \nname = \"management\"\n display_name = \"$name\"\n subscription_id = \"$id\"\n }"
        providers="$providers\n$PROVIDER"
    done
fi
echo -e "MANAGEMENT_SUBSCRIPTION_ID=$id" > ./.env

echo -e "$providers\n}" > ./terragrunt/providers.hcl

cat ./terragrunt/providers.hcl

mkdir -p ./artifacts/
cp ./terragrunt/providers.hcl ./artifacts/providers.hcl
cp ./.env ./artifacts/.env
