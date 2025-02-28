# -------------------------------------------------------------------------------
# Calling the network module to deploy the VPC and subnets
# -------------------------------------------------------------------------------

module "instance" {
  source            = "./modules/compute"
  ingress_port_list = var.ingress_port_list
  sg_ingress_cidr   = var.sg_ingress_cidr
  ec2_specs         = var.ec2_specs
  subnets           = var.subnets
  region            = var.region
  vpc_cidr          = var.vpc_cidr
  tags              = var.tags
  paths             = var.paths
}
