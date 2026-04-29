pipeline {
  agent any
  options {
    ansiColor('xterm')
    timestamps()
  }
  parameters {
    booleanParam(name: 'APPLY', defaultValue: false, description: 'Run terraform apply after a successful plan')
    string(name: 'DB_ALLOWED_CIDR', defaultValue: '0.0.0.0/0', description: 'CIDR range allowed to connect to the database')
    passwordParam(name: 'DB_PASSWORD', defaultValue: '', description: 'SQL Server master password (will be hidden in Jenkins)')
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
          usernamePassword(credentialsId: 'aws_cred_jenkins', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          withEnv(["TF_VAR_db_password=${params.DB_PASSWORD}"]) {
            bat "terraform.exe plan -var=\"db_allowed_cidr=${params.DB_ALLOWED_CIDR}\" -out=tfplan"
          }
        }
      }
    }
    stage('Terraform Apply') {
      when {
        expression { return params.APPLY }
      }
      steps {
        withCredentials([
          usernamePassword(credentialsId: 'aws_cred_jenkins', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          withEnv(["TF_VAR_db_password=${params.DB_PASSWORD}"]) {
            bat 'terraform.exe apply -auto-approve tfplan'
          }
        }
      }
    }
  }
}
