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


## Setup Instructions
### Prerequisites
Ensure you have the following installed:
- AWS CLI
- Terraform
- kubectl
- Helm
- Docker
- Git

### Step 1: Provision the EKS Cluster and CI/CD Pipeline
```sh
cd terraform
terraform init
terraform apply
```

### Deploy the Application
- Once the terraform script provision the resources successfully, it will automatically deploy the application
- For the manual deployment, Please use the following command
```sh
cd temp-api-chart
helm install temp-api ./ --namespace default
```

### Step 3: CI/CD Pipeline
- For Configuring the CI/CD Pipeline I have used AWS CodePipeline. Whenever the code pushed to `main` branch, It will deploy the latest changes,


