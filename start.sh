#!/bin/bash
# WebhookNinja — Démarrage rapide
# Usage: ./start.sh

fuser -k 8000/tcp 2>/dev/null

echo "🚀 Démarrage du serveur WebhookNinja..."
python3 app.py
