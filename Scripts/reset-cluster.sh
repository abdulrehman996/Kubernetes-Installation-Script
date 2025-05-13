#!/bin/bash
set -e
echo "[INFO] Resetting kubeadm"
sudo kubeadm reset -f
echo "[INFO] Removing Kubernetes packages"
sudo apt purge -y kubeadm kubelet kubectl containerd
sudo apt autoremove -y
sudo rm -rf ~/.kube /etc/kubernetes /var/lib/etcd /etc/containerd /etc/cni /opt/cni
echo "[INFO] Enabling swap"
sudo sed -i '/ swap / s/^#//' /etc/fstab
sudo swapon -a
echo "[INFO] Reverting hostname (optional)"
read -p "Reset hostname to default (ubuntu)? (y/n): " CONFIRM
if [ "$CONFIRM" == "y" ]; then
  sudo hostnamectl set-hostname ubuntu
fi
echo "[DONE] Node cleaned up."
