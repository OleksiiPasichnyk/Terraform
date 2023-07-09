pipeline {
   agent any
   tools { terraform "latest" }
   parameters {
          string(name: 'key_id', defaultValue: 'null', description: 'your aws access key id')
          string(name: 'key_value', defaultValue: 'null', description: 'your aws access key value')
           }
   stages{
      stage ('clone git repo') {
        steps {
          git (branch: 'main', url: 'git@github.com:OleksiiPasichnyk/Terraform.git', credentialsId: 'access_to_git' )
        }
      }
      stage ('Plan') {
        steps {
          sh 'cd ./jenkins_tf_lesson_14/terraform_infra'
          sh 'echo "variable "key_id"=${params.key_id}" > variables.tf'
          sh 'echo "variable "key_value"=${params.key_value}" >> variables.tf'
          sh 'cat variables.tf'
          sh 'terraform plan -out=terraform.tfplan'
        }
      }
      stage('Plan verification and user input') {
        steps {
            input(message: 'Proceed or abort?', ok: 'Proceed', parameters: [[$class: 'AbortException', name: 'Abort']])
        }
    }
      stage ('Apply') {
        steps {
          sh 'terraform apply terraform.tfplan'
        }
      }
    }
  }