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
                                  sparseCheckoutPaths: [[path: 'projects/pacman-deployed-with-jenkins/']]
                              ]],
                              userRemoteConfigs: [[
                                  url: 'https://github.com/OleksiiPasichnyk/Terraform.git'
                              ]]
                    ])
                }
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

        stage('Terraform Plan') {
            steps {
                sh '''
                cd ./projects/pacman-deployed-with-jenkins/terraform
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
                cd ./projects/pacman-deployed-with-jenkins/terraform
                terraform apply -input=false terraform.tfplan
                '''
            }
        }

        stage('Get Terraform Outputs') {
            steps {
                sh '''
                cd ./projects/pacman-deployed-with-jenkins/terraform
                terraform output web-address-nodejs > ../ansible/instance_ip.txt
                '''
            }
        }

        stage('Run Ansible') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'access_for_new_node_js_app', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                    sleep 180
                    cd ./projects/pacman-deployed-with-jenkins/ansible
                    ansible-playbook -i instance_ip.txt playbook_apache.yaml -u ubuntu --private-key=$SSH_KEY -e 'ansible_ssh_common_args="-o StrictHostKeyChecking=no"'
                    '''
                }
            }
        }
    }
}
