#!/bin/bash

echo "⚠️  DANGER: Complete n8n Reset"
echo "=============================="
echo ""
echo "This will:"
echo "❌ Delete all workflows"
echo "❌ Delete all credentials"
echo "❌ Delete all execution history"
echo "❌ Remove all n8n data"
echo ""
read -p "Type 'RESET' to confirm: " confirm

if [ "$confirm" != "RESET" ]; then
    echo "❌ Reset cancelled"
    exit 0
fi

echo ""
echo "💾 Creating emergency backup first..."
BACKUP_NAME="n8n_data_emergency_$(date +%Y%m%d_%H%M%S)"
sudo cp -r ~/n8n_data ~/$BACKUP_NAME
echo "✅ Emergency backup: ~/$BACKUP_NAME"

echo ""
echo "🛑 Stopping n8n..."
cd ~
sudo docker compose down

echo "🗑️  Removing all n8n data..."
sudo rm -rf ~/n8n_data
mkdir -p ~/n8n_data
sudo chown -R 1000:1000 ~/n8n_data
sudo chmod -R 755 ~/n8n_data

echo "🚀 Starting fresh n8n..."
export EXTERNAL_IP=http://"$(hostname -I | cut -f1 -d' ')"
sudo -E docker compose up -d

echo ""
echo "✅ Reset complete! Fresh n8n installation ready."
echo "📍 Access n8n at: $EXTERNAL_IP"
echo "💾 Emergency backup saved at: ~/$BACKUP_NAME"
