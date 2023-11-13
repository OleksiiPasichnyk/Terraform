### Readme on How to Work with This Repo (Attachment to Lesson 25 DevOps Group2)

#### How to Add Jenkins Backup to the Jenkins Container

1. **Log in to the Jenkins Instance**
    - SSH into the instance: `ssh username@jenkins-ip -i {path_to_SSH_key}`

2. **Stop Jenkins Service**
    - Run: `sudo systemctl stop jenkins.service`

3. **Archive Jenkins $HOME Directory**
    - A helpful guide: [Backing up Jenkins Server](https://medium.com/@swarnamalya044/backing-up-jenkins-server-and-restoring-into-another-new-jenkins-server-61980d74b34d)
    - Command: `tar –zcvf backupname.tar.gz /var/lib/jenkins/`

4. **(Optional) Transfer Archive to S3**
    - Ensure instance has role access to S3 or proper AWS user credentials.
    - Install AWS CLI: `apt install aws-cli`
    - Copy to S3: `aws s3 cp backupname.tar.gz s3://s3bucketname/bucketname`

5. **(Optional) Download Archive to Your Localhost**
    - Install and configure AWS CLI.
    - Download from S3: `aws s3 cp s3://s3bucketname/bucketname backupname.tar.gz`
    - *Alternatively, download directly from the instance using rsync*:
      - `rsync -avz -e "ssh -i {your_ssh_key_path}" --progress ubuntu@{jenkins_instance_ip}:/var/lib/jenkins/ {local_directory}`

6. **Unarchive Tarball**
    - Run: `sudo tar -zxvf backupname.tar.gz -C target_directory`

7. **Change File Ownership**
    - Run: `chown {USER} target_directory`

8. **Update `jenkins_docker_setup.yaml`**

9. **Start Jenkins with Docker**
    - Run: `docker-compose -f jenkins_docker_setup.yaml up -d`

10. **Enjoy Jenkins with Your Backup**
