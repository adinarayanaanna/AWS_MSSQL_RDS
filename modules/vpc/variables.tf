variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
}

locals {
  public_subnet_map  = zipmap([for idx in range(length(var.public_subnet_cidrs)) : idx], var.public_subnet_cidrs)
  private_subnet_map = zipmap([for idx in range(length(var.private_subnet_cidrs)) : idx], var.private_subnet_cidrs)
}
