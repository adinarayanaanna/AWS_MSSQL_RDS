# Jenkins Pipeline for Terraform

This project includes a Jenkins pipeline in the root `Jenkinsfile` to run Terraform for the AWS VPC + RDS deployment.

> Note: this pipeline is written for a Windows Jenkins agent and uses `terraform.exe` commands.

## Required Jenkins credentials

1. `aws_cred_jenkins`
   - Type: AWS Credentials
   - Provides the AWS access key ID and secret access key
   - The pipeline binds this credential using the AWS Credentials plugin

## DB password handling

- `DB_PASSWORD` is entered at build time as a hidden password parameter.
- The pipeline now fails early with a clear error if `DB_PASSWORD` is not provided.
- Before Terraform formatting, the pipeline checks DNS/network connectivity to `rds.us-east-1.amazonaws.com`.
- The pipeline uses `DB_PASSWORD` at runtime to pass `TF_VAR_db_password` into Terraform.
- If you want a persistent secret store, save the password in Jenkins Credentials or AWS Secrets Manager and use it outside the pipeline.

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
