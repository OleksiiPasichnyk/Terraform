### Readme on how to work with this repo and it is also attachment to the Lesson 25 DevOps Group2 ###
How to add jenkins backup to the jenkins continer
1. Log in to the Jenkins instance
    a. *ssh username@jenkins-ip -i ${path to SSH key}*
2. stop Jenkins service
        *sudo systemctl stop jenkins.service*
3. archive jenkins $HOME directory
    a. good write up is here 
    https://medium.com/@swarnamalya044/backing-up-jenkins-server-and-restoring-into-another-new-jenkins-server-61980d74b34d
     I'm just transferring it
    b.  *tar –zcvf (backupname).tar.gz /var/lib/jenkins/*
*(optional)* 4. transfer archive to the s3
                a. your instance need to have either role access to be able to use s3's or proper set of key to login as user
                b. install aws cli ( apt install aws-cli )
                c. aws s3 cp *source* *destination* 
                    aws s3 cp (backupname).tar.gz s3://s3bucketname/buketname
*(optional)* 5. download archive to your localhost
                a. need aws-cli installed ^
                b. need aws access configured ^
                c. aws s3 cp s3://s3bucketname/buketname (backupname).tar.gz
             5a. download straight from the instance with rsync
                a. *rsync -avz -e "ssh -i ${your ssh key path} " --progress ubuntu@${jenkins_instance_ip}:/var/lib/jenkins/ ${your directory of choice to where to download}*
6. Unarchive tarball 
    a. *sudo tar -zxvf ${backupname}.tar.gz -C ${directory of your chooice}*
7. Change file ownership to allow docker to have access to them
    b. run *chown ${USER} ${directory of your chooice from above step}*
8. Update *jenkins_docker_setup.yaml*
9. run *docker-compose -f jenkins_docker_setup.yaml up -d*
10. enjoy Jenkins with your backup


    