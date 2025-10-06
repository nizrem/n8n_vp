#!/bin/bash

echo "🚀 Starting n8n + FFmpeg update with backup..."

# -----------------------------
# 1️⃣ Создание резервной копии данных
# -----------------------------
BACKUP_DIR=~/n8n_backups
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
mkdir -p "$BACKUP_DIR"

echo "💾 Creating backup of n8n data..."
cp -r ~/n8n_data "$BACKUP_DIR/n8n_data_backup_$TIMESTAMP"
echo "✅ Backup created at $BACKUP_DIR/n8n_data_backup_$TIMESTAMP"

# -----------------------------
# 2️⃣ Остановка контейнера
# -----------------------------
echo "🟢 Stopping n8n container..."
docker compose down
echo "🔴 n8n stopped"

# -----------------------------
# 3️⃣ Обновление Docker-образа n8n
# -----------------------------
echo "🐳 Pulling latest n8n image..."
docker pull n8nio/n8n:latest
echo "✅ Latest n8n image pulled"

# -----------------------------
# 4️⃣ Пересборка контейнера с FFmpeg
# -----------------------------
echo "🔨 Rebuilding n8n + FFmpeg container..."
docker compose build --no-cache
echo "✅ Container rebuilt with latest n8n and FFmpeg"

# -----------------------------
# 5️⃣ Запуск контейнера
# -----------------------------
echo "▶️ Starting n8n container..."
docker compose up -d
echo "🎉 n8n + FFmpeg update complete!"

# -----------------------------
# 6️⃣ Проверка версий
# -----------------------------
echo "💡 Checking n8n and FFmpeg versions..."
docker exec -it n8n_container n8n --version
docker exec -it n8n_container ffmpeg -version

echo "✅ Update finished. Backup is stored at $BACKUP_DIR/n8n_data_backup_$TIMESTAMP"
