# Jenkins Pipeline for Terraform

This project includes a Jenkins pipeline in the root `Jenkinsfile` to run Terraform for the AWS VPC + RDS deployment.

> Note: this pipeline is written for a Windows Jenkins agent and uses `terraform.exe` commands.

## Required Jenkins credentials

1. `aws-credentials`
   - Type: Username with password
   - Username: AWS access key ID
   - Password: AWS secret access key

2. `tf-db-password`
   - Type: Secret text
   - Value: the SQL Server `db_password`

## Pipeline parameters

- `APPLY` (boolean)
  - When `true`, the pipeline runs `terraform apply` after a successful `terraform plan`.
  - When `false`, it only runs `terraform plan`.

- `DB_ALLOWED_CIDR` (string)
  - Overrides the `db_allowed_cidr` variable used by Terraform.
  - Default: `0.0.0.0/0`

## How it works

- Checkout repository from source control.
- Run `terraform fmt -recursive -check`.
- Run `terraform init`.
- Run `terraform validate`.
- Run `terraform plan` and save the plan to `tfplan`.
- If `APPLY` is enabled, run `terraform apply -auto-approve tfplan`.

## Notes

- The pipeline uses local Terraform state by default. If multiple Jenkins agents run this job, consider adding a remote backend.
- Replace the credential IDs in `Jenkinsfile` if your Jenkins instance uses different names.
