#!/bin/bash

# Update system packages
sudo apt-get update  && sudo apt-get upgrade -y


# Install transport layer
sudo apt-get install -y apt-transport-https curl

# change the hostname
sudo hostnamectl set-hostname worker-node

# Add Kubernetes apt repository key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add Kubernetes apt repository
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update system packages again
sudo apt-get update

# Install and configure the CRI-O container runtime

sudo -i
export OS=xUbuntu_20.04
export VERSION=1.22

echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list

echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list

curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | apt-key add -

curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | apt-key add -

exit

sudo apt update -y
sudo apt install cri-o cri-o-runc -y


sudo systemctl daemon-reload
sudo systemctl enable crio --now

# Turn off swap
swapoff -a

# sysctl settings and ip tables
sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# Install kubeadm
sudo apt-get install -qy kubelet=1.28.0-00 kubectl=1.28.0-00 kubeadm=1.28.0-00

# Install network plugin (optional, you can choose your own)
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Enable shell autocompletion for bash
sudo apt install bash-completion
source /usr/share/bash-completion/bash_completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
source ~/.bashrc