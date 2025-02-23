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

# -------------------------------------------------------------------------------
# Internet gateway to connect the instance to public internet
# -------------------------------------------------------------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW-soltero-vpc-${local.sufix}"
  }
}

# -------------------------------------------------------------------------------
# Route table to direct network traffic 
# -------------------------------------------------------------------------------

resource "aws_route_table" "public_crt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-crt-${local.sufix}"
  }
}

# -------------------------------------------------------------------------------
# Rout table association to link route table to public subnet
# -------------------------------------------------------------------------------

resource "aws_route_table_association" "crta_public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_crt.id
}