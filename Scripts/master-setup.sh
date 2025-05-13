#!/bin/bash
set -e
echo "[INFO] Initializing Kubernetes master"
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 | tee kubeadm-init.log
echo "[INFO] Setting up kubectl for regular user"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
echo "[INFO] Applying Calico network plugin"
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
echo "[INFO] Saving join command to join-worker.sh"
kubeadm token create --print-join-command | tee join-worker.sh
chmod +x join-worker.sh
echo "[SUCCESS] Master setup complete. Use ./join-worker.sh on workers."
