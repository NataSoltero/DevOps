variable "ingress_port_list" {
  description = "Ingress port list"
  type        = list(number)
}

variable "sg_ingress_cidr" {
  description = "CIDR for security group ingress"
  type        = string
}

variable "tags" {
  description = "Tags del proyecto"
  type        = map(string)
}

variable "ec2_specs" {
  description = "EC2 instance specifications"
  type        = map(string)
}

variable "region" {
  description = "AWS region to deploy infra"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "subnets" {
  description = "Subnets list"
  type        = list(string)
}