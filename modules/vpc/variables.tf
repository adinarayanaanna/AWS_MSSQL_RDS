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

variable "project_name" {
  description = "Project name used for tagging."
  type        = string
}

variable "environment" {
  description = "Deployment environment used for tagging."
  type        = string
}

locals {
  public_subnet_map  = zipmap([for idx in range(length(var.public_subnet_cidrs)) : idx], var.public_subnet_cidrs)
  private_subnet_map = zipmap([for idx in range(length(var.private_subnet_cidrs)) : idx], var.private_subnet_cidrs)

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
