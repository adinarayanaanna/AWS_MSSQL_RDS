output "db_endpoint" {
  description = "RDS endpoint address for the SQL Server instance."
  value       = aws_db_instance.this.endpoint
}

output "db_instance_id" {
  description = "ID of the SQL Server DB instance."
  value       = aws_db_instance.this.id
}

output "db_security_group_id" {
  description = "Security group ID for the SQL Server DB instance."
  value       = aws_security_group.db.id
}
