# Minikube:

Step 1:

```
dnf update -y
dnf install 'dnf-command(config-manager)'
yum install 'dnf-command(config-manager)'
```
Step 2: Install Docker
```
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install docker-ce --nobest -y
```
Step 3:
```
systemctl start docker
systemctl enable docker
docker -v
```
Step 4:

Install Kubectl tool
```
dnf install curl conntrack -y
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
kubectl version --client --short
```
Step 5: Install Minikube
```
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
install minikube /usr/local/bin/
minikube start --driver=none
minikube status
```
Step 6: Cluster Details
```
kubectl cluster-info
kubectl get nodes
```
