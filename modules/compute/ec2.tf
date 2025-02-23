locals {
  sufix = "${var.tags.project}-${var.tags.env}-${var.tags.region}"
}

data "aws_key_pair" "key" {
  key_name = "mykey"
}

module "vpc" {
  source   = "../network"
  vpc_cidr = var.vpc_cidr
  region   = var.region
  subnets  = var.subnets
  tags     = var.tags
}

# -------------------------------------------------------------------------------
# CREATE AN EC2 UBUNTU INSTANCE
# -------------------------------------------------------------------------------

resource "aws_instance" "ubuntu" {
  ami           = var.ec2_specs.ami
  instance_type = var.ec2_specs.instance_type
  key_name      = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [
    aws_security_group.sg_public_instance.id
  ]
  user_data = file("scripts/user_data.sh")
  tags = {
    Name = "ubuntu-${local.sufix}"
  }
}

# -------------------------------------------------------------------------------
# CREATE A SECURITY GROUP AND EGRESS/INGRESS RULES FOR THE EC2 INSTANCE
# -------------------------------------------------------------------------------

resource "aws_security_group" "sg_public_instance" {
  name        = "Public Instance SG"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "Public-Instance-SG-${local.sufix}"
  }

  dynamic "ingress" {
    for_each = var.ingress_port_list
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.sg_ingress_cidr]
    }
  }
}

resource "aws_vpc_security_group_egress_rule" "public_instance_egress" {
  security_group_id = aws_security_group.sg_public_instance.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}