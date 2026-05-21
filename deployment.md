# Deployment Guide — PetClinic CloudOps

## Overview

This repository contains a **GitOps-based CI/CD pipeline** for deploying Spring PetClinic microservices to AWS EKS using ArgoCD.

### Pipeline Architecture

```
┌─────────────────────────────────────────────────────┐
│  Push to Dev or main branch                         │
└──────────────────┬──────────────────────────────────┘
                   │
      ┌────────────▼─────────────┐
      │  CI Workflow (ci.yml)    │
      │  • Build with Maven      │
      │  • Skip tests            │
      │  • Upload artifacts      │
      └────────────┬─────────────┘
                   │
      ┌────────────▼──────────────────────┐
      │  CD Workflow (cd.yml)             │
      ├───────────────────────────────────┤
      │ JOB 1: build-and-push             │
      │  • Build 8 services + Docker      │
      │  • Tag as dev-<N> or v1.0.<N>     │
      │  • Push to ECR                    │
      ├───────────────────────────────────┤
      │ JOB 2: update-manifests           │
      │  • Update helm/values-*.yaml      │
      │  • Commit & push [skip ci]        │
      ├───────────────────────────────────┤
      │ JOB 3: argocd-sync                │
      │  • Trigger ArgoCD sync            │
      │  • Wait for health (300s)         │
      └────────────┬──────────────────────┘
                   │
      ┌────────────▼─────────────────────┐
      │  ArgoCD Automatic Sync           │
      │  • Reads new Helm values         │
      │  • Renders & applies manifests   │
      │  • Deploys to EKS                │
      └────────────┬─────────────────────┘
                   │
      ┌────────────▼─────────────────────┐
      │  Production Environment          │
      │  dev namespace / production ns   │
      └──────────────────────────────────┘
```

### Services Deployed

| Service | Port | Type |
|---------|------|------|
| config-server | 8888 | Bootstrap |
| discovery-server | 8761 | Bootstrap (Eureka) |
| api-gateway | 8080 | Ingress entry point |
| customers-service | 8081 | Business logic |
| vets-service | 8083 | Business logic |
| visits-service | 8082 | Business logic |
| genai-service | 8084 | AI features |
| admin-server | 9090 | Spring Boot Admin |
| **zipkin** | **9411** | **Distributed tracing** |
| **prometheus** | **9090** | **Metrics collection** |
| **grafana** | **3000** | **Metrics dashboard** |

---

## Prerequisites

### AWS Setup

1. **EKS Cluster** running (e.g., `petclinic-eks-prod` in `us-east-1`)
   - 3+ nodes, each with 2 CPUs and 4GB RAM
   - Verify: `aws eks describe-cluster --name petclinic-eks-prod --region us-east-1`

2. **ECR Registry** with repositories for each service:
   ```bash
   aws ecr list-repositories --region us-east-1
   # Must include: config-server, discovery-server, customers-service, vets-service, 
   #               visits-service, api-gateway, admin-server, genai-service
   ```
   - Typically created by Terraform in `terraform/aws/`

3. **IAM User** for CI/CD with permissions:
   - `ecr:BatchGetImage`, `ecr:PutImage`, `ecr:InitiateLayerUpload`, `ecr:UploadLayerPart`, `ecr:CompleteLayerUpload`
   - `eks:DescribeCluster`, `eks:UpdateClusterConfig`
   - Document the Access Key ID and Secret Access Key for GitHub Secrets

### Kubernetes Setup

1. **ArgoCD installed** on the cluster:
   ```bash
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```

2. **ArgoCD admin password:**
   ```bash
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
   ```

3. **ArgoCD server accessible** (port-forward for testing, or expose via LoadBalancer/Ingress):
   ```bash
   kubectl port-forward -n argocd svc/argocd-server 6443:443
   # Then access https://localhost:6443
   ```

### GitHub Setup

1. **Repository secrets** configured in `Settings → Secrets and variables → Actions`

2. **Personal Access Token (PAT)** with `repo` scope (for pushing manifest updates):
   - Create at: https://github.com/settings/tokens
   - Select scopes: `repo` (full control of private repositories)

---

## Step 1: Configure GitHub Secrets

Go to **Repository Settings → Secrets and variables → Actions** and add:

