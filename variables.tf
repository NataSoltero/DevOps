variable "region" {
  description = "AWS region to deploy infra"
  type = string
}

variable "tags" {
  description = "Tags del proyecto"
  type        = map(string)
}

variable "virgina_cidr" {
  description = "CIDR Virginia"
  type        = string
}

variable "subnets" {
  description = "Subnets list"
  type        = list(string)
}