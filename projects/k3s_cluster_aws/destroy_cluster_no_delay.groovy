pipeline {
    options {
        ansiColor('xterm')
    }
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
        stage('Terraform Plan Destroy Worker Nodes') {
            steps {
                sh '''
                cd ./projects/k3s_cluster_aws/cluster_init/terraform/worker_node_config
                terraform init -input=false
                terraform plan -destroy -out=terraform_destroy.tfplan
                '''
            }
        }
        stage('Terraform Apply Destroy Worker Nodes') {
            steps {
                sh '''
                cd ./projects/k3s_cluster_aws/cluster_init/terraform/worker_node_config
                terraform apply -input=false terraform_destroy.tfplan
                '''
            }
        }
        stage('Terraform Plan Destroy Master Node(s)') {
            steps {
                sh '''
                cd ./projects/k3s_cluster_aws/cluster_init/terraform/master_node_config
                terraform init -input=false
                terraform plan -destroy -out=terraform_destroy.tfplan
                '''
            }
        }
        stage('Terraform Apply Destroy Master Node(s)') {
            steps {
                sh '''
                cd ./projects/k3s_cluster_aws/cluster_init/terraform/master_node_config
                terraform apply -input=false terraform_destroy.tfplan
                '''
            }
        }
        stage('Terraform Plan Destroy VPC') {
            steps {
                sh '''
                cd ./projects/k3s_cluster_aws/cluster_init/terraform/main_vpc_config
                terraform init -input=false
                terraform plan -destroy -out=terraform_destroy.tfplan
                '''
            }
        }
        stage('Terraform Apply Destroy VPC') {
            steps {
                sh '''
                cd ./projects/k3s_cluster_aws/cluster_init/terraform/main_vpc_config
                terraform apply -input=false terraform_destroy.tfplan
                '''
            }
        }
    }
}
