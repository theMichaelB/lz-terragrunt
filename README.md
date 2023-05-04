# Terragrunt Landing Zones for Azure

The purpose of this repository is to create a simple to deploy Azure Landing Zones using principles of least privilege and DRY (don't repeat yourself)

### Presumptions

It is presumed that you have knowledge of [terraform](https://www.terraform.io) and [terragrunt](https://terragrunt.gruntwork.io) as well as infrastructure as code in general.

### Landing Zones

The basic premise of a landing zone is to create a solution that allows developers / users to have a broad access to Azure resources in a policy driven, contained environment. Typically this means using subscriptions as the unit of management. So that each team is given their own subscription, where they have elevated permissions to develop and experiment with solutions.

Landing Zones also require layers of authorisation. While development teams only require access to the subscription they are using. There needs to be elevated process running that manage processes outside of that subscription. For instance there needs to be a management subscription that centralised services for logging, dns, and other services. As well as a network subscription that provides network services to the landing zones.

## Deployment Stages

The fundamental principle behind landing zones is that the entire process is deployed via infrastructure as code. In order to follow the concept of least privilege a number of deployment stages are required.

**Stage 0**

This is code that is run from an Azure Global Admin account, that is solely responsible for deploying a virtual machine in a private vnet, with a vm to be used for terraform / terragrunt deployments.

The terraform state file from this stage is not preserved, since at this stage there is no infrastructure that it could be stored on. It is presumed that if there is any issue with deployed resources created in stage 0 they would simply be deleted and redeployed.

**Stage 1**

This vm will have a managed identity that has elevated permissions to create user groups, and have owner permissions across all subscriptions across all Landing Zones.

This stage is responsible for deploying resources in the management and networking subscriptions.

**Stage 2**

While this could be a separate stage, it is currently deployed as part of Stage 1

Stage 2 is responsible for creating the landing zone subscription, and then creating user groups, and assigning permissions and roles to those subscriptions. It is also responsible for deploying core infrastructure to those landing zone subscriptions, such as networking, key vaults, etc. As well as a vm and storage account for running Stage 3 deployments.

**Stage 3**

This stage runs under the context of the subscription owner and will be able to run deployments initiated by development teams.

## Layout

### Modules

The modules directory consists of two types of modules. Resources and Stacks.

Resources are Azure component modules, such as storage, networks and compute. These modules are intended to be generic resource modules that can be consumed by many systems.

Stacks are reusable collections of resources that contain more complex systems of components. Stacks have a broad set of variables to allow them to be configured and deployed multiple times in different configurations or across multiple landing zones.

### Terragrunt

The terragrunt directory has a _common folder and a stages directory.

The layout of these directories allows all deployments to remain DRY. To easily deploy slightly different infrastructure to each landing zone by only incorporating the differences in each landing zone's directory.

The _common folder contains all of the common inputs required for a deployment. this is then modified by the terragrunt.hcl in the working stage directory to make it specific to that particular deployment.

for instance on the path for the stage0 deployment `terragrunt/stage0/subscription/lz_mgmt`  the terragrunt.hcl file modifies the default `terragrunt/_common/stage1_deploy.hcl` parameters file to deploy a public IP address rather than a bastion service, and to specify the name of the resource group.

