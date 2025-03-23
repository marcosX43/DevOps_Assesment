# DevOps Technical Assessment: EKS, Terraform, Docker, and CI/CD Pipeline

## Objective
The goal of this assessment is to create an AWS EKS cluster using Terraform, deploy a Docker-based web application, and set up a CI/CD pipeline to automate the deployment using Helm.

## Folder Structure
```
DEVOPS_ASSESSMENT/
│-- temp-api/              # Web application source code
│-- temp-api-chart/        # Helm chart for deployment
│-- terraform/             # Terraform scripts for EKS setup
│-- .gitignore             # Git ignore file
│-- buildspec.yaml         # Build specification for CI/CD pipeline
│-- README.md              # Documentation
```

## Requirements
### 1. Infrastructure Setup (Terraform + AWS EKS)
- Use Terraform to provision an EKS cluster.
- Ensure the cluster has:
  - At least 2 worker nodes (instance type: `t3.medium`).
  - Required IAM roles, security groups, and networking components (VPC, subnets, etc.).
  - `kubectl` configured to interact with the cluster.

### 2. Application (Docker + Kubernetes)
- Develop a simple web application (Flask, Node.js, or any preferred language).
- The application should expose a REST API endpoint (`/health`) returning `{ "status": "ok" }`.
- Dockerize the application and push the image to a container registry (ECR, Docker Hub, or Harbor).

### 3. Deployment (Helm Chart + Kubernetes)
- Create a Helm chart to deploy the application in EKS.
- Ensure the Helm chart supports:
  - Configurable replicas (default: 2).
  - A Kubernetes Service for internal access.

### 4. CI/CD Pipeline (AWS CodePipeline / GitHub Actions / GitLab CI)
- Automate the build and deployment process:
  - Build and push the Docker image when code is committed.
  - Deploy the application to EKS using Helm after a successful build.
  - Ensure Helm releases can be upgraded without downtime.

## Bonus (Optional)
- Implement an Ingress (NGINX Ingress Controller) or ALB for external access.

## Setup Instructions
### Prerequisites
Ensure you have the following installed:
- AWS CLI
- Terraform
- kubectl
- Helm
- Docker
- Git

### Step 1: Provision the EKS Cluster
```sh
cd terraform
terraform init
terraform apply -auto-approve
```

### Step 2: Deploy the Application
```sh
cd temp-api-chart
helm install temp-api ./ --namespace default
```

### Step 3: CI/CD Pipeline
- Configure your CI/CD pipeline using AWS CodePipeline or GitHub Actions.
- Ensure it builds, pushes the Docker image, and deploys the Helm chart.

## Submission
Provide a GitHub repository containing:
- Terraform code for EKS.
- Dockerized application.
- Helm chart.
- CI/CD pipeline configuration.

## Contact
For any queries, reach out via email or create an issue in the GitHub repository.