| Secret | Value | Example |
|--------|-------|---------|
| `AWS_REGION` | AWS region | `us-east-1` |
| `AWS_ACCESS_KEY_ID` | IAM user key | `AKIAIOSFODNN7EXAMPLE` |
| `AWS_SECRET_ACCESS_KEY` | IAM user secret | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` |
| `ECR_REGISTRY` | ECR endpoint | `268015775379.dkr.ecr.us-east-1.amazonaws.com` |
| `EKS_CLUSTER_NAME` | Cluster name | `petclinic-eks-prod` |
| `ARGOCD_SERVER` | ArgoCD server URL | `https://argocd.example.com` or `https://localhost:6443` |
| `ARGOCD_PASSWORD` | ArgoCD admin password | (from `kubectl` above) |
| `GH_PAT` | GitHub Personal Access Token | (from GitHub settings) |

⚠️ **Security note:** Store sensitive values securely. Use IAM credentials with least-privilege scope.

---

## Step 2: Bootstrap ArgoCD Applications

**One-time setup.** Create the ArgoCD Application manifests that tell ArgoCD where to deploy from:

```bash
kubectl apply -f argocd/applications/petclinic-dev.yaml
kubectl apply -f argocd/applications/petclinic-production.yaml
```

Verify:
```bash
kubectl get applications -n argocd
# Expected output:
# NAME                      SYNC STATUS   HEALTH STATUS
# petclinic-dev             OutOfSync     Progressing
# petclinic-production      OutOfSync     Progressing
```

(Status will change to `Synced` / `Healthy` once namespaces and manifests are created.)

---

## Step 3: Deploy on First Push

### For Dev Environment

Push to the `Dev` branch:
```bash
git push origin feature/my-feature:Dev
```

This triggers:
1. **CI workflow** (`ci.yml`): Builds and tests
2. **CD workflow** (`cd.yml`):
   - Builds Docker images → tags `dev-<run#>` → pushes to ECR
   - Updates `helm/values-dev.yaml` with new image tag
   - Commits with `[skip ci]` to prevent loop
   - Syncs ArgoCD → deploys to `dev` namespace

Watch the workflow in **Actions** tab. When complete:
```bash
# Port-forward to test
kubectl port-forward -n dev svc/api-gateway 8080:8080
curl http://localhost:8080
```

### For Production Environment

Merge to `main` branch:
```bash
git merge feature/my-feature
git push origin main
```

This triggers the same flow but:
- Tags images as `v1.0.<run#>` (semantic versioning)
- Updates `helm/values-production.yaml`
- Deploys to `production` namespace

---

## File Structure

```
.
├── .github/
│   └── workflows/
│       ├── ci.yml           # Build and test
│       └── cd.yml           # Build, push, sync ArgoCD
├── argocd/
│   └── applications/
│       ├── petclinic-dev.yaml
│       └── petclinic-production.yaml
├── helm/
│   ├── Chart.yaml           # Umbrella chart definition
│   ├── values.yaml          # Base values
│   ├── values-dev.yaml      # Dev environment overrides
│   ├── values-production.yaml # Production overrides
│   └── charts/              # Sub-charts (11 services)
├── terraform/               # IaC for AWS resources
└── upstream/                # Spring PetClinic source code
```

---

## Pipeline Behavior

### Branch Triggers

| Branch | Namespace | Image Tag | ArgoCD App |
|--------|-----------|-----------|------------|
| `Dev` | `dev` | `dev-<run#>` | petclinic-dev |
| `main` | `production` | `v1.0.<run#>` | petclinic-production |

### Loop Prevention

The CD workflow includes `paths-ignore` to prevent infinite loops:
```yaml
on:
  push:
    branches: [ Dev, main ]
    paths-ignore:
      - 'helm/values-dev.yaml'
      - 'helm/values-production.yaml'
```

**Explanation:** When the workflow updates `helm/values-*.yaml`, it doesn't trigger a new CD run. Instead:
1. Commit message includes `[skip ci]` (redundant safety net)
2. ArgoCD detects the commit via git polling
3. ArgoCD syncs automatically

---

## Observability Stack

The deployment includes a complete monitoring and tracing stack for production observability:

### Prometheus
- **Image:** `prom/prometheus:v2.53.0` (official public image)
- **Config:** Scrapes all Spring Boot services at `/actuator/prometheus` endpoint every 15 seconds
- **Services monitored:**
  - api-gateway (8080)
  - customers-service (8081)
  - visits-service (8082)
  - vets-service (8083)
- **Storage:** In-memory TSDB (data lost on pod restart; add persistent volume for production)

### Grafana
- **Image:** `grafana/grafana:11.3.0` (official public image)
- **Default credentials:** `admin` / `petclinic` (override via `--set grafana.adminPassword=<secret>`)
- **Datasource:** Automatically configured to connect to Prometheus at `http://prometheus:9090`
- **Dashboard:** Pre-loaded "Spring Petclinic Metrics" dashboard with:
  - HTTP request latency (avg/max response time)
  - HTTP request activity (ok vs error rates)
  - Business metrics (owners created/updated, pets created, visits recorded)
  - SPC business histogram (stacked bar chart of operations)
