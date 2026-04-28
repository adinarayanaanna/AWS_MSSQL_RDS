# Root module wiring the VPC and RDS modules together for a new AWS deployment.
# Values are passed from root-level variables defined in `variables.tf`.

module "vpc" {
  source               = "./modules/vpc"

  # These values come from the root variable definitions in variables.tf:
  # - vpc_cidr
  # - public_subnet_cidrs
  # - private_subnet_cidrs
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  # Tagging values from variables.tf:
  # - project_name
  # - environment
  project_name         = var.project_name
  environment          = var.environment
}

module "rds" {
  source                 = "./modules/rds"

  # These values are outputs from the VPC module:
  # - module.vpc.vpc_id is the VPC created by the vpc module
  # - module.vpc.private_subnet_ids are the private subnet IDs created by the vpc module
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.vpc.private_subnet_ids

  # Shared tagging values from variables.tf:
  project_name           = var.project_name
  environment            = var.environment

  # These values come from root-level variables in variables.tf:
  db_instance_class      = var.db_instance_class
  db_allocated_storage   = var.db_allocated_storage
  db_engine              = var.db_engine
  db_username            = var.db_username
  db_password            = var.db_password
  db_publicly_accessible = var.db_publicly_accessible
  allowed_cidr           = var.db_allowed_cidr
}
