include "root" {
  path = find_in_parent_folders()
}


include "backend" {
  path = "${dirname(find_in_parent_folders())}/_common/azure_backend.hcl"
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_common/hello_world.hcl"
}


include "provider" {
  path = "${dirname(find_in_parent_folders())}/_common/all_providers.hcl"
}