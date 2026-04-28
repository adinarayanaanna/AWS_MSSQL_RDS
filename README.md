# AWS VPC + SQL Server Express RDS Terraform Project

This project deploys a secure AWS network and a SQL Server Express database using Terraform.
It is built in a way that beginners can understand, with separate modules for networking and the database.

---

## What this project creates

- An AWS Virtual Private Cloud (VPC)
- Public subnets for internet access
- Private subnets for the database
- An Internet Gateway for outbound traffic
- A public route table and subnet associations
- An AWS RDS SQL Server Express instance
- A database security group to control access to port 1433

---

## How the code is organized

### Root files

- `providers.tf`
  - Configures Terraform to use AWS.
  - Sets the AWS region.

- `variables.tf`
  - Defines values you can change without editing module code.
  - Includes network, database, and tagging settings.
  - Validates values like database password and CIDR blocks.

- `main.tf`
  - Connects two child modules:
    - `modules/vpc/`
    - `modules/rds/`
  - Passes shared values like project name and environment.

- `outputs.tf`
  - Defines values Terraform will display after deployment,
    such as the database endpoint and subnet IDs.

- `terraform.tfvars.example`
  - Example values for `terraform.tfvars`.
  - Contains placeholders for sensitive data like `db_password`.

### Child modules

- `modules/vpc/`
  - Builds the AWS VPC, subnets, route table, and internet gateway.
  - Returns VPC and subnet IDs for use by other modules.

- `modules/rds/`
  - Builds the RDS subnet group, security group, and SQL Server instance.
  - Uses private subnets so the database is isolated by default.

---

## How the project works

1. `terraform init` downloads the provider and prepares the folder.
2. `terraform plan` calculates what resources Terraform will create.
3. `terraform apply` creates the AWS resources.
4. `terraform destroy` removes the AWS resources when you are done.

---

## Detailed file explanation

### `providers.tf`
This file tells Terraform:
- which provider to use (`hashicorp/aws`)
- which version to use
- which AWS region to deploy into

### `variables.tf`
This file defines the settings you can change.
It includes:
- `aws_region` — AWS region like `us-east-1`
- `vpc_cidr` — the IP range for your VPC
- subnet CIDRs for public/private subnets
- RDS settings like instance size and storage
- `project_name` and `environment` for tags
- `db_password` validation to prevent invalid SQL Server passwords
- `db_publicly_accessible` defaulting to `false`
- `db_allowed_cidr` to restrict database access

### `main.tf`
This file is the root wiring.
It does not create resources directly.
Instead, it calls:
- `module "vpc"` to create the network
- `module "rds"` to create the database

The RDS module receives needed values from the VPC module, like `vpc_id` and `private_subnet_ids`.

### Where values come from

- Root variables in `variables.tf` define values such as:
  - `aws_region`
  - `vpc_cidr`
  - `public_subnet_cidrs`
  - `private_subnet_cidrs`
  - `db_instance_class`
  - `db_allocated_storage`
  - `db_engine`
  - `db_username`
  - `db_password`
  - `db_publicly_accessible`
  - `db_allowed_cidr`
  - `project_name`
  - `environment`

- `terraform.tfvars` or `terraform.tfvars.example` can override these root variable defaults.

- `main.tf` passes root variable values into child modules:
  - `modules/vpc/` receives network and tagging inputs
  - `modules/rds/` receives database and tagging inputs

- `modules/vpc/variables.tf` defines the inputs the VPC module accepts.
- `modules/rds/variables.tf` defines the inputs the RDS module accepts.

- `modules/vpc/outputs.tf` returns values such as:
  - `vpc_id`
  - `public_subnet_ids`
  - `private_subnet_ids`

- `main.tf` feeds the private subnet IDs and VPC ID into `module.rds` so RDS is deployed inside the VPC.

- `modules/rds/outputs.tf` returns values such as:
  - `db_endpoint`
  - `db_instance_id`
  - `db_security_group_id`

### `outputs.tf`
Outputs show useful values after deployment.
These include:
- VPC ID
- public and private subnet IDs
- RDS endpoint and instance ID
- RDS security group ID

---

## Module detail

### `modules/vpc/`
This module creates the network layer.
It includes:
- `aws_vpc` — the private network
- `aws_internet_gateway` — to allow outbound internet
- `aws_route_table` — route public subnet traffic to the internet
- `aws_subnet` resources for public and private subnets
- `aws_route_table_association` — binds public subnets to the route table
- tags for all resources using `Project` and `Environment`

### `modules/rds/`
This module creates the database layer.
It includes:
- `aws_db_subnet_group` — groups the private subnets for RDS
- `aws_security_group` — allows SQL Server traffic on port 1433
- `aws_db_instance` — creates the SQL Server Express database

The database is configured with safe defaults:
- encrypted storage
- 7-day backups
- automatic minor version upgrades
- no final snapshot when destroying (for easier cleanup)

---

## How to deploy

1. Copy the example variables file:
   ```powershell
   copy terraform.tfvars.example terraform.tfvars
   ```
2. Open `terraform.tfvars` and set:
   - `db_password` to a strong password
   - `db_allowed_cidr` to your IP range
3. Initialize Terraform:
   ```powershell
   terraform init
   ```
4. Preview the plan:
   ```powershell
   terraform plan
   ```
5. Apply the deployment:
   ```powershell
   terraform apply
   ```
6. When you are finished, remove resources:
   ```powershell
   terraform destroy
   ```

---

## Important security notes

- Do not commit `terraform.tfvars` to Git.
- Use a strong password for `db_password`.
- Prefer a narrow `db_allowed_cidr` instead of `0.0.0.0/0`.
- Keep `db_publicly_accessible` set to `false` unless you need external access.

---

## Tips for beginners

- `terraform init` prepares the working directory.
- `terraform plan` shows what Terraform will do.
- `terraform apply` creates the AWS resources.
- `terraform destroy` removes them.

If something is unclear, read `main.tf` first and then the module files.
`main.tf` shows how the pieces are connected.
