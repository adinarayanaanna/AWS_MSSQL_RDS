# Root module wiring the VPC and RDS modules together for a new AWS deployment.

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  project_name         = var.project_name
  environment          = var.environment
}

module "rds" {
  source                 = "./modules/rds"
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.vpc.private_subnet_ids
  project_name           = var.project_name
  environment            = var.environment
  db_instance_class      = var.db_instance_class
  db_allocated_storage   = var.db_allocated_storage
  db_engine              = var.db_engine
  db_username            = var.db_username
  db_password            = var.db_password
  db_publicly_accessible = var.db_publicly_accessible
  allowed_cidr           = var.db_allowed_cidr
}
