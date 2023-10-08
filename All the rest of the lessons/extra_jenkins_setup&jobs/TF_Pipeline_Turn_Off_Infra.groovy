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
    stage('Destroy') {
      steps {
        withCredentials([
          usernamePassword(credentialsId: 'simple_creds_aws', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
          aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
          aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
          cd ./generic_infra_setup/
          terraform init
          terraform plan -destroy -out destroyplan.tfplan || error "Terraform plan failed"
          '''
          input message: 'Proceed to destroy resources?', ok: 'Destroy'
          sh '''
          cd ./generic_infra_setup/
          terraform apply destroyplan.tfplan || error "Terraform apply failed"
          '''
          sh 'rm destroyplan.tfplan'
          sh 'aws configure unset aws_access_key_id aws_secret_access_key'
        }
      }
    }
  }
  post {
    failure {
      mail to: 'admin@example.com', subject: 'Terraform Destroy Failed', body: 'The Terraform destroy pipeline failed.'
    }
  }
}
