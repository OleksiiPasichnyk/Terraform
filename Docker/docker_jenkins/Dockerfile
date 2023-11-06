FROM jenkins/jenkins:2.401.2-jdk17

USER root

# Install prerequisites
RUN apt-get update && apt-get install -y lsb-release \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Add Docker CLI
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
  && apt-get update \
  && apt-get install -y docker-ce-cli \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

USER jenkins

# Install Jenkins plugins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"

# The original Jenkins Docker image has its own ENTRYPOINT that starts Jenkins.
# It is not generally recommended to override this if you want Jenkins to function normally.
# However, if you do need to customize the ENTRYPOINT for your purposes, you could
# include your own script that sets up the environment and then starts Jenkins, for example:
# COPY my-entrypoint.sh /usr/local/bin/my-entrypoint.sh
# ENTRYPOINT ["/usr/local/bin/my-entrypoint.sh"]

# If not, simply don't include an ENTRYPOINT, and the base image's will be used.
