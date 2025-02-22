# -------------------------------------------------------------------------------
# Calling the network module to deploy the VPC and subnets
# -------------------------------------------------------------------------------

module "vpc" {
  source = "./modules/network"
  virgina_cidr = var.virgina_cidr
  region = var.region
  subnets = var.subnets
  tags = var.tags
}