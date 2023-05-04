
module "hello_world" {
  source = "../../resources/hello_world"
}

output "hello_world" {
  value = module.hello_world.hello
}