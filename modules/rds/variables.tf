variable "vpc_id" {
  description = "VPC ID where the DB instance will be deployed."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the DB subnet group."
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

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated storage in gigabytes."
  type        = number
}

variable "db_engine" {
  description = "Database engine identifier."
  type        = string
}

variable "db_username" {
  description = "Master username for the DB instance."
  type        = string
}

variable "db_password" {
  description = "Master password for the DB instance."
  type        = string
  sensitive   = true
}

variable "db_publicly_accessible" {
  description = "Whether the DB should be publicly accessible."
  type        = bool
}

variable "allowed_cidr" {
  description = "CIDR block allowed to connect to the DB instance."
  type        = string
}
