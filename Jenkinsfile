pipeline {
  agent any
  options {
    ansiColor('xterm')
    timestamps()
  }
  parameters {
    booleanParam(name: 'APPLY', defaultValue: false, description: 'Run terraform apply after a successful plan')
    string(name: 'DB_ALLOWED_CIDR', defaultValue: '0.0.0.0/0', description: 'CIDR range allowed to connect to the database')
  }
  environment {
    TF_IN_AUTOMATION = 'true'
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Terraform Format') {
      steps {
        bat 'terraform.exe fmt -recursive -check'
      }
    }
    stage('Terraform Init') {
      steps {
        bat 'terraform.exe init'
      }
    }
    stage('Terraform Validate') {
      steps {
        bat 'terraform.exe validate'
      }
    }
    stage('Terraform Plan') {
      steps {
        withCredentials([
          usernamePassword(credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY'),
          string(credentialsId: 'tf-db-password', variable: 'TF_VAR_db_password')
        ]) {
          bat "terraform.exe plan -var=\"db_allowed_cidr=${params.DB_ALLOWED_CIDR}\" -out=tfplan"
        }
      }
    }
    stage('Terraform Apply') {
      when {
        expression { return params.APPLY }
      }
      steps {
        withCredentials([
          usernamePassword(credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY'),
          string(credentialsId: 'tf-db-password', variable: 'TF_VAR_db_password')
        ]) {
          bat 'terraform.exe apply -auto-approve tfplan'
        }
      }
    }
  }
}
