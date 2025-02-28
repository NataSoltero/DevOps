locals {
  sufix = "${var.tags.project}-${var.tags.env}-${var.tags.region}"
}

data "aws_key_pair" "key" {
  key_name = "mykey"
}

# -------------------------------------------------------------------------------
# Calling vpc module to create the Network infrastructure
# -------------------------------------------------------------------------------

module "vpc" {
  source   = "../network"
  vpc_cidr = var.vpc_cidr
  region   = var.region
  subnets  = var.subnets
  tags     = var.tags
}

# -------------------------------------------------------------------------------
# Create EC2 instance with Linux or Ubuntu OS
# -------------------------------------------------------------------------------

resource "aws_instance" "project" {
  ami                    = var.tags.os == "Ubuntu" ? var.ec2_specs.ami-amazon-ubuntu : var.tags.os == "Linux" ? var.ec2_specs.ami-amazon-linux : var.tags.os == "Docker" ? var.ec2_specs.ami-amazon-linux : null
  instance_type          = var.ec2_specs.instance_type
  key_name               = data.aws_key_pair.key.key_name
  subnet_id              = module.vpc.public_subnet_id
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  user_data              = var.tags.os == "Ubuntu" ? file(var.paths.ubuntu) : var.tags.os == "Linux" ? file(var.paths.linux) : var.tags.os == "Docker" ? file(var.paths.docker) : null
  tags = {
    Name = var.tags.os == "Ubuntu" ? "ubuntu-instance-${local.sufix}" : var.tags.os == "Linux" ? "linux-instance-${local.sufix}" : var.tags.os == "Docker" ? "docker-instance-${local.sufix}" : null
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