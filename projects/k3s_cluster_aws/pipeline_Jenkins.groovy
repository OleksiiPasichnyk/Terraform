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
                                  sparseCheckoutPaths: [[path: 'projects/k3s_cluster_aws/cluster_init/']]
                              ]],
                              userRemoteConfigs: [[
                                  url: 'https://github.com/OleksiiPasichnyk/Terraform.git'
                              ]]
                    ])
                }
            }
        }
        stage('Terraform Plan main vpc creation') {
            steps {
                sh '''
                cd ./projects/k3s_cluster_aws/cluster_init/terraform/main_vpc_config
                terraform init -input=false
                terraform plan -out=terraform.tfplan
                '''
            }
        }

        stage('Plan Verification') {
            steps {
                input(
                    message: 'Review the plan. Proceed with apply?',
                    ok: 'Proceed'
                )
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                cd ./projects/k3s_cluster_aws/cluster_init/terraform/main_vpc_config
                terraform apply -input=false terraform.tfplan
                '''
            }
        }

        stage('Terraform Plan master creation') {
            steps {
                sh '''
                cd ./projects/k3s_cluster_aws/cluster_init/terraform/master_node_config
                terraform init -input=false
                terraform plan -out=terraform.tfplan
                '''
            }
        }

        stage('Plan Verification') {
            steps {
                input(
                    message: 'Review the plan. Proceed with apply?',
                    ok: 'Proceed'
                )
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                cd ./projects/k3s_cluster_aws/cluster_init/terraform/master_node_config
                terraform apply -input=false terraform.tfplan
                '''
            }
        }

        stage('Get Terraform Outputs') {
            steps {
                sh '''
                cd ./projects/pacman-deployed-with-jenkins/terraform
                terraform output web-address-nodejs > ../ansible-playbook/instance_ip.txt
                '''
            }
        }

        stage('Terraform Plan master creation') {
            steps {
                sh '''
                cd ./projects/k3s_cluster_aws/cluster_init/terraform/worker_node_config
                terraform init -input=false
                terraform plan -out=terraform.tfplan
                '''
            }
        }

        stage('Plan Verification') {
            steps {
                input(
                    message: 'Review the plan. Proceed with apply?',
                    ok: 'Proceed'
                )
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                cd ./projects/k3s_cluster_aws/cluster_init/terraform/worker_node_config
                terraform apply -input=false terraform.tfplan
                '''
            }
        }
    }
}
