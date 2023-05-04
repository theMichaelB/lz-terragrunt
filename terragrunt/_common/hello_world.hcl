
terraform {
  source = "${dirname(find_in_parent_folders())}/../modules//stacks/hello_world"
}