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
         {
        sh '''
        cd ./jenkins_tf_s3_lesson_15/terraform_infra/
        terraform init
        terraform plan -destroy -out destroyplan.tfplan
        '''
        input message: 'proceed or abort?', ok: 'ok'
        sh '''
        cd ./jenkins_tf_s3_lesson_15/terraform_infra/
        terraform apply destroyplan.tfplan
        '''
       }
      }
     }
  }
}