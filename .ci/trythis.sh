set -x
set -e

#export BUILD_IMAGE=kevinearls/simplehttp:${GITHUB_SHA}
#make docker-build
#docker images

# github builder uses main by default -- see how to change this
export BUILD_IMAGE=kevinearls/httpexample:main

env | sort
kubectl create namespace example

kubectl create --namespace example deployment httpexample --image=${BUILD_IMAGE}
kubectl wait --for=condition=available deployment/httpexample --namespace example --timeout=60s

kubectl expose --namespace example deployment httpexample --type=LoadBalancer --port 8080
kubectl get svc -n example  # <-- check output to figure out what port to use

#### TODO wait for things to be ready!

export EXAMPLE_PORT=$(kubectl get svc httpexample --namespace example | grep 8080 | sed 's/^.*8080://g' | sed 's@/TCP.*@@g')
export MINIKUBE_IP=$(minikube ip)

curl ${MINIKUBE_IP}:${EXAMPLE_PORT}/something
curl ${MINIKUBE_IP}:${EXAMPLE_PORT}/nothing