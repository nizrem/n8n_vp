#!/bin/bash

echo "🔄 Starting n8n update process..."

# Check if compose.yaml exists
if [ ! -f ~/compose.yaml ]; then
    echo "❌ Error: compose.yaml not found in home directory!"
    exit 1
fi

cd ~

# Backup old data
echo "💾 Creating backup..."
if [ -d ~/n8n_data_backup ]; then
    echo "🗑️  Removing old backup..."
    sudo rm -rf ~/n8n_data_backup
fi

echo "📦 Backing up n8n data..."
sudo cp -r ~/n8n_data ~/n8n_data_backup
echo "✅ Backup created at ~/n8n_data_backup"

# Stop containers
echo "🛑 Stopping n8n container..."
sudo docker compose down

# Pull latest n8n image
echo "📥 Pulling latest n8n image..."
sudo docker pull n8nio/n8n:latest

# Rebuild image with latest n8n and ffmpeg
echo "🔨 Rebuilding custom image with latest n8n and ffmpeg..."
sudo docker compose build --no-cache

# Start containers
echo "🚀 Starting n8n container..."
export EXTERNAL_IP=http://"$(hostname -I | cut -f1 -d' ')"
sudo -E docker compose up -d

# Wait for container to start
echo "⏳ Waiting for container to start..."
sleep 10

# Verify ffmpeg installation
echo "🎬 Verifying ffmpeg installation..."
if sudo docker exec n8n_container ffmpeg -version > /dev/null 2>&1; then
    FFMPEG_VERSION=$(sudo docker exec n8n_container ffmpeg -version | head -n1)
    echo "✅ ffmpeg is installed: $FFMPEG_VERSION"
else
    echo "❌ Warning: ffmpeg verification failed!"
fi

# Get n8n version
N8N_VERSION=$(sudo docker exec n8n_container n8n --version 2>/dev/null || echo "unknown")
echo "✅ n8n version: $N8N_VERSION"

echo ""
echo "🎉 Update complete!"
echo "📍 Access n8n at: $EXTERNAL_IP"
echo "💾 Backup location: ~/n8n_data_backup"
echo ""
echo "ℹ️  To restore from backup if needed:"
echo "   sudo docker compose down"
echo "   sudo rm -rf ~/n8n_data"
echo "   sudo cp -r ~/n8n_data_backup ~/n8n_data"
echo "   sudo docker compose up -d"
