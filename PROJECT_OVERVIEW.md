# Project Overview: AWS VPC + SQL Server RDS with Terraform

## Purpose

This Terraform project creates a new AWS Virtual Private Cloud (VPC) and deploys an AWS RDS instance running SQL Server Express. It is built to be beginner-friendly and to use AWS Free Tier-compatible defaults where possible.

## Architecture

The project uses a root module plus two child modules:

- `modules/vpc/` — builds the networking layer:
  - VPC
  - public subnets
  - private subnets
  - internet gateway
  - public route table and associations
- `modules/rds/` — builds the database layer:
  - DB subnet group
  - security group for SQL Server port 1433
  - SQL Server Express RDS instance

The root module in `main.tf` wires these modules together:
- The VPC module creates the network and exposes VPC/subnet IDs.
- The RDS module receives VPC ID and private subnet IDs and deploys the database inside them.

## File-by-file explanation

### `providers.tf`
- Defines the Terraform version requirement.
- Configures the `aws` provider.
- Sets the AWS region using `var.aws_region`.

### `variables.tf`
- Declares root-level variables for the deployment.
- Default values are provided for a simple starting setup.
- Variables include:
  - `aws_region` — where resources are created.
  - `vpc_cidr` — VPC CIDR block.
  - `public_subnet_cidrs` — public subnet ranges.
  - `private_subnet_cidrs` — private subnet ranges.
  - `db_instance_class` — smallest supported SQL Server instance type.
  - `db_allocated_storage` — size in GB.
  - `db_engine` — `sqlserver-ex` for SQL Server Express.
  - `db_name`, `db_username`, `db_password` — DB credentials.
  - `db_publicly_accessible` — whether RDS is reachable from the internet.
  - `db_allowed_cidr` — CIDR allowed to connect to the DB.

### `main.tf`
- Calls the `vpc` module and the `rds` module.
- Passes the VPC module outputs into the RDS module.
- Uses `module.vpc.private_subnet_ids` for RDS subnet placement.

### `outputs.tf`
- Exposes important result values after `terraform apply`.
- Includes:
  - `vpc_id`
  - `public_subnet_ids`
  - `private_subnet_ids`
  - `rds_endpoint`
  - `rds_instance_id`

### `modules/vpc/main.tf`
- Creates the VPC.
- Creates an Internet Gateway for outbound internet access.
- Creates a public route table with a default route to the IGW.
- Builds public and private subnets using a `for_each` mapping.
- Associates public subnets with the public route table.
- Uses `aws_availability_zones.available` to place subnets across available AZs.

### `modules/vpc/variables.tf`
- Accepts VPC and subnet CIDR blocks from the root module.
- Converts subnet CIDRs into maps for `for_each`.

### `modules/vpc/outputs.tf`
- Returns the created VPC ID and subnet IDs.

### `modules/rds/main.tf`
- Creates the DB subnet group using the private subnet IDs.
- Creates a security group with ingress for port 1433.
- Deploys an AWS RDS SQL Server Express instance.
- Uses `skip_final_snapshot = true` for easier cleanup in learning environments.

### `modules/rds/variables.tf`
- Accepts network and database settings from the root module.
- Includes security, engine, and visibility settings.

### `modules/rds/outputs.tf`
- Returns the RDS endpoint and instance ID.

## How the deployment works

1. `terraform init` downloads the AWS provider and initializes the workspace.
2. `terraform plan` computes the resources to create.
3. `terraform apply` creates the VPC, subnets, security groups, and RDS instance.
4. The project outputs the RDS endpoint and IDs.

## AWS Free Tier guidance

- The default instance class is `db.t3.micro`, which is the smallest supported option for SQL Server on RDS.
- Storage is set to `20 GB`, which is within the Free Tier storage range for RDS where possible.
- The chosen engine is `sqlserver-ex`, which is the SQL Server Express edition.

## Security notes

- The default `db_allowed_cidr` value is `0.0.0.0/0`, which means open access from anywhere. This is not safe for production.
- Change `db_allowed_cidr` to your home/office public IP range before applying.
- Keep `db_password` secret and do not commit it to source control.
- For better security, consider:
  - using a narrow CIDR block
  - disabling `db_publicly_accessible` if you only need internal access
  - adding a bastion host or VPN for private access

## Recommended workflow for beginners

1. Copy `terraform.tfvars.example` to `terraform.tfvars`.
2. Update `db_password` with a strong secret.
3. Optionally update `db_allowed_cidr` to a safer CIDR.
4. Run:
   ```powershell
   terraform init
   terraform plan
   terraform apply
   ```
5. After deployment, note the `rds_endpoint` output.
6. When finished, run:
   ```powershell
   terraform destroy
   ```

## Learning tips

- `modules/vpc/` is responsible for the network layer.
- `modules/rds/` is responsible for the database layer.
- `main.tf` connects the two modules.
- `variables.tf` is where you customize the deployment without changing module code.
- `outputs.tf` helps you see important results after deployment.

## Useful commands

- `terraform init` — initialize the project
- `terraform plan` — preview resource changes
- `terraform apply` — create resources
- `terraform destroy` — delete resources
- `terraform fmt -recursive` — format all Terraform files
- `terraform validate` — validate the Terraform configuration
