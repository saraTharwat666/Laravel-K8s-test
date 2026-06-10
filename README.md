# 🚀 Laravel K8s — Monitoring Stack

A Laravel application deployed with full observability, running on Docker Compose for development and Kubernetes (minikube) for production-like environments. Supports both raw `kubectl` manifests and `Helm` charts.

---

## 📦 Stack

| Service | Description |
|---|---|
| **Laravel** | PHP 8.4 application (php-fpm) |
| **Nginx** | Web server / reverse proxy |
| **PostgreSQL 15** | Primary database |
| **Redis 7** | Cache, sessions & queues |
| **Prometheus** | Metrics collection |
| **Grafana** | Metrics visualization |
| **Uptime Kuma** | Uptime monitoring |
| **Node Exporter** | Host CPU/memory/disk metrics |
| **Postgres Exporter** | PostgreSQL metrics |
| **Redis Exporter** | Redis metrics |

---

## 📁 Project Structure

```
laravel-k8s/
├── config/
│   ├── laravel/            # Nginx configuration
│   └── prometheus/         # Prometheus configuration
├── services/
│   └── laravel/
│       ├── Dockerfile
│       └── src/            # Laravel application
├── k8s/                    # Raw Kubernetes manifests
│   ├── namespace.yaml
│   ├── secrets.yaml
│   ├── configmap.yaml
│   ├── app/                # Laravel + Nginx
│   ├── db/                 # PostgreSQL
│   ├── redis/
│   ├── monitoring/         # Prometheus, Grafana & Exporters
│   └── uptime-kuma/
├── helm/                   # Helm chart
│   └── laravel-stack/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
├── docker-compose.yml
└── .env.example
```

---

## ⚡ Quick Start

### 1. Clone & Setup

```bash
git clone <repo-url>
cd laravel-k8s
cp .env.example .env
```

### 2. Run with Docker Compose (Development)

```bash
docker compose up -d --build
docker compose exec app php artisan key:generate
docker compose exec app php artisan migrate
```

---

## ☸️ Kubernetes Deployment

### Option A — Raw Manifests (kubectl)

```bash
# Start minikube
minikube start --driver=docker

# Load Laravel image into minikube
minikube image load laravel-k8s-app:latest

# Apply manifests in order
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/secrets.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/db/
kubectl apply -f k8s/redis/
kubectl apply -f k8s/app/
kubectl apply -f k8s/monitoring/
kubectl apply -f k8s/uptime-kuma/

# Run migrations
kubectl exec -n laravel deploy/laravel -c app -- php artisan migrate
```

### Option B — Helm Chart (recommended)

```bash
# Start minikube
minikube start --driver=docker

# Load Laravel image into minikube
minikube image load laravel-k8s-app:latest

# Install with Helm
helm install laravel-stack helm/laravel-stack

# Run migrations
kubectl exec -n laravel deploy/laravel -c app -- php artisan migrate
```

#### Useful Helm commands

```bash
# تحديث بعد أي تغيير في values.yaml
helm upgrade laravel-stack helm/laravel-stack

# مسح كل حاجة
helm uninstall laravel-stack

# التحقق من الـ chart قبل التطبيق
helm lint helm/laravel-stack

# معاينة الـ templates قبل التطبيق
helm template laravel-stack helm/laravel-stack
```

---

## 🌐 Access

### Docker Compose

| Service | URL |
|---|---|
| Laravel App | http://localhost:8000 |
| Grafana | http://localhost:3000 |
| Prometheus | http://localhost:9090 |
| Uptime Kuma | http://localhost:3001 |

### Kubernetes

```bash
minikube ip
```

| Service | URL |
|---|---|
| Laravel App | http://\<minikube-ip\>:30080 |
| Grafana | http://\<minikube-ip\>:30030 |
| Prometheus | http://\<minikube-ip\>:30090 |
| Uptime Kuma | http://\<minikube-ip\>:30031 |

---

## 🔧 Useful Commands

```bash
# Check all pods
kubectl get pods -n laravel

# Check pod logs
kubectl logs -n laravel deploy/laravel -c app

# Run artisan commands
kubectl exec -n laravel deploy/laravel -c app -- php artisan <command>

# Delete everything (kubectl)
kubectl delete namespace laravel

# Delete everything (helm)
helm uninstall laravel-stack
```

---

## 📊 Monitoring

Prometheus scrapes metrics from:
- **Node Exporter** → host CPU, memory, disk
- **Postgres Exporter** → database queries, connections
- **Redis Exporter** → cache hits, memory usage

Import Grafana dashboards:
- Node Exporter: `1860`
- PostgreSQL: `9628`
- Redis: `763`

---

## ⚙️ Configuration

All configurable values are in `helm/laravel-stack/values.yaml`:

```yaml
app:
  replicas: 1       # scale up هنا
  image: laravel-k8s-app:latest

db:
  storage: 5Gi      # حجم الـ database
  password: secret  # غيري الـ password هنا بس

prometheus:
  storage: 2Gi

grafana:
  storage: 1Gi
```

---
