pipeline {
    agent any
    tools {
        terraform 'tf1.6'
    }
    stages {
        stage('Clone Git repo') {
            steps {
    // Bind the SSH private key to an environment variable
    withCredentials([sshUserPrivateKey(credentialsId: 'YourKeyCredNameHere', keyFileVariable: 'SSH_KEY')]) {
        sh '''
        # Start the SSH agent and add the key
        eval $(ssh-agent -s)
        ssh-add $SSH_KEY
        
        # Ensure GitHub is a known host
        ssh-keyscan -H github.com >> ~/.ssh/known_hosts
        
        # Use verbose output for the git command
        GIT_SSH_COMMAND="ssh -v" git clone -b main --single-branch git@github.com:YourNameHere/DevOps_Jan_24.git
        
        # Clean up the SSH agent
        eval $(ssh-agent -k)
        '''
    }
        }
        stage('Terraform Initialize and Plan Destroy') {
            steps {
                sh '''
                cd ./jenkins/terraform_ansible_generic_instace_setup_template
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
                cd ./jenkins/terraform_ansible_generic_instace_setup_template
                terraform apply destroyplan.tfplan
                '''
            }
        }
    }
}
