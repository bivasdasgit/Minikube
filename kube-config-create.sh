#!/bin/bash

set -euo pipefail

if [ $# -ne 2 ]
then
    echo "Creates System account for users with access to a specific namespace context."
    echo "Usage: $0 <namespace> <username>"
    exit 1
fi
namespace=$1
username=$2

#if kubectl get namespaces | awk '{ print $1 }' | grep $namespace
#then
#    echo "Creating $username with access to namespace $namespace context"
#else
#    echo "namespace: $namespace does NOT exist in current cluster."
#    exit 1
#fi


secretcafile=mktemp

kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ${username}
  namespace: ${namespace}
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ${namespace}-admin
  namespace: ${namespace}
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["*"]
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: admin-${username}
  namespace: ${namespace}
subjects:
- kind: ServiceAccount
  name: ${username}
  namespace: ${namespace}
roleRef:
  kind: ClusterRole
  name: ${namespace}-admin
  apiGroup: rbac.authorization.k8s.io
EOF

secret=$(kubectl get sa $username -o json -n argocd | jq -r .secrets[].name)
kubectl get secret $secret -o json -n argocd | jq -r '.data["ca.crt"]' | base64 -d > $secretcafile
user_token=$(kubectl get secret $secret -o json -n argocd | jq -r '.data["token"]' | base64 -d)
c=$(kubectl config current-context)
clustername=$(echo $c | cut -d "@" -f 2)
name=$(kubectl config get-contexts $c | awk '{print $3}' | tail -n 1)
endpoint=$(kubectl config view -o jsonpath="{.clusters[?(@.name == \"$name\")].cluster.server}")
kubectl config --kubeconfig kubeconfig-$username set-cluster ${clustername} --embed-certs=true --server=$endpoint --certificate-authority=$secretcafile
kubectl config --kubeconfig kubeconfig-$username set-credentials $username --token=$user_token
kubectl config --kubeconfig kubeconfig-$username set-context ${username}@${clustername}  --cluster=$clustername --user=$username

rm -f $secretcafile
echo "Send file ./kubeconfig-$username to your user"
