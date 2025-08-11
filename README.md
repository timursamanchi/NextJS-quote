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
