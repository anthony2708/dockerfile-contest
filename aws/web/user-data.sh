#!/bin/bash

# Exit the script if there is non-zero return
set -e

# Install Docker

# 1. Add Docker's official GPG key:
sudo apt update -y
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# 2. Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# 3. Grab Docker
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl enable containerd
sudo groupadd docker
sudo usermod -aG docker ${USER}
newgrp docker

# Install Kubectl
sudo apt-get update -y && sudo apt-get install -y apt-transport-https gnupg
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubectl

# Install K3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d cluster create webapp \
  --servers 1 \
  --agents 2 \
  --wait
  -p "80:80@loadbalancer"

# Apply and open the app to user
HOME_DIR="/home/ubuntu"
mkdir -p "$HOME_DIR"/web-config
chown -R ubuntu:ubuntu "$HOME_DIR"

cat <<EOF > "$HOME_DIR"/web-config/deployment.yml
${deployment}
EOF

cat <<EOF > "$HOME_DIR"/web-config/ingress.yml
${ingress}
EOF

cat <<EOF > "$HOME_DIR"/web-config/services.yml
${services}
EOF

kubectl apply -f "$HOME_DIR"/web-config/