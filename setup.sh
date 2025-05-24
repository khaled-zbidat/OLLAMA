#!/bin/bash
# Script to set up Ollama service on EC2
#DEV
# Update system packages
sudo apt-get update
sudo apt-get upgrade -y

# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Verify installation
systemctl status ollama

# Pull a suitable model for children's stories
# Gemma 3:1b is a good balance of capability and resource usage
ollama pull llama3.2

# Ensure Ollama service is running and enabled on startup
sudo systemctl enable ollama
sudo systemctl start ollama

# Update systemd service to listen on all interfaces
sudo sed -i 's|ExecStart=.*|ExecStart=/usr/bin/env OLLAMA_HOST=0.0.0.0 /usr/local/bin/ollama serve|' /etc/systemd/system/ollama.service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart ollama


# Configure security to allow access from web app
# Note: In production, use more restrictive security settings
sudo ufw allow 11434/tcp
sudo ufw enable

echo "Ollama service is ready!"