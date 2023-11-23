FROM ubuntu:jammy
USER root
SHELL ["/bin/bash", "-c"]
RUN apt update && apt install -y curl ca-certificates
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "deb [trusted=yes arch=amd64] https://snapshotter.lamina1.global/ubuntu jammy main" > /etc/apt/sources.list.d/lamina1.list && apt update && apt install -y lamina1-betanet
ENTRYPOINT [ "bash", "-c", "sleep", "3600" ]