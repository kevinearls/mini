set -x

make docker-build

env | sort
kubectl create namespace example
# DON'T forget docker push  or do I need that?
# Try building and creating with a SHA


# Will we need to push this?
export BUILD_IMAGE=kevinearls/simplehttp:${GITHUB_SHA}
kubectl create --namespace example deployment httpexample --image=${BUILD_IMAGE}
kubectl wait --for=condition=available deployment/httpexample --namespace example --timeout=60s

kubectl expose --namespace example deployment httpexample --type=LoadBalancer --port 8080
kubectl get svc -n example  # <-- check output to figure out what port to use

#### TODO wait for things to be ready!


export EXAMPLE_PORT=$(kubectl get svc httpexample --namespace example | grep 8080 | sed 's/^.*8080://g' | sed 's@/TCP.*@@g')
export MINIKUBE_IP=$(minikube ip)

curl ${MINIKUBE_IP}:${EXAMPLE_PORT}/something
curl ${MINIKUBE_IP}:${EXAMPLE_PORT}/nothing