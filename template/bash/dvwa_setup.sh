#!/bin/bash

set -e

echo "=== Docker and DVWA Installation Script ==="
echo

# Check if running as root
if [ "$EUID" -ne 0 ]; then
   echo "This script must be run as root. Use: sudo bash script.sh"
   exit 1
fi

# Detect OS
if [ -f /etc/os-release ]; then
   . /etc/os-release
   OS=$ID
else
   echo "Cannot detect OS"
   exit 1
fi

echo "Detected OS: $OS"
echo

# Install Docker based on OS
if [ "$OS" = "ubuntu" ] || [ "$OS" = "debian" ]; then
   echo "Installing Docker on Debian/Ubuntu..."
   apt-get update
   apt-get install -y \
      ca-certificates \
      curl \
      gnupg \
      lsb-release

   mkdir -p /etc/apt/keyrings
   curl -fsSL https://download.docker.com/linux/$OS/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   
   echo \
     "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$OS \
     $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
   
   apt-get update
   apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

elif [ "$OS" = "centos" ] || [ "$OS" = "rhel" ] || [ "$OS" = "fedora" ]; then
   echo "Installing Docker on CentOS/RHEL/Fedora..."
   yum install -y yum-utils
   yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
   yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

else
   echo "Unsupported OS: $OS"
   exit 1
fi

echo
echo "Starting Docker service..."
systemctl start docker
systemctl enable docker

echo
echo "Adding current user to docker group..."
usermod -aG docker $SUDO_USER

echo
echo "=== Docker Installation Complete ==="
echo
echo "Note: You need to log out and log back in (or run 'newgrp docker') for group changes to take effect."
echo

# Run DVWA container
echo "Pulling and running vulnerabilities/web-dvwa container..."
docker run -d \
   --name dvwa \
   --restart always \
   -p 80:80 \
   vulnerables/web-dvwa

echo
echo "=== DVWA Container Started ==="
echo "Container name: dvwa"
echo "Access DVWA at: http://localhost"
echo "Default credentials:"
echo "  Username: admin"
echo "  Password: password"
echo
echo "To view logs: docker logs dvwa"
echo "To stop container: docker stop dvwa"
echo "To restart container: docker restart dvwa"
