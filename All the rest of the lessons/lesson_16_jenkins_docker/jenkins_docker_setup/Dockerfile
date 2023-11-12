FROM jenkins/jenkins:2.401.2-jdk17
# Set the environment variable for JENKINS_HOME
# Replace /var/jenkins_home with the directory you wish to use
ENV JENKINS_HOME /var/jenkins_home
# Create the Jenkins home directory
USER root
RUN mkdir -p $JENKINS_HOME && chown -R jenkins:jenkins $JENKINS_HOME
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"