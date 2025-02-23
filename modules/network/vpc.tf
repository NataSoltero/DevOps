locals {
  sufix = "${var.tags.project}-${var.tags.env}-${var.tags.region}"
}

# -------------------------------------------------------------------------------
# CREATE A VPC
# -------------------------------------------------------------------------------

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "soltero-vpc-${local.sufix}"
  }
}

# -------------------------------------------------------------------------------
# CREATE A PUBLIC AND PRIVATE SUBNET
# -------------------------------------------------------------------------------

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnets[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet-${local.sufix}"
  }
}

#resource "aws_subnet" "private_subnet" {
#vpc_id     = aws_vpc.main.id
#cidr_block = var.subnets[1]
#tags = {
#Name = "private_subnet-${local.sufix}"
#}
#depends_on = [aws_subnet.public_subnet]
#}