pipeline {
    agent any
    tools {
        terraform 'tf1.6'
    }

    stages {

        stage('Sparse Checkout') {
            steps {
                script {
                    // Define the repository URL
                    def repoUrl = 'https://github.com/OleksiiPasichnyk/Terraform.git'

                    // Define the directory to checkout
                    def sparseCheckoutPaths = 'projects/pacman-deployed-with-jenkins'

                    // Checkout command
                    checkout([$class: 'GitSCM', 
                              branches: [[name: '*/main']],
                              doGenerateSubmoduleConfigurations: false,
                              extensions: [[$class: 'SparseCheckoutPaths',
                                            sparseCheckoutPaths: sparseCheckoutPaths]],
                              userRemoteConfigs: [[url: repoUrl]]
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
        stage('Plan verification and user input for Destroy') {
            steps {
                input message: 'proceed or abort?', ok: 'ok'
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