# Terraform project: VPC + AWS RDS for MSSQL

This project creates a new AWS VPC and deploys a SQL Server Express RDS instance.
It is designed to use AWS Free Tier friendly defaults where possible.

## Structure

- `main.tf` — root module wiring the VPC and RDS modules
- `providers.tf` — AWS provider configuration
- `variables.tf` — root variables for region, VPC, and DB settings
- `outputs.tf` — outputs for VPC and RDS details
- `terraform.tfvars.example` — sample variable values
- `modules/vpc/` — VPC module with public and private subnets
- `modules/rds/` — RDS module for SQL Server Express

## Usage

1. Install Terraform.
2. Configure AWS credentials in your environment.
3. Copy the example variables file:
   ```powershell
   copy terraform.tfvars.example terraform.tfvars
   ```
4. Edit `terraform.tfvars` and set a strong `db_password`.
5. Initialize Terraform:
   ```powershell
   terraform init
   ```
6. Review the planned changes:
   ```powershell
   terraform plan
   ```
7. Apply the configuration:
   ```powershell
   terraform apply
   ```

## Navigation

- `README.md` — start here for an overview and usage notes.
- `providers.tf` — AWS provider setup and region configuration.
- `variables.tf` — change VPC, database, and networking defaults.
- `main.tf` — links the `vpc` and `rds` modules together.
- `modules/vpc/` — creates VPC, public/private subnets, and gateway.
- `modules/rds/` — creates the SQL Server RDS instance, subnet group, and security group.

## Notes

- The SQL Server instance uses `db.t3.micro` and `20 GB` storage, which are the smallest supported options for AWS Free Tier compatibility.
- `db_allowed_cidr` defaults to `0.0.0.0/0` in the example. For security, restrict this to your own IP range.
- The RDS instance is created as publicly accessible so it can be reached from your allowed CIDR.
