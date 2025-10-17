module "acr" {
  source              = "./modules/container-registry"
  acr_name            = "testacr"
  resource_group_name   = var.resource_group_name
  allowed_ip_ranges =  ["1.2.3.0/24", "5.6.7.0/26"]
}
