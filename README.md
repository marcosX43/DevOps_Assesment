# DevOps Technical Assessment: EKS, Terraform, Docker, and CI/CD Pipeline

## Objective
The purpose of this assessment is to provision an AWS EKS cluster using Terraform, deploy a Docker-based web application, and configure a CI/CD pipeline to automate the deployment process using Helm.

## Project Structure
```
DEVOPS_ASSESSMENT/
│-- temp-api/              # Web application source code
│-- temp-api-chart/        # Helm chart for deployment
│-- terraform/             # Terraform scripts for EKS setup
│-- .gitignore             # Git ignore file
│-- buildspec.yaml         # Build specification for CI/CD pipeline
│-- README.md              # Documentation
```

## Setup Instructions
### Prerequisites
Ensure the following tools are installed before proceeding:
- AWS CLI
- Terraform
- kubectl
- Helm
- Docker
- Git

### Step 1: Provision the EKS Cluster and CI/CD Pipeline
Run the following commands to initialize and apply the Terraform scripts:
```sh
cd terraform
terraform init
terraform apply
```

### Step 2: Deploy the Application
- Upon successful provisioning of resources via Terraform, the application will be deployed automatically.
- To deploy the application manually, execute the following command:
```sh
cd temp-api-chart
helm install temp-api ./ --namespace default
```

### Step 3: CI/CD Pipeline Configuration
- AWS CodePipeline is used for automating deployments.
- Whenever code is pushed to the `main` branch, the latest changes will be deployed automatically.

