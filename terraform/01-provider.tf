provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
data "aws_eks_cluster" "cluster" {
  depends_on = [aws_eks_cluster.assessment]
  name       = "assessment"
}
data "aws_eks_cluster_auth" "cluster" {
  depends_on = [aws_eks_cluster.assessment]
  name       = "assessment"
}
data "aws_iam_openid_connect_provider" "oidc_provider" {
  depends_on = [aws_iam_openid_connect_provider.eks]
  url        = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  }
}
