# Root-level variables control region, networking, and database settings.
variable "aws_region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the new VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "db_instance_class" {
  description = "AWS RDS instance class for the SQL Server database."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Storage allocated for the SQL Server database in GB."
  type        = number
  default     = 20
}

variable "db_engine" {
  description = "RDS engine for the database."
  type        = string
  default     = "sqlserver-ex"
}

variable "project_name" {
  description = "Friendly name for tagging and resource identification."
  type        = string
  default     = "aws-mssql-rds"
}

variable "environment" {
  description = "Deployment environment used in tags."
  type        = string
  default     = "dev"
}

variable "db_username" {
  description = "Master username for the SQL Server database."
  type        = string
  default     = "sqladmin"
}

variable "db_password" {
  description = "Master password for the SQL Server database."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8 && length(var.db_password) <= 128 && length(regexall("[@/\\\" ]", var.db_password)) == 0
    error_message = "The password must be 8-128 characters and must not contain '/', '@', '\"', or space."
  }
}

variable "db_publicly_accessible" {
  description = "Whether the RDS instance should be publicly accessible."
  type        = bool
  default     = false
}

variable "db_allowed_cidr" {
  description = "CIDR range allowed to access the SQL Server port (1433)."
  type        = string
  default     = "0.0.0.0/0"

  validation {
    condition     = can(cidrhost(var.db_allowed_cidr, 1))
    error_message = "db_allowed_cidr must be a valid CIDR block."
  }
}
