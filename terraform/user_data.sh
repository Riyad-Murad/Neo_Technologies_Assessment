#!/bin/bash
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# ----- swaps 1 GB from storage to memory -----

sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# ----- To make it permanent (persist after reboot) -----

echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# ----- To add the docker to the ubuntu groups -----

sudo usermod -aG docker ubuntu
newgrp docker

# # Run Ghost with SQLite (default for development)
# sudo docker run -d \
#   --name ghost \
#   -e NODE_ENV=development \
#   -p 80:2368 \
#   ghost
