#!/bin/bash

echo "🧹 n8n Cleanup Utility"
echo "====================="
echo ""
echo "⚠️  WARNING: This will clean up Docker resources"
echo ""
read -p "Continue? (y/n): " confirm

if [ "$confirm" != "y" ]; then
    echo "❌ Cleanup cancelled"
    exit 0
fi

echo ""
echo "🗑️  Removing unused Docker images..."
sudo docker image prune -af

echo "🗑️  Removing unused Docker volumes..."
sudo docker volume prune -f

echo "🗑️  Removing unused Docker networks..."
sudo docker network prune -f

echo "🗑️  Removing old backup (if exists)..."
if [ -d ~/n8n_data_backup ]; then
    BACKUP_SIZE=$(du -sh ~/n8n_data_backup | awk '{print $1}')
    read -p "Remove backup ($BACKUP_SIZE)? (y/n): " remove_backup
    if [ "$remove_backup" = "y" ]; then
        sudo rm -rf ~/n8n_data_backup
        echo "✅ Backup removed"
    fi
fi

# Show disk usage
echo ""
echo "💾 Disk usage after cleanup:"
df -h / | grep -v Filesystem
echo ""
echo "🐳 Docker disk usage:"
sudo docker system df

echo ""
echo "✅ Cleanup complete!"
