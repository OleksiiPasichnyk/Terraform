#!/bin/bash
# Use the non-interactive frontend for debconf
export DEBIAN_FRONTEND=noninteractive
echo "deb [trusted=yes arch=amd64] https://snapshotter.lamina1.global/ubuntu jammy main" > /etc/apt/sources.list.d/lamina1.list
apt update
apt install -y lamina1-betanet