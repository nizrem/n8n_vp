#!/bin/bash

echo "📊 n8n Status Check"
echo "===================="

# Check if containers are running
if sudo docker ps | grep -q n8n_container; then
    echo "✅ n8n container: RUNNING"
    
    # Get n8n version
    N8N_VERSION=$(sudo docker exec n8n_container n8n --version 2>/dev/null || echo "unknown")
    echo "📦 n8n version: $N8N_VERSION"
    
    # Check ffmpeg
    if sudo docker exec n8n_container ffmpeg -version > /dev/null 2>&1; then
        FFMPEG_VERSION=$(sudo docker exec n8n_container ffmpeg -version | head -n1 | awk '{print $3}')
        echo "🎬 ffmpeg version: $FFMPEG_VERSION"
    else
        echo "❌ ffmpeg: NOT FOUND"
    fi
    
    # Get access URL
    export EXTERNAL_IP=http://"$(hostname -I | cut -f1 -d' ')"
    echo "🌐 Access URL: $EXTERNAL_IP"
else
    echo "❌ n8n container: NOT RUNNING"
fi

echo ""

# Check backup
if [ -d ~/n8n_data_backup ]; then
    BACKUP_SIZE=$(du -sh ~/n8n_data_backup | awk '{print $1}')
    BACKUP_DATE=$(stat -c %y ~/n8n_data_backup | cut -d' ' -f1,2 | cut -d'.' -f1)
    echo "💾 Backup: EXISTS (Size: $BACKUP_SIZE, Date: $BACKUP_DATE)"
else
    echo "⚠️  Backup: NOT FOUND"
fi

# Check data directory
if [ -d ~/n8n_data ]; then
    DATA_SIZE=$(du -sh ~/n8n_data | awk '{print $1}')
    echo "📂 Data directory: EXISTS (Size: $DATA_SIZE)"
else
    echo "❌ Data directory: NOT FOUND"
fi

echo ""
echo "🔧 Docker containers:"
sudo docker ps -a --filter "name=n8n_container" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
