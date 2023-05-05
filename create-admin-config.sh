#!/bin/bash
set -euo pipefail

if [ $# -ne 2 ]
then
    echo "Creates readonly account for users with access to a specific namespace ONLY."
    echo "Usage: $0 <namespace> <username>"
    exit 1
fi
namespace=$1
username=$2

if kubectl get namespaces | awk '{ print $1 }' | grep $namespace
then
    echo "Creating $username with access to namespace $namespace"
else
    echo "namespace: $namespace does NOT exist in current cluster."
    exit 1
fi

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
  name: ${username}
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["*"]
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ${username}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ${username}
subjects:
- kind: ServiceAccount
  name: ${username}
  namespace: $namespace
EOF

export SECRET=$(kubectl get sa $username -o json -n kube-system | jq -r .secrets[].name)
export SA_SECRET_TOKEN=$(kubectl -n kube-system get secret/$SECRET -o=go-template='{{.data.token}}' | base64 --decode)
export CLUSTER_CA_CERT=$(kubectl get secret $SECRET -o json -n kube-system | jq -r '.data["ca.crt"]')
export CLUSTER_NAME=$(kubectl config current-context)
export CURRENT_CLUSTER=$(kubectl config view --raw -o=go-template='{{range .contexts}}{{if eq .name "'''${CLUSTER_NAME}'''"}}{{ index .context "cluster" }}{{end}}{{end}}')
export CLUSTER_ENDPOINT=$(kubectl config view --raw -o=go-template='{{range .clusters}}{{if eq .name "'''${CURRENT_CLUSTER}'''"}}{{ .cluster.server }}{{end}}{{ end }}')

cat << EOF > devops-cluster-admin-config
apiVersion: v1
kind: Config
current-context: ${CLUSTER_NAME}
contexts:
- name: ${CLUSTER_NAME}
  context:
    cluster: ${CLUSTER_NAME}
    user: devops-cluster-admin
clusters:
- name: ${CLUSTER_NAME}
  cluster:
    certificate-authority-data: ${CLUSTER_CA_CERT}
    server: ${CLUSTER_ENDPOINT}
users:
- name: devops-cluster-admin
  user:
    token: ${SA_SECRET_TOKEN}
EOF

echo "Kube-config file is generated"
