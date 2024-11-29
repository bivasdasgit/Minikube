curl -LO https://dl.k8s.io/release/v1.22.5/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo apt-get update && \
sudo apt install nfs-common
sudo apt-get install docker.io jq -y
sudo systemctl start docker 
curl -LO https://github.com/kubernetes/minikube/releases/download/v1.22.0/minikube-linux-amd64
mv minikube-linux-amd64 minikube
chmod +x minikube
sudo mv minikube /usr/local/bin/
minikube version
sudo apt install conntrack
sysctl net.ipv6.conf.all.disable_ipv6=0
curl -LO https://get.helm.sh/helm-v3.10.0-linux-amd64.tar.gz
tar -xvzf helm-v3.10.0-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm

#sudo minikube start --vm-driver=none --apiserver-ips=<IP1>,<IP2>
sudo minikube start --vm-driver=none 
minikube addons enable ingress

#sudo minikube start \
#       --vm-driver=none \
#       --extra-config=apiserver.authorization-mode=Node,RBAC \
#       --extra-config=apiserver.oidc-issuer-url=https://keycloak.das.quest/realms/local/ \
#       --extra-config=apiserver.oidc-client-id=gatekeeper \
#       --extra-config=apiserver.oidc-username-claim=name \
#       --extra-config=apiserver.groups-claim=groups
#       --extra-config=apiserver.oidc-ca-file=/home/ubuntu/minikube/kubernetes_oidc_oauth/tls.crt
# install nfs-server provisoner
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=<ADD Server> \
    --set nfs.path=/mnt/myshareddir
