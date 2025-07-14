# Wind Grunt EKS

This project automates the deployment of the **Weather API App** using **AWS EKS**, **Terraform**, **Docker**, and **CI/CD pipelines**. Originally set up manually using **AWS Console**, the process has been automated to provide a secure, scalable, and streamlined deployment.

<br>

## Overview

The **Weather API App** is a containerised Node.js application deployed on **AWS EKS** using **Helm** and **Argo CD**. The deployment process is fully automated using a **CI/CD pipeline** that handles Docker image building, vulnerability scanning, and deployment to different AWS environments through **Terragrunt**.

<br>

This setup uses:


- **Cert Manager** to automate the issuing and renewal of TLS certificates.

- **External DNS** to dynamically manage Route 53 records based on Kubernetes ingress resources, eliminating manual DNS configuration.

- **Argo CD** for GitOps-based deployments, ensuring the cluster always reflects the state defined in the Git repository.

- **Prometheus & Grafana** to collect cluster metrics and provide dashboards for visualising cluster metrics in real time.

<br>

## Architecture Diagram

![AD](https://raw.githubusercontent.com/JunedConnect/project-bravo-terragrunt/main/images/Architecture%20Diagram.png)

<br>

## Key Components:

- **Dockerisation**: The app is containerised using a **Dockerfile**, utilising multi-stage builds.

- **Infrastructure as Code (IaC)**:

    - **Terragrunt** simplifies and manages Terraform modules across environments, avoiding repetition and centralising shared configuration.

    - **Terraform** provisions the following AWS resources:
        - **VPC, Subnets, NAT Gateway, and Security Groups** for network architecture.
        - **Route 53** for DNS management.
        - **Amazon EKS** for managing Kubernetes cluster.
        - **IAM Roles for Service Accounts (IRSA)** to securely allow Kubernetes service accounts to assume AWS IAM roles.
        - **Helm Charts** to deploy Argo CD, NGINX Ingress, Cert Manager, External DNS, Prometheus & Grafana.

- **CI/CD Pipeline**: GitHub Actions automate:
    - Building and pushing the Docker image to **Amazon ECR.
    - Performing security and compliance scans to ensure code quality and security.
    - Applying Terraform to deploy AWS infrastructure.
    - Deploying Kubernetes manifests and Helm charts.
    - Destroying Terraform resources when necessary.

<br>

## Directory Structure

```
./
├── app
│   └── Dockerfile
├── argocd
│   ├── apps
│   │   └── weather-app.yml
│   └── argocd-git.yml
├── cert-man
│   └── issuer.yml
└── terraform
│   ├── environments
│   │   ├── dev
│   │   │   ├── dev.tfvars
│   │   │   └── env.hcl
│   │   ├── prod
│   │   │   ├── prod.tfvars
│   │   │   └── env.hcl
│   │   └── root.hcl
│   ├── helm-values
│   │   ├── argo-cd.yml
│   │   ├── cert-manager.yml
│   │   ├── external-dns.yml
│   │   └── prom-graf.yml
│   └── modules
│       ├── eks
│       ├── helm
│       ├── irsa
│       ├── route53
│       └── vpc
└── .github
    └── workflows
        ├── DockerBuild&Deploy.yml
        ├── TerragruntPlan.yml
        ├── TerragruntApply.yml
        └── TerragruntDestroy.yml
```

- **Docker File** (`app/`):
    - **Dockerfile**: Builds and configures the Node.js app for container deployment.

- **Argo CD Configs** (`argocd/`):
    - **apps/app.yml**: Defines Kubernetes application deployment, service, and ingress resources.
    - **argocd-git.yml**: Configures Argo CD to manage the app using GitOps.

- **Certificate Management** (`cert-man/`):
    - **issuer.yml**: Sets up a ClusterIssuer using Let's Encrypt for TLS certificates.

- **Terragrunt Configuration** (`terraform/environments/`):
    - **Dev** & **Prod**: Environment-specific folders that define what infrastructure modules to deploy.
    - **Modules** : Each contains a terragrunt.hcl that wraps around it.
    - **dev.tfvars** / **prod.tfvars**: Environment-specific variable values.
    - **env.hcl**: Shared settings for the specified environment (region, tags, remote state).
    - **root.hcl**: Global Terragrunt config i.e.inherited by all environments.

- **Helm Values** (`terraform/helm-values`):
    - **Helm values** for Argo CD, Cert Manager, External DNS, Prometheus & Grafana.

- **Terraform Modules** (`terraform/modules`):
    - **modules/eks**: Creates the EKS cluster and node groups.
    - **modules/helm**: Installs core Kubernetes tools via Helm.
    - **modules/irsa**: Sets up IRSA for Kubernetes resources to access to AWS services.
    - **modules/route53**: Manages DNS hosted zone.
    - **modules/vpc**: Provisions the full VPC setup.

- **CI/CD Pipelines** (`.github/workflows/`): See below

<br>


## CI/CD Deployment Workflow

The deployment process is fully automated via GitHub Actions:

1. **Docker Image Build & Deployment** (`DockerBuild&Deploy.yml`):
    - Builds the Docker image.
    - Runs **Trivy** to scan for critical vulnerabilities before pushing to ECR.
    - Pushes the image to **Amazon ECR**.

2. **Terragrunt Plan** (`TerragruntPlan.yml`):
    - Initialises the Terragrunt directory.
    - Previews the necessary AWS resources.
    - Runs **TFLint** to validate Terraform syntax and best practices.
    - Runs **Checkov** to scan for security issues within Terraform code.

3. **Terragrunt Apply** (`TerragruntApply.yml`):
    - Applies the Terragrunt configuration.
    - Provisions the necessary AWS resources
    - Deploys Argo CD configuration for app deployment, and cert-manager issuer.

4. **Terragrunt Destroy** (`TerragruntDestroy.yml`):
    - Destroys all AWS resources provisioned by Terragrunt.

<br>

To trigger any of these workflows, navigate to **GitHub Actions** and manually run the relevant workflow.

<br>

|Here’s what it will look like:|
|-------|
|Application Page:|
| ![App](https://raw.githubusercontent.com/JunedConnect/project-bravo-terragrunt/main/images/App%20Page.png) |
|SSL Certificate:|
| ![SSL](https://raw.githubusercontent.com/JunedConnect/project-bravo-terragrunt/main/images/SSL%20Certificate.png) |
|Argo CD:|
| ![ArgoCD](https://raw.githubusercontent.com/JunedConnect/project-bravo-terragrunt/main/images/ArgoCD%20Page.png) |
|Prometheus:|
| ![Prometheus](https://raw.githubusercontent.com/JunedConnect/project-bravo-terragrunt/main/images/Prometheus%20Page.png) |
|Grafana Dashboard:|
| ![Grafana](https://raw.githubusercontent.com/JunedConnect/project-bravo-terragrunt/main/images/Grafana%20Dashboard.png) |
