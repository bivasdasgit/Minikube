curl -LO https://dl.k8s.io/release/v1.22.5/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo apt-get update && \
sudo apt-get install docker.io -y
sudo systemctl start docker 
curl -LO https://github.com/kubernetes/minikube/releases/download/v1.22.0/minikube-linux-amd64
mv minikube-linux-amd64 minikube
chmod +x minikube
sudo mv minikube /usr/local/bin/
minikube version
sudo apt install conntrack
curl -LO https://get.helm.sh/helm-v3.10.0-linux-amd64.tar.gz
tar -xvzf helm-v3.10.0-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm

sudo minikube start --vm-driver=none
