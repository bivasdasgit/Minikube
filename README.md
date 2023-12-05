# minikube

# Execute ClusterRole Admin Config
```
./create-admin-config.sh kube-system devops-cluster-admin
```
```
kubectl get secret devops-cluster-admin-token-25gnk -n kube-system -o jsonpath="{['data']['ca\.crt']}" | base64 --decode
```
