#!/bin/bash
set -e
read -p "Enter the hostname for this node (e.g., k8s-master, k8s-worker1): " HOSTNAME
sudo hostnamectl set-hostname $HOSTNAME
echo "[INFO] Adding host entries"
cat <<EOF | sudo tee -a /etc/hosts
192.168.19.23 k8s-master
192.168.19.25 k8s-worker1
EOF
echo "[INFO] Disabling swap"
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
echo "[INFO] Enabling required kernel modules"
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
echo "[INFO] Applying sysctl settings"
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system
echo "[INFO] Installing containerd"
sudo apt update && sudo apt install -y containerd
echo "[INFO] Configuring containerd"
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo systemctl restart containerd
sudo systemctl enable containerd
echo "[INFO] Adding Kubernetes APT repository..."
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
echo "[DONE] Common setup completed on $HOSTNAME"
