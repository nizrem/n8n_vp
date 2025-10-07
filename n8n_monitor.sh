#!/bin/bash

echo "🔍 Setting up n8n monitoring..."

# Create monitoring script
cat > ~/n8n_health_check.sh << 'EOF'
#!/bin/bash
if ! sudo docker ps | grep -q n8n_container; then
    echo "$(date): n8n container is down. Restarting..." >> ~/n8n_monitor.log
    cd ~
    export EXTERNAL_IP=http://"$(hostname -I | cut -f1 -d' ')"
    sudo -E docker compose up -d
fi
EOF

chmod +x ~/n8n_health_check.sh

# Add to crontab (check every 5 minutes)
(crontab -l 2>/dev/null; echo "*/5 * * * * ~/n8n_health_check.sh") | crontab -

echo "✅ Monitoring enabled! n8n will auto-restart if it crashes."
echo "📝 Logs: ~/n8n_monitor.log"
echo ""
echo "To disable monitoring:"
echo "crontab -e  # and remove the n8n_health_check.sh line"
