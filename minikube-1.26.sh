curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
apt install docker.io -y
minikube config set driver docker
minikube start --driver=docker --force
curl -LO https://dl.k8s.io/release/v1.26.3/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
curl -LO https://get.helm.sh/helm-v3.10.0-linux-amd64.tar.gz
tar -xvzf helm-v3.10.0-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