- **Anonymous access:** Enabled with Admin role (disable for production via `GF_AUTH_ANONYMOUS_ENABLED=false`)

### Zipkin
- **Image:** `openzipkin/zipkin:latest` (official public image)
- **Purpose:** Distributed tracing for microservices
- **Spring Boot integration:** Automatically configured if `spring.zipkin.base-url` is set
- **Storage:** In-memory (data lost on pod restart; production should use external storage backend)

### Enabling/Disabling Monitoring

**By environment:**
- **Dev:** Monitoring enabled (`replicaCount: 1` in `values-dev.yaml`)
- **Production:** Monitoring enabled (`replicaCount: 1` in `values-production.yaml`)

**To disable temporarily:**
```bash
# Set replicas to 0 for all monitoring services
helm upgrade petclinic . --set prometheus.replicaCount=0 --set grafana.replicaCount=0 --set zipkin.replicaCount=0
```

---

## Monitoring & Troubleshooting

### Check Workflow Status

```bash
# List recent runs
gh run list --workflow cd.yml --limit 5

# View logs for a run
gh run view <RUN_ID> --log
```

### Check Pod Deployment

```bash
# Watch pods in dev namespace
kubectl get pods -n dev -w

# View pod logs
kubectl logs -n dev <POD_NAME>

# Describe pod for events
kubectl describe pod -n dev <POD_NAME>
```

### Check ArgoCD Status

```bash
# List applications
kubectl get applications -n argocd

# Get detailed status
argocd app get petclinic-dev

# Manually sync
argocd app sync petclinic-dev --force
```

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| `ImagePullBackOff` | ECR image not found | Verify `docker push` succeeded in workflow logs; check ECR repository |
| `ErrImagePull` with `InvalidImageName` | values file not updated | Check workflow job 2 logs; verify yq command ran |
| `Pending` (init containers) | Waiting for config-server | Check config-server pod; verify network connectivity |
| ArgoCD app stays `OutOfSync` | Git credentials missing | Verify repo URL is accessible; check ArgoCD repo credentials |
| `[skip ci]` not preventing CI | Branch protection rules | Update branch rules if PR-based CI is required |

### Access Services

```bash
# API Gateway (main entry point)
kubectl port-forward -n dev svc/api-gateway 8080:8080
# http://localhost:8080

# Eureka (service discovery)
kubectl port-forward -n dev svc/discovery-server 8761:8761
# http://localhost:8761

# Prometheus (metrics database)
kubectl port-forward -n dev svc/prometheus 9090:9090
# http://localhost:9090/graph

# Grafana (metrics dashboards)
kubectl port-forward -n dev svc/grafana 3000:3000
# http://localhost:3000 (admin / petclinic)

# Zipkin (distributed tracing)
kubectl port-forward -n dev svc/zipkin 9411:9411
# http://localhost:9411/zipkin/
```

---

## Manual Operations

### Manually Trigger a Deployment

If you need to redeploy without code changes:

```bash
# Via ArgoCD CLI
argocd app sync petclinic-dev --force

# Via kubectl (force pod restart)
kubectl rollout restart deployment -n dev
```

### Update Image Tag Without Push

```bash
# Edit values file
yq -i '.global.imageTag = "dev-123"' helm/values-dev.yaml

# Commit manually
git add helm/values-dev.yaml
git commit -m "chore: manual bump to dev-123"
git push origin Dev
```

### Rollback to Previous Deployment

```bash
# Undo the last commit
git revert HEAD
git push origin Dev

# Or, reset to specific commit
git reset --hard <COMMIT_SHA>
git push --force origin Dev
```

---

## Security Considerations

1. **Secrets:** Never commit `ARGOCD_PASSWORD` or `GH_PAT` to the repository
2. **IAM:** Use least-privilege IAM policies; rotate access keys regularly
3. **RBAC:** Limit ArgoCD's permissions via Kubernetes RBAC in `argocd` namespace
4. **Branch Protection:** Enforce PR reviews on `main` to prevent unauthorized deployments
5. **Image Scanning:** Enable ECR image scanning to detect vulnerabilities before deployment
6. **Audit Logging:** Enable CloudTrail for AWS API calls and ArgoCD audit logs for git operations

---

## Reference

- **Spring PetClinic:** https://github.com/spring-petclinic/spring-petclinic-microservices
- **ArgoCD Docs:** https://argo-cd.readthedocs.io/
- **Helm Docs:** https://helm.sh/docs/
- **AWS EKS:** https://docs.aws.amazon.com/eks/
