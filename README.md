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