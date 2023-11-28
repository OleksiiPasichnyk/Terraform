pipeline {
    agent any
    tools {
        terraform 'tf1.6'
    }

    stages {
        stage('Sparse Checkout') {
            steps {
                script {
                    checkout([$class: 'GitSCM', 
                              branches: [[name: 'main']],
                              doGenerateSubmoduleConfigurations: false,
                              extensions: [[
                                  $class: 'SparseCheckoutPaths', 
                                  sparseCheckoutPaths: [[path: 'projects/pacman-deployed-with-jenkins']]
                              ]],
                              userRemoteConfigs: [[
                                  url: 'https://github.com/OleksiiPasichnyk/Terraform.git'
                              ]]
                    ])
                }
            }
        }
        
        stage('Terraform Initialize and Plan Destroy') {
            steps {
                sh '''
                cd ./projects/pacman-deployed-with-jenkins/terraform
                terraform init
                terraform plan -destroy -out=destroyplan.tfplan
                '''
            }
        }

        stage('Review Destroy Plan') {
            steps {
                input message: 'Review the destroy plan. Proceed with destruction?', ok: 'Proceed'
            }
        }

        stage('Terraform Apply Destroy') {
            steps {
                sh '''
                cd ./projects/pacman-deployed-with-jenkins/terraform
                terraform apply destroyplan.tfplan
                '''
            }
        }
    }
}
