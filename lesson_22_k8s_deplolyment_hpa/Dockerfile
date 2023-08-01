FROM ubuntu:22.04
USER root
RUN echo 'APT::Get::AllowUnauthenticated "true";' > /etc/apt/apt.conf.d/99myown 
RUN apt-get update && apt-get install -y stress && apt-get install stress-ng && apt-get clean
CMD ["sleep", "3600"]