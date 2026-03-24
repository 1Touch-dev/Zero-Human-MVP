#!/usr/bin/env bash

# sync_to_runpod.sh
# -----------------------------------------------------------------------------
# Zero-Human MVP Synchronization Utility
# -----------------------------------------------------------------------------
# This script continuously or manually pushes all local architecture modifications
# (Python Bridges, SQL Schemas, Webhooks, Docs) securely to your remote RunPod.
# 
# Usage:
#   ./sync_to_runpod.sh          # One-time manual sync
#   ./sync_to_runpod.sh --watch  # Continuous syncing on file change (requires fswatch)
# -----------------------------------------------------------------------------

# Configuration (Replace with your exact RunPod details, optionally via .env)
RUNPOD_USER="root"
RUNPOD_IP="194.68.245.210"
RUNPOD_PORT="22168"
REMOTE_DIR="/home/paperclip/Zero-Human-MVP"
LOCAL_DIR="$(pwd)"

echo "🚀 Zero-Human MVP: Initializing Sync to RunPod ($RUNPOD_IP:$RUNPOD_PORT)..."

sync_files() {
    echo "[$(date +'%T')] Synchronizing Workspace to RunPod..."
    
    # Exclude internal IDE directories, git histories, and caches to save bandwidth
    rsync -avz --delete \
        -e "ssh -p $RUNPOD_PORT -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no" \
        --exclude '.git/' \
        --exclude '.gemini/' \
        --exclude '__pycache__/' \
        --exclude '.DS_Store' \
        "$LOCAL_DIR/" "$RUNPOD_USER@$RUNPOD_IP:$REMOTE_DIR"
        
    if [ $? -eq 0 ]; then
        echo "✅ Sync Successful."
    else
        echo "❌ Sync Failed. Check SSH connection."
    fi
}

# Execution Logic
if [ "$1" == "--watch" ]; then
    if ! command -v fswatch &> /dev/null; then
        echo "fswatch could not be found. Please install it to use --watch (e.g., brew install fswatch)"
        exit 1
    fi
    echo "👀 Starting continuous watch on $LOCAL_DIR..."
    sync_files # Initial Sync before watching
    fswatch -o "$LOCAL_DIR" | while read num ; do
        sync_files
    done
else
    sync_files
fi
