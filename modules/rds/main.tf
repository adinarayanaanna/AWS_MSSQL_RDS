locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# DB subnet group for the SQL Server instance.
resource "aws_db_subnet_group" "this" {
  name       = "terraform-sqlserver-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(local.common_tags, {
    Name = "terraform-sqlserver-subnet-group"
  })
}

# Security group allowing SQL Server traffic from the configured CIDR.
resource "aws_security_group" "db" {
  name        = "terraform-sqlserver-sg"
  description = "Allow SQL Server access from allowed CIDR range."
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "terraform-sqlserver-sg"
  })
}

# SQL Server Express database instance.
resource "aws_db_instance" "this" {
  identifier                 = "terraform-mssql-express"
  allocated_storage          = var.db_allocated_storage
  engine                     = var.db_engine
  instance_class             = var.db_instance_class
  username                   = var.db_username
  password                   = var.db_password
  db_subnet_group_name       = aws_db_subnet_group.this.name
  vpc_security_group_ids     = [aws_security_group.db.id]
  publicly_accessible        = var.db_publicly_accessible
  storage_encrypted          = true
  backup_retention_period    = 7
  auto_minor_version_upgrade = true
  skip_final_snapshot        = true
  deletion_protection        = false
  multi_az                   = false
  license_model              = "license-included"
  storage_type               = "gp2"
  port                       = 1433

  tags = merge(local.common_tags, {
    Name = "terraform-sqlserver-instance"
  })
}
