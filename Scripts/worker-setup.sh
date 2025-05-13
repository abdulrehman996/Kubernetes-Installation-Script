#!/bin/bash
set -e
read -p "Paste the kubeadm join command from master here: " JOIN_COMMAND
echo "[INFO] Joining cluster..."
sudo $JOIN_COMMAND
echo "[SUCCESS] Worker node joined the cluster."
