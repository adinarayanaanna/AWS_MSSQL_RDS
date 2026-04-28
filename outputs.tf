# Root outputs expose the created VPC and RDS module details.
output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the created public subnets."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the created private subnets."
  value       = module.vpc.private_subnet_ids
}

output "rds_endpoint" {
  description = "Endpoint address for the SQL Server RDS instance."
  value       = module.rds.db_endpoint
}

output "rds_instance_id" {
  description = "ID of the SQL Server RDS instance."
  value       = module.rds.db_instance_id
}
