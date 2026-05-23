# 🐾 PetCare Clinic CloudOps

<div align="center">

![PetCare CloudOps Banner](https://img.shields.io/badge/PetCare-CloudOps-00BFCF?style=for-the-badge&logo=kubernetes&logoColor=white)

**A production-grade microservices platform — containerised, orchestrated, automated, monitored, and live.**

*DevOps Micro Internship (DMI) Capstone Project — Cohort 2026*

[![CI/CD Pipeline](https://github.com/Petcare-Clinic/petcareClinic-cloudops/actions/workflows/ci.yml/badge.svg)](https://github.com/Petcare-Clinic/petcareClinic-cloudops/actions)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Java](https://img.shields.io/badge/Java-17-ED8B00?logo=openjdk&logoColor=white)](https://adoptium.net)
[![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.x-6DB33F?logo=springboot&logoColor=white)](https://spring.io)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.29-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io)
[![Docker](https://img.shields.io/badge/Docker-24.x-2496ED?logo=docker&logoColor=white)](https://docker.com)
[![Terraform](https://img.shields.io/badge/Terraform-1.7-7B42BC?logo=terraform&logoColor=white)](https://terraform.io)
[![Helm](https://img.shields.io/badge/Helm-3.x-0F1689?logo=helm&logoColor=white)](https://helm.sh)

[Live Application](https://app.petcareclinic.io) •
[Documentation](./docs) •
[Architecture](./docs/architecture/PetCare_CloudOps_Architecture.drawio) •
[Runbook](./docs/RUNBOOK.md) •
[Contributing](./CONTRIBUTING.md)

</div>

---

## 📋 Table of Contents

- [About the Project](#-about-the-project)
- [About the DMI Programme](#-about-the-dmi-programme)
- [The Team](#-the-team)
- [Architecture](#-architecture)
- [Microservices](#-microservices)
- [Tech Stack](#-tech-stack)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Local Development](#local-development)
  - [Building from Source](#building-from-source)
- [CI/CD Pipelines](#-cicd-pipelines)
- [Kubernetes Deployment](#-kubernetes-deployment)
- [Cloud Deployment](#-cloud-deployment)
  - [AWS (EKS)](#aws-eks)
  - [GCP (GKE)](#gcp-gke)
  - [Azure (AKS)](#azure-aks)
- [Monitoring & Observability](#-monitoring--observability)
- [Security](#-security)
- [Environment Strategy](#-environment-strategy)
- [Project Structure](#-project-structure)
- [Contributing](#-contributing)
- [Branching Strategy](#-branching-strategy)
- [Documentation](#-documentation)
- [Acknowledgements](#-acknowledgements)
- [License](#-license)

---

## 🎯 About the Project

**PetCare Clinic CloudOps** is the capstone project of the DevOps Micro Internship (DMI) programme, cohort 2026. The project takes the well-known open-source [Spring PetClinic Microservices](https://github.com/spring-petclinic/spring-petclinic-microservices) application and deploys it as a real, production-grade system using modern DevOps practices.

This is not a demo environment. Every tool, every pipeline, and every configuration in this repository reflects how a real engineering team operates.

### What We Built

A team of 11 DevOps interns built and delivered:

| Layer | What We Delivered |
|-------|------------------|
| **Application** | 7 Spring Boot microservices, containerised and running |
| **Infrastructure** | Cloud infrastructure provisioned entirely as code via Terraform |
| **Containers** | Dockerfile per service, Docker Compose for local development |
| **Orchestration** | Kubernetes with Helm charts, 2 replicas per service, HPA, rolling updates |
| **CI/CD** | 6 active GitHub Actions pipelines — build, test, push, deploy, rollback |
| **Monitoring** | Prometheus + Grafana for metrics, ELK Stack for logging, Alertmanager for alerts |
| **Security** | TLS/SSL via cert-manager, Kubernetes Secrets, least-privilege IAM, branch protection |
| **Documentation** | Runbook, architecture diagrams (Draw.io), onboarding guide, ADRs |

### Key Numbers

| Metric | Value |
|--------|-------|
| Microservices deployed | 7 |
| Pods running | 14 (2 replicas each) |
| CI/CD pipelines | 6 active |
| Environments | 3 (dev / staging / production) |
| Pipeline duration | ~8 minutes end-to-end |
| Rollback time | < 30 seconds |
| Manual deployment steps | 0 |
| Engineers | 11 |

---

## 🎓 About the DMI Programme

The **DevOps Micro Internship (DMI)** is a structured, mentor-led programme that places learners inside real engineering projects and holds them to production standards. Participants own specific roles, work in cross-functional teams, and deliver working systems and not only exercises.

**Programme Convener:** [Pravin Mishra](https://www.linkedin.com/in/pravin-mishra-aws-trainer/) — Finland 🇫🇮

**Co-Mentors:**
- [Praveen Pandey](https://www.linkedin.com/in/praveenpandey07/) — India 🇮🇳
- [Vincent Egwu Oko](https://www.linkedin.com/in/egwu-oko/) — Nigeria 🇳🇬

This repository is the complete output of the PetCare Clinic CloudOps team from DMI Cohort 2026.

---

## 👥 The Team

A globally distributed team of 11 engineers; from Nigeria 🇳🇬 and India 🇮🇳, each owning a specific role in this project.

| Name | Role | Location | Contribution |
|------|------|----------|-------------|
| **Vivian Chiamaka Okose** | Project Lead · Cloud Engineer | Nigeria 🇳🇬 | Sprint leadership, Terraform (VPC, EKS, ECR, IAM), cloud architecture, Git upstream strategy, GitHub Organisation setup |
| **Afoma** | Project Lead · CI/CD Engineer | Nigeria 🇳🇬 | Co-led project, sprint board management, PR review governance, branch protection policy, CI/CD pipeline design |
| **Nicky** | Cloud & Infrastructure Engineer | Nigeria 🇳🇬 | Full cloud infrastructure (Terraform), multi-environment setup, kubeconfig management, Architecture Decision Records |
| **Abdulmujib Alade Hashim** | Container · Docker Engineer | Nigeria 🇳🇬 | Dockerfiles for all 7 services, multi-stage builds, Docker Compose, image tagging strategy, CI Docker integration |
| **Florence** | Container · Docker Engineer | Nigeria 🇳🇬 | Image quality, multi-stage builds, ECR push/pull workflow, container security review, vulnerability scanning |
| **Temitope** | Kubernetes Engineer | Nigeria 🇳🇬 | K8s Deployment/Service manifests, liveness/readiness probes, resource limits, base Helm chart creation |
| **Pelumi** | Kubernetes Engineer | Nigeria 🇳🇬 | HPA (auto-scaling), Kubernetes namespaces per environment, Helm values per environment, rollback/chaos drills |
| **Nitika** | CI/CD Engineer | India 🇮🇳 | GitHub Actions CI pipelines (build, test, Docker push), GitHub Secrets management, CI documentation |
| **Ndubuisi** | CI/CD Engineer | Nigeria 🇳🇬 | GitHub Actions CD pipelines (Helm deploy, smoke tests, rollback), branch protection rules, environment triggers |
| **Chime** | Monitoring Engineer | Nigeria 🇳🇬 | Prometheus, Grafana dashboards, Alertmanager, Slack alert routing, monitoring documentation |
| **Mohana** | Monitoring Engineer | India 🇮🇳 | ELK Stack (Elasticsearch, Logstash, Kibana), Filebeat, log retention, monitoring security review |

---

## 🏗 Architecture

The system follows a layered, cloud-native architecture. Every layer is independently managed, monitored, and deployable.

```
                              ┌──────────────────────────────────────────────────────┐
                              │                    USERS / BROWSER                   │
                              │              HTTPS from any device, anywhere          │
                              └───────────────────────┬──────────────────────────────┘
                                                       │ HTTPS
                              ┌────────────────────────▼─────────────────────────────┐
                              │              NGINX INGRESS CONTROLLER                │
                              │    TLS termination · load balancing · routing        │
                              │         cert-manager + Let's Encrypt SSL             │
                              └────────────────────────┬─────────────────────────────┘
                                                       │
                              ┌────────────────────────▼─────────────────────────────┐
                              │               API GATEWAY  :8080                     │
                              │      Spring Cloud Gateway · rate limiting            │
                              │         circuit breaker · request routing            │
                              └──────┬──────────┬──────────┬──────────┬─────────────┘
                                     │          │          │          │
              ┌──────────────────────┼──────────┼──────────┼──────────┼─────────────────┐
              │                 MICROSERVICES LAYER                                       │
              │                                                                           │
              │  ┌─────────────┐  ┌────────────┐  ┌─────────────┐  ┌─────────────────┐ │
              │  │  customers  │  │    vets     │  │   visits    │  │  admin-server   │ │
              │  │   :8081     │  │   :8083     │  │   :8082     │  │     :9090       │ │
              │  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └─────────────────┘ │
              │         │                │                 │                             │
              │  ┌──────▼──────────────────────────────────▼──────┐                    │
              │  │              CONFIG SERVER  :8888               │                    │
              │  │         Central configuration for all services  │                    │
              │  └─────────────────────────────────────────────────┘                    │
              │  ┌──────────────────────────────────────────────────┐                   │
              │  │           DISCOVERY SERVER  :8761                │                   │
              │  │              Eureka Service Registry             │                   │
              │  └──────────────────────────────────────────────────┘                   │
              └───────────────────────────────────────────────────────────────────────┘
                                               │
              ┌────────────────────────────────▼──────────────────────────────────────┐
              │                           DATA LAYER                                  │
              │   MySQL (customers)  ·  MySQL (vets)  ·  MySQL (visits)               │
              │              Secret Manager / Kubernetes Secrets / Vault               │
              └────────────────────────────────┬──────────────────────────────────────┘
                                               │
              ┌────────────────────────────────▼──────────────────────────────────────┐
              │                         PLATFORM LAYER                                │
              │   Kubernetes (EKS / GKE / AKS)  ·  Helm  ·  Docker  ·  Terraform     │
              │            Container Registry (ECR / GCR / ACR)                       │
              └────────────────────────────────┬──────────────────────────────────────┘
                                               │
              ┌────────────────────────────────▼──────────────────────────────────────┐
              │                      OBSERVABILITY LAYER                              │
              │   Prometheus (metrics · 15s scrape)  ·  Grafana (dashboards)          │
              │   ELK Stack (centralised logs)  ·  Alertmanager (Slack · email)       │
              │              HPA (auto-scaling 2 → 10 pods)                           │
              └────────────────────────────────┬──────────────────────────────────────┘
                                               │
              ┌────────────────────────────────▼──────────────────────────────────────┐
              │                         CI/CD PIPELINE                                │
              │  git push → build → test → Docker push → Helm deploy → smoke test     │
              │                 GitHub Actions  ·  ~8 minutes                         │
              └───────────────────────────────────────────────────────────────────────┘
```

> 📐 **Full interactive Draw.io diagram:** [`/docs/architecture/PetCare_CloudOps_Architecture.drawio`](./"C:\Users\chiam\Downloads"/PetCare_CloudOps_Architecture.drawio)
>
> Open at [app.diagrams.net](https://app.diagrams.net) — File → Open From → Device.

---

## 🧩 Microservices

Each microservice is independent — one job, one database, one Dockerfile, one set of K8s manifests.

| Service | Port | Description | Database |
|---------|------|-------------|----------|
| **api-gateway** | 8080 | Single entry point. Spring Cloud Gateway. Handles routing, rate limiting, and circuit breaking. | None |
| **customers-service** | 8081 | Manages pet owner profiles and their registered pets. | MySQL (customers) |
| **vets-service** | 8083 | Stores veterinarian information, specialities, and schedules. | MySQL (vets) |
| **visits-service** | 8082 | Manages pet appointment booking and visit history. | MySQL (visits) |
| **config-server** | 8888 | Serves centralised configuration to all other services on startup. | None |
| **discovery-server** | 8761 | Eureka service registry — all services register here so they can find each other. | None |
| **admin-server** | 9090 | Spring Boot Admin dashboard — real-time view of all service health indicators. | None |

### Service Startup Order

Services must start in this order. The CI/CD pipeline and `docker-compose.yml` both enforce this via health checks:

```
config-server → discovery-server → customers-service
                                 → vets-service
                                 → visits-service
                                 → api-gateway
                                 → admin-server
```

---

## 🛠 Tech Stack

| Category | Tool | Version | Purpose |
|----------|------|---------|---------|
| **Language** | Java | 17 (Temurin LTS) | Application runtime |
| **Framework** | Spring Boot | 3.x | Microservice framework |
| **Build** | Maven | 3.9.x | Dependency management and build |
| **Service Mesh** | Spring Cloud Gateway | 4.x | API gateway and routing |
| **Service Discovery** | Eureka (Spring Cloud Netflix) | 4.x | Service registry |
| **Containers** | Docker | 24.x | Container runtime |
| **Local Dev** | Docker Compose | 2.x | Multi-service local orchestration |
| **Orchestration** | Kubernetes | 1.29 | Container orchestration |
| **Packaging** | Helm | 3.x | Kubernetes application packaging |
| **Cloud (AWS)** | Amazon EKS | — | Managed Kubernetes on AWS |
| **IaC** | Terraform | 1.7.x | Cloud infrastructure as code |
| **CI/CD** | GitHub Actions | — | Automated pipelines |
| **Registry (AWS)** | Amazon ECR | — | Docker image registry |
| **Metrics** | Prometheus | 2.x | Metrics collection and storage |
| **Dashboards** | Grafana | 10.x | Metrics visualisation |
| **Ingress** | NGINX Ingress Controller | 1.9.x | External traffic routing |
| **Auto-scaling** | Kubernetes HPA | — | Horizontal pod autoscaling |
| **Source Control** | GitHub | — | Code hosting and collaboration |

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed before proceeding:

| Tool | Version | Install Guide |
|------|---------|--------------|
| Git | 2.x | [git-scm.com](https://git-scm.com) |
| Java (JDK) | 17 (Temurin LTS) | [adoptium.net](https://adoptium.net) |
| Maven | 3.9.x | [maven.apache.org](https://maven.apache.org) |
| Docker Desktop | 24.x | [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/) |

Verify all tools are installed:

```bash
git --version       # git version 2.x.x
java -version       # openjdk version "17.x.x"
mvn -version        # Apache Maven 3.x.x
docker --version    # Docker version 24.x.x
docker compose version  # Docker Compose version 2.x.x
```

### Local Development

The fastest way to run all 7 microservices on your laptop.

#### 1. Clone the Repository

```bash
# Clone your fork
git clone https://github.com/Petcare-Clinic/petcareClinic-cloudops.git
cd petcareClinic-cloudops

# Add the upstream original repository for future syncs
git remote add upstream https://github.com/spring-petclinic/spring-petclinic-microservices.git

# Verify your remotes
git remote -v
# origin    https://github.com/Petcare-Clinic/petcareClinic-cloudops.git (fetch)
# origin    https://github.com/Petcare-Clinic/petcareClinic-cloudops.git (push)
# upstream  https://github.com/spring-petclinic/spring-petclinic-microservices.git (fetch)
# upstream  https://github.com/spring-petclinic/spring-petclinic-microservices.git (push)
```

#### 2. Start All Services

```bash
# Start all 7 services in the background
docker compose up -d

# First run downloads images — allow 5-15 minutes depending on internet speed
# Subsequent starts take ~30 seconds
```

#### 3. Verify All Services Are Running

```bash
docker compose ps

# Expected output — all services should show "running (healthy)"
# NAME                      STATUS              PORTS
# config-server             running (healthy)   0.0.0.0:8888->8888/tcp
# discovery-server          running (healthy)   0.0.0.0:8761->8761/tcp
# customers-service         running (healthy)   0.0.0.0:8081->8081/tcp
# vets-service              running (healthy)   0.0.0.0:8083->8083/tcp
# visits-service            running (healthy)   0.0.0.0:8082->8082/tcp
# api-gateway               running (healthy)   0.0.0.0:8080->8080/tcp
# admin-server              running (healthy)   0.0.0.0:9090->9090/tcp
```

#### 4. Access the Application

| Service | URL | Description |
|---------|-----|-------------|
| PetClinic App | http://localhost:8080 | Main application interface |
| Eureka Dashboard | http://localhost:8761 | Service registry — all registered services |
| Admin Server | http://localhost:9090 | Health and metrics dashboard |
| Config Server | http://localhost:8888 | Configuration endpoint |

> ⚠️ **Note:** Allow 60-90 seconds after `docker compose up` for all services to fully initialise and register with Eureka before opening the app.

#### Common Local Commands

```bash
# View logs for a specific service
docker compose logs customers-service

# Follow logs in real time
docker compose logs -f api-gateway

# Restart a specific service
docker compose restart vets-service

# Stop all services (containers preserved)
docker compose stop

# Stop and remove all containers
docker compose down

# Stop and remove containers AND volumes (WARNING: deletes all data)
docker compose down -v

# View resource usage
docker stats
```

### Building from Source

Build all microservices from Java source code:

```bash
# Clean and build all services (skipping tests for speed)
./mvnw clean package -DskipTests

# Run with tests
./mvnw clean package

# Build Docker images using the Spring Boot Maven plugin
./mvnw spring-boot:build-image -DskipTests

# Start using locally-built images
docker compose up -d --build
```

> On Windows, replace `./mvnw` with `mvnw.cmd`

---

## 🔁 CI/CD Pipelines

This project runs **6 active GitHub Actions pipelines**. Each pipeline has a distinct trigger and purpose.

| # | Pipeline | Trigger | What It Does |
|---|----------|---------|-------------|
| **1** | Main CI/CD | Push to `main` | Builds, tests, pushes Docker image to ECR, deploys to production via Helm |
| **2** | PR Validation | Pull Request opened | Compiles code and runs full test suite — nothing broken can reach `main` |
| **3** | Dev Deploy | Push to `develop` | Auto-deploys to the `petcare-dev` Kubernetes namespace for immediate testing |
| **4** | Staging Deploy | PR merge to `staging` | Deploys to `petcare-staging`, runs integration tests, requires human approval |
| **5** | Production Deploy | Release tag (e.g. `v1.0.0`) | Deploys to `petcare-prod` — requires all prior stages to have passed |
| **6** | Rollback | Manual trigger or failed smoke test | Runs `helm rollback petclinic` — full rollback in < 30 seconds |

### Pipeline Flow (Main CI/CD)

```
git push to main
       │
       ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  1. Build   │────▶│  2. Test    │────▶│ 3. Docker   │────▶│  4. Push    │────▶│ 5. Helm     │────▶│ 6. Smoke    │
│  Maven      │     │  Unit +     │     │    Build    │     │  to ECR /   │     │   Deploy    │     │   Test      │
│  compile    │     │  Integration│     │  Tag: SHA   │     │  GCR / ACR  │     │  Rolling    │     │  Health     │
│             │     │  tests      │     │             │     │             │     │  update     │     │  checks     │
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
                                                                                                              │
                                                              ◀─────────────── ~8 minutes total ─────────────┘
```

### Pipeline Configuration

All pipeline YAML files are in [`.github/workflows/`](./.github/workflows/).

### Required GitHub Secrets

Before pipelines will run, add these secrets under **Repository Settings → Secrets and variables → Actions**:

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | IAM user access key for AWS deployments |
| `AWS_SECRET_ACCESS_KEY` | IAM user secret key for AWS deployments |
| `GCP_CREDENTIALS` | Full service account JSON for GCP deployments |
| `AZURE_CREDENTIALS` | Full service principal JSON for Azure deployments |
| `KUBECONFIG` | Kubernetes cluster configuration file contents |
| `SLACK_WEBHOOK_URL` | Slack webhook for pipeline failure notifications |

---

## ⎈ Kubernetes Deployment

### Prerequisites for Kubernetes

```bash
# Install kubectl
# macOS
brew install kubectl

# Linux
curl -LO https://dl.k8s.io/release/v1.29.0/bin/linux/amd64/kubectl
chmod +x kubectl && sudo mv kubectl /usr/local/bin/

# Install Helm
brew install helm  # macOS
# Or: https://helm.sh/docs/intro/install/
```

### Deploy with Helm

```bash
# Create the namespace
kubectl create namespace petcare

# Deploy all services
helm install petclinic ./helm/petclinic \
  --namespace petcare \
  --values helm/petclinic/values.yaml

# Watch pods start up
kubectl get pods -n petcare -w

# Upgrade after code changes
helm upgrade petclinic ./helm/petclinic \
  --namespace petcare \
  --set image.tag=$(git rev-parse --short HEAD)

# Roll back to previous release
helm rollback petclinic -n petcare

# Roll back to a specific release revision
helm rollback petclinic 3 -n petcare

# View release history
helm history petclinic -n petcare
```

### Useful kubectl Commands

```bash
# View all resources in the petcare namespace
kubectl get all -n petcare

# Describe a specific pod (detailed info + events)
kubectl describe pod <pod-name> -n petcare

# View live logs from a deployment
kubectl logs -f deployment/customers-service -n petcare

# View logs from all pods in a deployment
kubectl logs deployment/vets-service -n petcare --all-containers

# Execute a command inside a running pod
kubectl exec -it <pod-name> -n petcare -- sh

# Scale a deployment manually
kubectl scale deployment/customers-service --replicas=3 -n petcare

# View resource usage
kubectl top pods -n petcare
kubectl top nodes

# View events (useful for debugging)
kubectl get events -n petcare --sort-by='.lastTimestamp'
```

---

## ☁️ Cloud Deployment

This project supports deployment to AWS, GCP, and Azure. All infrastructure is managed with Terraform.

### AWS (EKS)

```bash
# Configure AWS CLI
aws configure
# Enter: Access Key ID, Secret Access Key, region (us-east-1), output format (json)

# Provision infrastructure
cd infrastructure/aws/
terraform init
terraform plan
terraform apply

# Connect kubectl to the cluster
aws eks update-kubeconfig \
  --region us-east-1 \
  --name petcare-cloudops

# Verify cluster connection
kubectl get nodes
```

**AWS Resources Created:**
- VPC with public and private subnets across 3 availability zones
- Internet Gateway and NAT Gateways
- EKS Cluster (Kubernetes 1.29)
- Managed Node Group (t3.medium × 2)
- Amazon ECR registry
- IAM roles and security groups

### GCP (GKE)

```bash
# Authenticate with GCP
gcloud auth login
gcloud config set project petcare-cloudops-2026

# Enable required APIs (run once)
gcloud services enable container.googleapis.com \
  artifactregistry.googleapis.com \
  cloudbuild.googleapis.com

# Provision infrastructure
cd infrastructure/gcp/
terraform init
terraform apply

# Connect kubectl to the cluster
gcloud container clusters get-credentials petcare-cluster \
  --region us-central1 \
  --project petcare-cloudops-2026
```

### Azure (AKS)

```bash
# Authenticate with Azure
az login

# Provision infrastructure
cd infrastructure/azure/
terraform init
terraform apply

# Connect kubectl to the cluster
az aks get-credentials \
  --resource-group petcare-cloudops-rg \
  --name petcare-aks

# Verify connection
kubectl get nodes
```

### Cost Estimates (Minimal Dev Setup)

| Cloud Provider | Est. Monthly Cost | Key Savings |
|----------------|------------------|-------------|
| **AWS (EKS)** | ~$171/month | Use t3.small nodes, scale to 0 at night |
| **GCP (GKE)** | ~$53/month | 1 free zonal cluster + preemptible nodes |
| **Azure (AKS)** | ~$72/month | Free AKS management plane + spot VMs |

> ⚠️ **Important:** Always set billing alerts before provisioning cloud resources. Destroy resources with `terraform destroy` when not in use.

---

## 📊 Monitoring & Observability

### Install the Monitoring Stack

```bash
# Add the Prometheus community Helm repository
helm repo add prometheus-community \
  https://prometheus-community.github.io/helm-charts
helm repo update

# Install Prometheus + Grafana + Alertmanager (kube-prometheus-stack)
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --set grafana.adminPassword=change-me-in-production

# Install ELK Stack
helm repo add elastic https://helm.elastic.co
helm repo update

helm install elasticsearch elastic/elasticsearch --namespace logging --create-namespace
helm install kibana elastic/kibana --namespace logging
helm install filebeat elastic/filebeat --namespace logging
```

### Access Monitoring Tools

```bash
# Access Grafana locally (port-forward)
kubectl port-forward -n monitoring svc/monitoring-grafana 3000:80
# Open: http://localhost:3000 | admin / your-password

# Access Prometheus locally
kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9091:9090
# Open: http://localhost:9091

# Access Kibana locally
kubectl port-forward -n logging svc/kibana-kibana 5601:5601
# Open: http://localhost:5601
```

### What We Monitor

| Category | Metrics |
|----------|---------|
| **Application** | HTTP request rate, error rate, response time (p50/p95/p99) |
| **JVM** | Heap memory usage, GC frequency, thread count |
| **Kubernetes** | Pod restart count, deployment status, resource usage |
| **Database** | Connection pool utilisation, query duration |
| **Infrastructure** | Node CPU, node memory, disk I/O, network throughput |

### Alerting Rules

| Alert | Condition | Severity | Notification |
|-------|-----------|----------|-------------|
| `ServiceDown` | Pod unreachable > 1 minute | SEV-1 | Slack + email |
| `HighMemoryUsage` | JVM heap > 85% | WARNING | Slack |
| `HighErrorRate` | Error rate > 5% for 5 min | SEV-2 | Slack |
| `PodCrashLooping` | Restart count > 3 in 10 min | SEV-2 | Slack |
| `PipelineFailure` | CI/CD pipeline fails | WARNING | Slack |

---

## 🔐 Security

Security is built into every layer — not added at the end.

| Control | Implementation | Details |
|---------|---------------|---------|
| **TLS / HTTPS** | cert-manager + Let's Encrypt | Auto-renewing certificates, all traffic encrypted |
| **Secrets Management** | Kubernetes Secrets + GitHub Secrets | Zero plaintext credentials in code or config |
| **Branch Protection** | GitHub branch rules | No direct pushes to `main` — PR + reviewer approval required |
| **Network Isolation** | Private subnets | Services run internally; only Ingress is public-facing |
| **Least Privilege IAM** | Per-service IAM roles | Each service has only the permissions it needs |
| **Image Scanning** | Automated CVE scanning | Images scanned before push; Dependabot for dependency updates |
| **Audit Trail** | GitHub PR history | Every change is traceable — who changed what, when, and why |

---

## 🌿 Environment Strategy

| Environment | Namespace | Trigger | Purpose |
|-------------|-----------|---------|---------|
| **Development** | `petcare-dev` | Push to `develop` | Active development and feature testing |
| **Staging** | `petcare-staging` | PR merge to `staging` | Pre-production QA and integration testing |
| **Production** | `petcare-prod` | Release tag (e.g. `v1.0.0`) | Live, customer-facing environment |

---

## 📁 Project Structure

```
petcareClinic-cloudops/
│
├── 📦 spring-petclinic-api-gateway/          # API Gateway service
├── 📦 spring-petclinic-customers-service/    # Customers service
├── 📦 spring-petclinic-vets-service/         # Vets service
├── 📦 spring-petclinic-visits-service/       # Visits service
├── 📦 spring-petclinic-config-server/        # Config server
├── 📦 spring-petclinic-discovery-server/     # Discovery server (Eureka)
├── 📦 spring-petclinic-admin-server/         # Admin server
│
├── 🏗 infrastructure/
│   ├── aws/                                  # Terraform for AWS (EKS, VPC, ECR)
│
├── ⎈ helm/
│   └── petclinic/                            # Helm chart for all services
│       ├── Chart.yaml
│       ├── values.yaml                       # Default values
│       ├── values-dev.yaml                   # Dev overrides
│       ├── values-staging.yaml               # Staging overrides
│       └── templates/                        # K8s manifest templates
│
├── 📋 k8s/
│   ├── namespace.yaml                        # Namespace definitions
│   ├── ingress.yaml                          # NGINX Ingress + TLS
│   ├── letsencrypt-issuer.yaml               # cert-manager ClusterIssuer
│   └── <service>/                            # Per-service manifests
│       ├── deployment.yaml
│       ├── service.yaml
│       └── hpa.yaml
│
├── 🔁 .github/
│   └── workflows/
│       ├── ci-cd.yml                         # Main CI/CD pipeline
│       ├── pr-validation.yml                 # PR validation pipeline
│       ├── deploy-dev.yml                    # Dev environment deploy
│       ├── deploy-staging.yml                # Staging environment deploy
│       ├── deploy-prod.yml                   # Production deploy
│       └── rollback.yml                      # Rollback pipeline
│
├── 📊 monitoring/
│   ├── prometheus.yml                        # Prometheus scrape config
│   ├── alerting-rules.yml                    # Alertmanager rules
│   └── grafana/                              # Grafana dashboard definitions
│
├── 📚 docs/
│   ├── architecture/
│   │   └── PetCare_CloudOps_Architecture.drawio  # Draw.io diagram
│   ├── adr/                                  # Architecture Decision Records
│   ├── RUNBOOK.md                            # Operations runbook
│   └── ONBOARDING.md                         # New engineer onboarding guide
│
├── docker-compose.yml                        # Local development (all 7 services)
├── prometheus.yml                            # Local Prometheus config
├── pom.xml                                   # Root Maven build file
├── CONTRIBUTING.md                           # Contribution guidelines
├── CHANGELOG.md                              # Version history
└── README.md                                 # This file
```

---

## 🤝 Contributing

We follow standard GitHub Flow. Every change goes through a pull request.

### Quick Contribution Guide

```bash
# 1. Create a feature branch from develop
git checkout -b feature/your-feature-name

# 2. Make your changes

# 3. Test locally
docker compose up -d
# Verify your change works

# 4. Commit using conventional commit format
git add .
git commit -m "feat: add Prometheus scrape config for vets-service"

# 5. Push your branch
git push origin feature/your-feature-name

# 6. Open a Pull Request on GitHub targeting develop
# - Add a description of what you changed and why
# - Request at least one reviewer
# - Wait for CI pipeline to pass before merging
```

### Conventional Commit Format

```
<type>: <short description>

Types:
  feat     — New feature
  fix      — Bug fix
  docs     — Documentation only
  chore    — Maintenance (dependency updates, etc.)
  ci       — CI/CD pipeline changes
  infra    — Infrastructure changes (Terraform, Helm)
  refactor — Code refactoring
  test     — Adding or updating tests
```

---

## 🌿 Branching Strategy

```
main          ←── Protected. No direct pushes. Only release merges.
  │
  └── staging ←── Pre-production. Requires PR approval.
        │
        └── develop ←── Integration branch. Auto-deploys to dev.
              │
              ├── feature/add-hpa-config
              ├── feature/prometheus-dashboard
              ├── fix/config-server-startup-delay
              └── infra/terraform-gcp-vpc
```

| Branch Pattern | Purpose | Deploy Target |
|----------------|---------|--------------|
| `main` | Stable, production-ready code | Production |
| `staging` | Final pre-production integration | Staging |
| `develop` | Active development integration | Dev |
| `feature/*` | New features | Local / Dev |
| `fix/*` | Bug fixes | Local / Dev |
| `hotfix/*` | Urgent production fixes | Production |
| `infra/*` | Infrastructure changes | Per environment |
| `release/v*` | Release preparation | Staging → Production |

---

## 📚 Documentation

| Document | Location | Description |
|----------|----------|-------------|
| **Runbook** | [`docs/RUNBOOK.md`](./docs/RUNBOOK.md) | Operational procedures — how to deploy, scale, rollback, and respond to incidents |
| **Onboarding Guide** | [`docs/ONBOARDING.md`](./docs/ONBOARDING.md) | New engineer setup — productive in under 30 minutes |
| **Architecture Diagram** | [`docs/architecture/`](./docs/architecture/) | Draw.io system architecture diagram |
| **ADRs** | [`docs/adr/`](./docs/adr/) | Architecture Decision Records — why we chose each technology |
| **Contributing** | [`CONTRIBUTING.md`](./CONTRIBUTING.md) | PR process, commit format, code review standards |
| **Changelog** | [`CHANGELOG.md`](./CHANGELOG.md) | Version history and release notes |
| **Local Deployment Guide** | [`docs/Part1_Local_Deployment_Guide.md`](./docs/Part1_Local_Deployment_Guide.md) | Detailed beginner-friendly local setup walkthrough |
| **Cloud Deployment Guide** | [`docs/Part2_Cloud_Deployment_Guide.md`](./docs/Part2_Cloud_Deployment_Guide.md) | AWS cloud deployment walkthrough |
| **GCP Deployment Guide** | [`docs/Part3A_GCP_Deployment_Guide.md`](./docs/Part3A_GCP_Deployment_Guide.md) | Google Cloud deployment walkthrough |
| **Azure Deployment Guide** | [`docs/Part3B_Azure_Deployment_Guide.md`](./docs/Part3B_Azure_Deployment_Guide.md) | Microsoft Azure deployment walkthrough |

---

## 🙏 Acknowledgements

This project was built as part of the **DevOps Micro Internship (DMI)** programme.

### Mentors

| Name | Role | Location |
|------|------|----------|
| **Pravin Mishra** | Programme Convener, DMI | Finland 🇫🇮 |
| **Praveen Pandey** | Co-Mentor | India 🇮🇳 |
| **Vincent Egwu Oko** | Co-Mentor | Nigeria 🇳🇬 |

### Upstream Project

This project is built on top of [Spring PetClinic Microservices](https://github.com/spring-petclinic/spring-petclinic-microservices), maintained by the Spring community. We are grateful for the solid open-source foundation.

### DMI Programme

The DevOps Micro Internship gave 11 engineers the environment, structure, and accountability to go from learners to production engineers. Every line of infrastructure, every pipeline, every monitoring alert in this repository is evidence of what that programme produces.

---

## 📄 License

This project is licensed under the **Apache License 2.0** — see the [LICENSE](./LICENSE) file for full details.

The upstream Spring PetClinic Microservices project is also licensed under Apache License 2.0.

---

<div align="center">

**PetCare Clinic CloudOps**

*Built by a team of 11 DevOps engineers through the DMI programme — 2026*

[⬆ Back to top](#-petcare-clinic-cloudops)

</div>
