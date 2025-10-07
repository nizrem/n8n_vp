#!/bin/bash

echo "📋 n8n Logs Viewer"
echo "=================="
echo ""
echo "Choose an option:"
echo "1) View live logs (Ctrl+C to exit)"
echo "2) View last 50 lines"
echo "3) View last 100 lines"
echo "4) Search logs for error"
echo "5) Export logs to file"
echo ""
read -p "Enter option (1-5): " option

case $option in
    1)
        echo "📺 Showing live logs (Ctrl+C to stop)..."
        sudo docker logs -f n8n_container
        ;;
    2)
        echo "📄 Last 50 lines:"
        sudo docker logs --tail 50 n8n_container
        ;;
    3)
        echo "📄 Last 100 lines:"
        sudo docker logs --tail 100 n8n_container
        ;;
    4)
        echo "🔍 Searching for errors..."
        sudo docker logs n8n_container 2>&1 | grep -i "error"
        ;;
    5)
        FILENAME="n8n_logs_$(date +%Y%m%d_%H%M%S).txt"
        sudo docker logs n8n_container > ~/$FILENAME 2>&1
        echo "✅ Logs exported to: ~/$FILENAME"
        ;;
    *)
        echo "❌ Invalid option"
        ;;
esac
