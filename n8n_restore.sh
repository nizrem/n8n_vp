#!/bin/bash

echo "🔄 Starting n8n restore from backup..."

# Check if backup exists
if [ ! -d ~/n8n_data_backup ]; then
    echo "❌ Error: Backup not found at ~/n8n_data_backup"
    echo "ℹ️  No backup available to restore from."
    exit 1
fi

cd ~

# Stop containers
echo "🛑 Stopping n8n container..."
sudo docker compose down

# Remove current data
echo "🗑️  Removing current n8n data..."
if [ -d ~/n8n_data ]; then
    sudo rm -rf ~/n8n_data
    echo "✅ Current data removed"
fi

# Restore from backup
echo "📦 Restoring from backup..."
sudo cp -r ~/n8n_data_backup ~/n8n_data
sudo chown -R 1000:1000 ~/n8n_data
sudo chmod -R 755 ~/n8n_data
echo "✅ Data restored from backup"

# Start containers
echo "🚀 Starting n8n container..."
export EXTERNAL_IP=http://"$(hostname -I | cut -f1 -d' ')"
sudo -E docker compose up -d

# Wait for container to start
echo "⏳ Waiting for container to start..."
sleep 10

echo ""
echo "🎉 Restore complete!"
echo "📍 Access n8n at: $EXTERNAL_IP"
echo "✅ n8n has been restored to the state from the last backup"
