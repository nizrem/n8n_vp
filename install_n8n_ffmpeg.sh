#!/bin/bash

echo "🚀 Starting Docker + n8n + FFmpeg installation..."

# Обновляем систему и устанавливаем Docker
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
sudo apt install -y docker-ce docker-compose

# Создаём папку для данных n8n
mkdir -p ~/n8n_data
sudo chown -R 1000:1000 ~/n8n_data
sudo chmod -R 755 ~/n8n_data
echo "✅ n8n data folder ready"

# Получаем внешний IP
export EXTERNAL_IP=http://"$(hostname -I | cut -f1 -d' ')"

# Собираем и запускаем контейнер с n8n + FFmpeg
sudo -E docker compose up -d --build

echo "🎉 Installation complete! Access n8n at: $EXTERNAL_IP"
