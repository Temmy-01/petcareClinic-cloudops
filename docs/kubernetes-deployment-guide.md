# Spring PetClinic — Kubernetes Deployment Guide

**Author:** Kubernetes Engineer  
**Cluster:** AWS EKS (`petclinic-eks-prod`, `us-east-1`)  
**Date:** May 8, 2026
---

## Overview

This document covers how to deploy, test, and validate the Spring PetClinic Microservices application on AWS EKS using Helm. It is intended for standup demonstrations and team handoffs.

The application consists of 11 services deployed to a dedicated `petclinic` namespace on a 3-node EKS cluster.

---

## Architecture

```
Internet
    │
    ▼
Nginx Ingress Controller
    │
    ▼
api-gateway (port 8080)
    │
    ├── customers-service (port 8081)
    ├── visits-service    (port 8082)
    ├── vets-service      (port 8083)
    └── genai-service     (port 8084)

Bootstrap Services (start first):
    config-server    (port 8888) — centralised configuration
    discovery-server (port 8761) — Eureka service registry

Observability:
    admin-server  (port 9090) — Spring Boot Admin
    zipkin        (port 9411) — distributed tracing
    prometheus    (port 9090) — metrics scraping
    grafana       (port 3000) — metrics dashboards
```

**Startup order is enforced via init containers:**
1. `config-server` starts first (no dependencies)
2. `discovery-server` waits for `config-server`
3. All other services wait for both `config-server` and `discovery-server`

---

## Prerequisites

| Tool | Version | Check |
|---|---|---|
| AWS CLI | v2 | `aws --version` |
| kubectl | any | `kubectl version` |
| Helm | ≥ 3.12 | `helm version` |
| Terraform | ≥ 1.0 | `terraform --version` |

---

## Infrastructure Setup (One-Time)

### 1. Configure AWS credentials

```bash
aws configure
# Enter: Access Key ID, Secret Access Key, region: us-east-1, format: json
```

Verify:
```bash
aws sts get-caller-identity
```

### 2. Create Terraform state storage (first time only)

```bash
aws s3api create-bucket \
  --bucket petclinic1234-tfstate-268015775379 \
  --region us-east-1

aws s3api put-bucket-versioning \
  --bucket petclinic1234-tfstate-268015775379 \
  --versioning-configuration Status=Enabled

aws dynamodb create-table \
  --table-name petclinic-tfstate-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

### 3. Provision infrastructure with Terraform

```bash
cd terraform/aws
terraform init
terraform apply -var='mysql_password=PetClinic123!'
```

Takes approximately 15 minutes. Note the outputs:

```
eks_cluster_name = "petclinic-eks-prod"
ecr_registry_url = "268015775379.dkr.ecr.us-east-1.amazonaws.com"
rds_endpoint     = "petclinic-mysql-prod.xxxx.us-east-1.rds.amazonaws.com:3306"
```

### 4. Connect kubectl to the cluster

```bash
aws eks update-kubeconfig --name petclinic-eks-prod --region us-east-1
```

Verify:
```bash
kubectl get nodes
```

Expected output — 3 nodes with status `Ready`:
```
NAME                          STATUS   ROLES    AGE   VERSION
ip-10-0-10-151.ec2.internal   Ready    <none>   ...   v1.32.x
ip-10-0-10-156.ec2.internal   Ready    <none>   ...   v1.32.x
ip-10-0-11-229.ec2.internal   Ready    <none>   ...   v1.32.x
```

### 5. Install Nginx Ingress Controller

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace
```

Verify:
```bash
kubectl get pods -n ingress-nginx
# Expected: ingress-nginx-controller pod in Running state
```

---

## Deploying the Application

### Option A — Using public Docker Hub images (for testing/demo)

Use this when ECR images have not been pushed yet.

```bash
cd <project-root>
helm dependency update ./helm

kubectl create namespace petclinic

helm install petclinic ./helm \
  --namespace petclinic \
  --set global.imageRegistry="" \
  --set global.imageTag=latest \
  --set config-server.image.repository=springcommunity/spring-petclinic-config-server \
  --set discovery-server.image.repository=springcommunity/spring-petclinic-discovery-server \
  --set api-gateway.image.repository=springcommunity/spring-petclinic-api-gateway \
  --set customers-service.image.repository=springcommunity/spring-petclinic-customers-service \
  --set visits-service.image.repository=springcommunity/spring-petclinic-visits-service \
  --set vets-service.image.repository=springcommunity/spring-petclinic-vets-service \
  --set genai-service.image.repository=springcommunity/spring-petclinic-genai-service \
  --set admin-server.image.repository=springcommunity/spring-petclinic-admin-server \
  --set prometheus.image.repository=prom/prometheus \
  --set prometheus.image.tag=latest \
  --set grafana.image.repository=grafana/grafana \
  --set grafana.image.tag=latest \
  --set genai-service.genaiSecret.openaiApiKey=dummy
```

### Option B — Using AWS ECR images (production flow)

Use this when the Container Engineer has pushed images to ECR.

**Step 1 — Authenticate Docker to ECR:**
```bash
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin \
  268015775379.dkr.ecr.us-east-1.amazonaws.com
```

**Step 2 — Deploy with Helm:**
```bash
helm install petclinic ./helm \
  --namespace petclinic \
  --set global.imageRegistry=268015775379.dkr.ecr.us-east-1.amazonaws.com \
  --set global.imageTag=latest \
  --set prometheus.image.repository=prom/prometheus \
  --set prometheus.image.tag=latest \
  --set grafana.image.repository=grafana/grafana \
  --set grafana.image.tag=latest \
  --set genai-service.genaiSecret.openaiApiKey=<your-openai-key>
```

