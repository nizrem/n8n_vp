#!/bin/bash

echo "💾 Creating manual n8n backup..."

if [ ! -d ~/n8n_data ]; then
    echo "❌ Error: n8n data directory not found!"
    exit 1
fi

# Create backup with timestamp
BACKUP_NAME="n8n_data_manual_$(date +%Y%m%d_%H%M%S)"
echo "📦 Backing up to ~/$BACKUP_NAME..."

sudo cp -r ~/n8n_data ~/$BACKUP_NAME
BACKUP_SIZE=$(du -sh ~/$BACKUP_NAME | awk '{print $1}')

echo "✅ Backup created successfully!"
echo "📂 Location: ~/$BACKUP_NAME"
echo "💾 Size: $BACKUP_SIZE"
echo ""
echo "To restore this backup:"
echo "sudo docker compose down"
echo "sudo rm -rf ~/n8n_data"
echo "sudo cp -r ~/$BACKUP_NAME ~/n8n_data"
echo "sudo docker compose up -d"
