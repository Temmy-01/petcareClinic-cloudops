# PetClinic CloudOps

GitOps-based CI/CD pipeline for deploying Spring PetClinic microservices to AWS EKS using Helm and ArgoCD.

## Quick Start

1. **Configure GitHub Secrets** (AWS credentials, ArgoCD access) — [See Deployment Guide](deployment.md#step-1-configure-github-secrets)
2. **Bootstrap ArgoCD Applications** — [See Deployment Guide] (deployment.md#step-2-bootstrap-argocd-applications)
3. **Push to Dev or main** — Workflow builds, pushes images, and deploys automatically

## Documentations

- **[Deployment Guide](deployment.md)** — Complete setup, prerequisites, and operations
- **[Kubernetes Deployment Guide](helm/kubernetes-deployment-guide.md)** — Manual Helm deployment for testing
- **[Terraform](terraform/)** — Infrastructure-as-Code for AWS resources (EKS, ECR, RDS)

## Architecture

```
GitHub Push → CI/CD Workflow → Docker Build → ECR → ArgoCD → EKS
                ├─ Builds 8 microservices
                ├─ Updates Helm values
                └─ Triggers ArgoCD sync
```

## Services

| Name | Port | Purpose |
|------|------|---------|
| api-gateway | 8080 | HTTP entry point |
| config-server | 8888 | Configuration management |
| discovery-server | 8761 | Service registry (Eureka) |
| customers-service | 8081 | Customer data |
| vets-service | 8083 | Veterinarian data |
| visits-service | 8082 | Visit records |
| genai-service | 8084 | AI chatbot features |
| admin-server | 9090 | Spring Boot Admin |
| **prometheus** | **9090** | **Metrics collection & storage** |
| **grafana** | **3000** | **Metrics dashboards & visualization** |
| **zipkin** | **9411** | **Distributed tracing** |

## Observability

The stack includes production-ready monitoring and tracing:

- **Prometheus** — Scrapes metrics from all services at `/actuator/prometheus` every 15 seconds
- **Grafana** — Pre-configured with Prometheus datasource and "Spring Petclinic Metrics" dashboard
  - HTTP latency, request rates, business operation metrics
  - Default credentials: `admin` / `petclinic`
- **Zipkin** — Distributed tracing for microservice call chains

Access via `kubectl port-forward`:
```bash
kubectl port-forward -n dev svc/grafana 3000:3000    # http://localhost:3000
kubectl port-forward -n dev svc/prometheus 9090:9090 # http://localhost:9090
kubectl port-forward -n dev svc/zipkin 9411:9411     # http://localhost:9411/zipkin/
```

## Environments

- **Dev** — Push to `Dev` branch → deploys to `dev` namespace
- **Production** — Push to `main` branch → deploys to `production` namespace

## Workflows

### CI Workflow (ci.yml)
- Triggers on push/PR to Dev or main
- Builds with Maven
- Uploads artifacts

### CD Workflow (cd.yml)
- Triggers on push to Dev or main
- **Job 1:** Builds Docker images, tags, pushes to ECR
- **Job 2:** Updates Helm values, commits to repo
- **Job 3:** Syncs ArgoCD, waits for healthy deployment

## Get Started

See [Deployment Guide](deployment.md) for complete setup instructions.

## Repository Structure

```
├── .github/workflows/       # CI/CD pipelines
├── argocd/applications/     # ArgoCD application definitions
├── helm/                    # Helm charts (11 services)
├── terraform/               # Infrastructure setup
└── upstream/                # Spring PetClinic source code
```


----
This part will be for our architecture.
----