---

## Accessing the Application

Once all pods are running, get the public URL:

```bash
kubectl get ingress -n petclinic
```

Output:
```
NAME          CLASS   HOSTS   ADDRESS                                                    PORTS   AGE
api-gateway   nginx   *       a1b2c3d4.us-east-1.elb.amazonaws.com                      80      5m
```

The `ADDRESS` column is your public URL. Open it in a browser:

```
http://a1b2c3d4.us-east-1.elb.amazonaws.com
```

This is the PetClinic frontend — you can browse owners, pets, vets, and use the AI chatbot.

> Note: It may take 2-3 minutes after deployment for the ELB DNS to propagate. If the address is empty, wait a moment and run the command again.

---

## Validating the Deployment

### 1. Check all pods are running

```bash
kubectl get pods -n petclinic
```

Expected — all pods in `Running` state with `1/1` READY:

```
NAME                               READY   STATUS    RESTARTS   AGE
admin-server-xxx                   1/1     Running   0          5m
api-gateway-xxx                    1/1     Running   0          5m
config-server-xxx                  1/1     Running   0          5m
customers-service-xxx              1/1     Running   0          5m
discovery-server-xxx               1/1     Running   0          5m
genai-service-xxx                  1/1     Running   0          5m
grafana-xxx                        1/1     Running   0          5m
prometheus-xxx                     1/1     Running   0          5m
vets-service-xxx                   1/1     Running   0          5m
visits-service-xxx                 1/1     Running   0          5m
zipkin-xxx                         1/1     Running   0          5m
```

### 2. Check Eureka — all services registered

```bash
kubectl port-forward -n petclinic svc/discovery-server 8761:8761
```

Open in browser: **http://localhost:8761**

You should see all 8 microservices listed as `UP`.

### 3. Smoke test the API via api-gateway

```bash
kubectl port-forward -n petclinic svc/api-gateway 8080:8080
```

In a new terminal:

```bash
# List all vets
curl http://localhost:8080/api/vet/vets

# List all owners
curl http://localhost:8080/api/customer/owners
```

Both should return HTTP 200 with JSON data.

### 4. Check Grafana dashboards

```bash
kubectl port-forward -n petclinic svc/grafana 3000:3000
```

Open in browser: **http://localhost:3000**

The Spring PetClinic Metrics dashboard should be pre-loaded with JVM and application metrics.

### 5. Check Zipkin tracing

```bash
kubectl port-forward -n petclinic svc/zipkin 9411:9411
```

Open in browser: **http://localhost:9411/zipkin/**

Make a few API calls through the gateway, then search for traces to see the full request flow across services.

### 6. Check Spring Boot Admin

```bash
kubectl port-forward -n petclinic svc/admin-server 9090:9090
```

Open in browser: **http://localhost:9090**

All registered services should show as `UP` with health details.

---

## Upgrading the Deployment

When new images are pushed to ECR or configuration changes:

```bash
helm upgrade petclinic ./helm \
  --namespace petclinic \
  --reuse-values \
  --set global.imageTag=<new-tag>
```

---

## Tearing Down

### Remove the Helm release

```bash
helm uninstall petclinic --namespace petclinic
kubectl delete namespace petclinic
```

### Destroy all AWS infrastructure

```bash
cd terraform/aws
terraform destroy -var='mysql_password=PetClinic123!'
```

### Remove state storage (final cleanup)

```bash
aws s3 rm s3://petclinic1234-tfstate-268015775379 --recursive
aws s3api delete-bucket \
  --bucket petclinic1234-tfstate-268015775379 \
  --region us-east-1

aws dynamodb delete-table \
  --table-name petclinic-tfstate-lock \
  --region us-east-1
```

---

## Troubleshooting

### Pods stuck in `Init:0/1` or `Init:0/2`

Init containers are waiting for `config-server` or `discovery-server`. Check:

```bash
kubectl logs -n petclinic <pod-name> -c wait-for-config-server
kubectl logs -n petclinic deploy/config-server
```

### Pods in `ImagePullBackOff`

Image not found in registry. Check:

```bash
kubectl describe pod -n petclinic <pod-name> | grep -A 5 "Events:"
```

If using ECR, verify images are pushed:
```bash
aws ecr list-images --repository-name spring-petclinic-config-server --region us-east-1
```

### `genai-service` in `CrashLoopBackOff`

API key is missing or invalid. Update the secret:

```bash
kubectl create secret generic genai-secret \
  --from-literal=OPENAI_API_KEY=<key> \
  --from-literal=AZURE_OPENAI_KEY="" \
  --from-literal=AZURE_OPENAI_ENDPOINT="" \
  -n petclinic \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl rollout restart deploy/genai-service -n petclinic
```

---

## What Was Built (Kubernetes Engineer Deliverables)

| Deliverable | Description |
|---|---|
| `helm/` | Umbrella Helm chart with 11 sub-charts |
| Startup ordering | Init containers enforce config-server → discovery-server → all others |
| Service discovery | Eureka preserved — no application code changes required |
| Ingress | Nginx Ingress routes external traffic to api-gateway only |
| Secrets | `genai-secret` stores OpenAI API keys securely |
| Resource limits | All pods capped at 512Mi (observability at 256Mi) |
| Health probes | Readiness and liveness probes on all pods via `/actuator/health` |
| Namespace isolation | All resources in dedicated `petclinic` namespace |
