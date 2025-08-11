# next.js
quote app in next.js frontend

## 1️⃣ Start Redis with Preloaded Quotes
```
docker run -d \
  --name quote-redis \
  --network quote-net \
  -v quote-redis_data:/data \
  quote-redis:abc
```

## 2️⃣ Start Backend
```
docker run -d \
  --name quote-backend \
  --network quote-net \
  -p 8080:8080 \
  quote-backend:abc
```

## 3️⃣ Start Frontend
```
docker run -d \
  --name quote-frontend \
  --network quote-net \
  -p 80:80 \
  quote-frontend:abc
```

docker build --no-cache -t quote-redis:abc ./quote-redis 
docker build --no-cache -t quote-backend:abc ./quote-backend 
docker build --no-cache -t quote-frontend:abc ./quote-frontend



# What’s there?
kubectl get all -n quote-app

# Describe the Deployment + Service
kubectl describe deploy/quote-redis -n quote-app
kubectl describe svc/quote-redis -n quote-app

# Pod details/logs
kubectl get pods -n quote-app -o wide
kubectl describe pod/<pod-name> -n quote-app
kubectl logs <pod-name> -n quote-app

# Endpoints wired up?
kubectl get endpoints quote-redis -n quote-app
kubectl describe endpoints/quote-redis -n quote-app

# PVC/PV info
kubectl describe pvc/redis-data -n quote-app
kubectl get pv | grep redis


Easiest way on Minikube: use the built-in addon.

# enable it
minikube addons enable metrics-server

# confirm it's up
kubectl -n kube-system rollout status deploy/metrics-server
kubectl get apiservices | grep metrics

# quick sanity checks
kubectl top nodes
kubectl top pods -A




# 1️⃣ Clean up any leftover release & namespace from old attempts
helm uninstall quote-app -n quote-app || true
kubectl delete ns quote-app --wait || true

# 2️⃣ Deploy fresh with Helm
helm upgrade --install quote-app ./quote-app \
  --namespace quote-app \
  --create-namespace

# 3️⃣ Watch pod startup
kubectl get pods -n quote-app -w


Since it’s up, do a super‑quick sanity sweep:

# 1) PVC actually bound?
kubectl -n quote-app get pvc,pv

# 2) Service wired up?
kubectl -n quote-app get svc
kubectl -n quote-app describe svc quote-app-redis

# 3) Volume mounted in the pod?
POD=$(kubectl -n quote-app get pod -l app.kubernetes.io/name=redis -o jsonpath='{.items[0].metadata.name}')
kubectl -n quote-app exec -it "$POD" -- sh -lc 'df -h /data && ls -al /data'

# 4) Can we PING Redis from inside the cluster?
kubectl -n quote-app run redis-tester --rm -it --restart=Never --image=redis:7-alpine -- \
  sh -lc "redis-cli -h quote-app-redis PING"
# expect: PONG
