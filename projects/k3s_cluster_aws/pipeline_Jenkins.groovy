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
        stage('Terraform Plan - Main VPC') {
            steps {
                sh '''
                cd ./projects/k3s_cluster_aws/cluster_init/terraform/main_vpc_config
                terraform init -input=false
                terraform plan -out=terraform.tfplan
                '''
            }
        }
        stage('Approval - Main VPC') {
            steps {
                input(
                    message: 'Review the main VPC plan. Proceed with apply?',
                    ok: 'Proceed'
                )
            }
        }
        stage('Terraform Apply - Main VPC') {
            steps {
                sh '''
                cd ./projects/k3s_cluster_aws/cluster_init/terraform/main_vpc_config
                terraform apply -input=false terraform.tfplan
                '''
            }
        }
        stage('Terraform Plan - Master Node') {
            steps {
                sh '''
                cd ./projects/k3s_cluster_aws/cluster_init/terraform/master_node_config
                terraform init -input=false
                terraform plan -out=terraform.tfplan
                '''
            }
        }
        stage('Approval - Master Node') {
            steps {
                input(
                    message: 'Review the master node plan. Proceed with apply?',
                    ok: 'Proceed'
                )
            }
        }
        stage('Terraform Apply - Master Node') {
            steps {
                sh '''
                cd ./projects/k3s_cluster_aws/cluster_init/terraform/master_node_config
                terraform apply -input=false terraform.tfplan
                terraform output k3s_master_instance_private_ip > ../../ansible/master_ip.txt
                '''
            }
        }
        stage('Terraform Plan - Worker Nodes') {
            steps {
                sh '''
                cd ./projects/k3s_cluster_aws/cluster_init/terraform/worker_node_config
                terraform init -input=false
                terraform plan -out=terraform.tfplan
                '''
            }
        }
        stage('Approval - Worker Nodes') {
            steps {
                input(
                    message: 'Review the worker nodes plan. Proceed with apply?',
                    ok: 'Proceed'
                )
            }
        }
        stage('Terraform Apply - Worker Nodes') {
            steps {
                sh '''
                cd ./projects/k3s_cluster_aws/cluster_init/terraform/worker_node_config
                terraform apply -input=false terraform.tfplan
                terraform output k3s_workers_instance_private_ip > ../../ansible/worker_ip.txt
                '''
            }
        }
        stage('Install Ansible') {
            steps {
                sh '''
                sudo apt-add-repository ppa:ansible/ansible -y
                sudo apt-get update
                sudo apt-get install ansible -y
                '''
            }
        }
        stage('Run Ansible Playbooks') {
            steps {
                sh '''
                cd ./projects/k3s_cluster_aws/cluster_init/ansible
                ansible-playbook -i master_ip.txt master_setup.yml
                ansible-playbook -i worker_ip.txt worker_setup.yml
                '''
            }
        }
    }
}
