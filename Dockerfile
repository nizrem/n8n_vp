# Используем официальный n8n образ
FROM n8nio/n8n:latest

USER root

# Устанавливаем FFmpeg
RUN apt update && apt install -y ffmpeg && \
    apt clean && rm -rf /var/lib/apt/lists/*

USER node
