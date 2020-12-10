#!/usr/bin/env bash
# exit immediately when a command fails
set -e
# only exit with zero if all commands of the pipeline exit successfully
set -o pipefail
# error on unset variables
set -u
# print each command before executing it
set -x

minikube status

MINIKUBE=$(which minikube) # it's outside of the regular PATH, so, need the full path when calling with sudo

# waiting for node(s) to be ready
JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'; until kubectl get nodes -o jsonpath="$JSONPATH" 2>&1 | grep -q "Ready=True"; do sleep 1; done

# waiting for kube-dns to be ready
export COREDNSPODS=$(kubectl --namespace kube-system get pods -lk8s-app=kube-dns | grep coredns | awk '{print $1}')
for POD in ${COREDNSPODS}
do
    kubectl wait --for=condition=Ready pod/${POD}  --namespace kube-system --timeout=60s
done
sudo ${MINIKUBE} addons enable ingress

eval $(minikube docker-env)
