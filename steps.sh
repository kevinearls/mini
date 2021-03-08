docker build . -t kevinearls/simplehttp:latest
kubectl create namespace example
# DON'T forget docker push
kubectl create --namespace example deployment httpexample --image=kevinearls/simplehttp:latest
kubectl expose --namespace example deployment httpexample --type=LoadBalancer --port 8080
kubectl get svc -n example  # <-- check output to figure out what port to use
