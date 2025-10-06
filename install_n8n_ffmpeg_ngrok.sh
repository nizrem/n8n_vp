#!/bin/bash

echo "🚀 Starting full n8n + FFmpeg + Ngrok setup..."

# -----------------------------
# 1️⃣ Установка Docker
# -----------------------------
echo "📦 Installing Docker..."
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common jq
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
sudo apt install -y docker-ce docker-compose
echo "✅ Docker installed"

# -----------------------------
# 2️⃣ Создание папки данных n8n
# -----------------------------
mkdir -p ~/n8n_data
sudo chown -R 1000:1000 ~/n8n_data
sudo chmod -R 755 ~/n8n_data
echo "✅ n8n data folder ready"

# -----------------------------
# 3️⃣ Dockerfile для n8n + FFmpeg
# -----------------------------
cat > Dockerfile <<EOL
FROM n8nio/n8n:latest

USER root

RUN apt update && apt install -y ffmpeg && \
    apt clean && rm -rf /var/lib/apt/lists/*

USER node
EOL
echo "✅ Dockerfile for n8n + FFmpeg created"

# -----------------------------
# 4️⃣ docker-compose.yaml
# -----------------------------
export EXTERNAL_IP=http://"$(hostname -I | cut -f1 -d' ')"

cat > docker-compose.yaml <<EOL
version: "3.8"

services:
  svr_n8n:
    build: .
    container_name: n8n_container
    environment:
      - N8N_SECURE_COOKIE=false
      - N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE=true
      - N8N_EDITOR_BASE_URL=${EXTERNAL_IP}
      - WEBHOOK_URL=${EXTERNAL_IP}
      - N8N_DEFAULT_BINARY_DATA_MODE=filesystem
    ports:
      - "80:5678"
    volumes:
      - /root/n8n_data:/home/node/.n8n
EOL
echo "✅ docker-compose.yaml created"

# -----------------------------
# 5️⃣ Ngrok setup
# -----------------------------
echo "📡 Setting up Ngrok..."
wget -O ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
sudo tar xvzf ./ngrok.tgz -C /usr/local/bin

read -p "Enter Ngrok Auth Token: " NGROK_TOKEN
read -p "Enter Ngrok Domain (e.g., mydomain.ngrok.io): " NGROK_DOMAIN

ngrok config add-authtoken "$NGROK_TOKEN"
ngrok http --url="$NGROK_DOMAIN" 80 > /dev/null &
sleep 8
export EXTERNAL_IP="$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')"
echo "✅ Ngrok URL: $EXTERNAL_IP"

# -----------------------------
# 6️⃣ Сборка и запуск n8n + FFmpeg
# -----------------------------
echo "🐳 Building and starting n8n container..."
sudo -E docker compose up -d --build

echo "🎉 Setup complete! Access n8n UI at: $EXTERNAL_IP"
echo "💡 FFmpeg is ready inside the container. Test with a n8n Execute Command node: ffmpeg -version"
