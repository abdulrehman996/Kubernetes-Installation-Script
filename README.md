# Kubernetes Cluster Setup with Kubeadm

This repository provides a structured way to set up a Kubernetes cluster using `kubeadm`, `containerd` as the container runtime, and `Calico` as the CNI plugin. Scripts are provided to automate setup across both master and worker nodes.

---

## 🚀 Goal

- 1 Master Node
- 1 or More Worker Nodes
- Container Runtime: `containerd`
- CNI Plugin: `Calico`
- Private LAN Network: `192.168.19.x`

---

## 🧰 Prerequisites

Before starting, ensure the following:

- All machines run **Ubuntu 20.04 or 22.04**
- All nodes are on the same subnet (e.g., `192.168.19.0/24`)
- Each node has:
  - Minimum 2 CPUs
  - At least 2GB RAM
  - Static or DHCP-reserved IP address
- Root or sudo access
- Internet access

---

## 📁 Directory Structure

```
kubeadm-cluster-setup/
│
├── scripts/
│   ├── common-setup.sh       # Run on ALL nodes
│   ├── master-setup.sh       # Run on the master node
│   ├── worker-setup.sh       # Run on each worker node
│   └── reset-cluster.sh      # Optional: Use to reset and clean up
│
└── README.md                 # This file
```

---

## 🛠️ Setup Instructions

### Step 1: Common Setup (All Nodes)

Run this on **every node** (master and workers):

```bash
bash scripts/common-setup.sh
```

- You will be prompted to enter a hostname for the node.
- This script sets the hostname, updates `/etc/hosts`, disables swap, installs containerd, configures kernel modules, and installs Kubernetes components.

---

### Step 2: Master Node Setup

Run this on the **master node** only:

```bash
bash scripts/master-setup.sh
```

This script will:
- Initialize the Kubernetes master with a specific Pod CIDR
- Configure `kubectl` for the local user
- Apply the Calico network plugin
- Generate and save a `join-worker.sh` script containing the `kubeadm join` command

---

### Step 3: Worker Node Setup

On each **worker node**, run:

```bash
bash scripts/worker-setup.sh
```

You’ll be prompted to paste the join command copied from the master node’s `join-worker.sh` script.

---

### Step 4: Verify the Cluster

On the master node:

```bash
kubectl get nodes
kubectl get pods -n kube-system
```

You should see your master and worker nodes in a `Ready` state.

---

### Step 5: Deploy a Sample App (Optional)

```bash
kubectl create deployment nginx-demo --image=nginx
kubectl expose deployment nginx-demo --port=80 --type=NodePort
kubectl get svc
```

Access the app from your browser:

```
http://<node-ip>:<nodePort>
```

---

## 🪥 Optional: Reset / Cleanup Script

If you need to reset the cluster setup:

```bash
bash scripts/reset-cluster.sh
```

This will reset `kubeadm`, remove packages and configurations, and optionally revert the hostname.

---

## 🔐 Notes

- Use **static IPs** or **DHCP reservations** to avoid cluster instability.
- Protect `kubeconfig` files and tokens.
- For production, implement RBAC and avoid giving full cluster-admin access to service accounts.
- You can extend this setup by adding Ingress, Helm, monitoring, logging, etc.

---

## 📃 License

This project is open-source and free to use.

---

## 🤝 Contributions

Pull requests are welcome. Suggestions to improve or secure the setup are appreciated!
