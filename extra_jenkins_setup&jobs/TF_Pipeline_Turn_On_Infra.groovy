pipeline {
  agent any
  tools {
    terraform "latest"
  }
  stages {
    stage('Clone Git repo') {
      steps {
        git(branch: 'main', url: 'git@github.com:OleksiiPasichnyk/Terraform.git', credentialsId: 'access_to_git')
      }
    }
    stage('Plan') {
      steps {
         withCredentials([
          usernamePassword(credentialsId: 'simple_creds_aws', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')
            ]) {
          sh '''
            aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
            aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
            cd ./generic_infra_setup/
            terraform init 
            terraform plan -out=terraform.tfplan
          '''
          }
          
        }
      }
    stage('Plan verification and user input') {
      steps {
        input message: 'proceed or abort?', ok: 'ok'
      }
    }
    stage('Apply') {
        steps {
           sh '''
           cd ./generic_infra_setup
           terraform apply terraform.tfplan
           '''
        }
    }
  }
}