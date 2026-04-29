pipeline {
  agent any

  options {
    ansiColor('xterm')
    timestamps()
  }

  parameters {
    choice(
      name: 'ACTION',
      choices: ['plan', 'apply', 'destroy'],
      description: 'Choose Terraform action'
    )

    string(
      name: 'DB_ALLOWED_CIDR',
      defaultValue: '0.0.0.0/0',
      description: 'CIDR range allowed to connect to the database'
    )

    password(
      name: 'DB_PASSWORD',
      defaultValue: '',
      description: 'SQL Server master password'
    )
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
      when {
        anyOf {
          expression { params.ACTION == 'plan' }
          expression { params.ACTION == 'apply' }
        }
      }

      steps {
        withCredentials([
          usernamePassword(
            credentialsId: 'aws_cred_jenkins',
            usernameVariable: 'AWS_ACCESS_KEY_ID',
            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
          )
        ]) {

          withEnv(["TF_VAR_db_password=${params.DB_PASSWORD}"]) {

            bat """
            terraform.exe plan ^
            -var="db_allowed_cidr=${params.DB_ALLOWED_CIDR}" ^
            -out=tfplan
            """
          }
        }
      }
    }

    stage('Terraform Apply') {
      when {
        expression { params.ACTION == 'apply' }
      }

      steps {
        withCredentials([
          usernamePassword(
            credentialsId: 'aws_cred_jenkins',
            usernameVariable: 'AWS_ACCESS_KEY_ID',
            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
          )
        ]) {

          withEnv(["TF_VAR_db_password=${params.DB_PASSWORD}"]) {

            bat 'terraform.exe apply -auto-approve tfplan'
          }
        }
      }
    }

    stage('Terraform Destroy') {
      when {
        expression { params.ACTION == 'destroy' }
      }

      steps {
        input message: 'Are you sure you want to DESTROY all Terraform resources?', ok: 'Destroy'

        withCredentials([
          usernamePassword(
            credentialsId: 'aws_cred_jenkins',
            usernameVariable: 'AWS_ACCESS_KEY_ID',
            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
          )
        ]) {

          withEnv(["TF_VAR_db_password=${params.DB_PASSWORD}"]) {

            bat """
            terraform.exe destroy -auto-approve ^
            -var="db_allowed_cidr=${params.DB_ALLOWED_CIDR}"
            """
          }
        }
      }
    }
  }

  post {

    success {
      echo 'Pipeline completed successfully.'
    }

    failure {
      echo 'Pipeline failed.'
    }

    always {
      cleanWs()
    }
  }
}