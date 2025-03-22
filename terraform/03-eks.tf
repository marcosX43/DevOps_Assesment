resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"
  tags = {
    tag-key = "eks-cluster-role"
  }

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "eks.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

# eks policy attachment

resource "aws_iam_role_policy_attachment" "demo-AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# bare minimum requirement of eks

resource "aws_eks_cluster" "assessment" {
  name     = "assessment"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
  }

  depends_on = [aws_iam_role_policy_attachment.demo-AmazonEKSClusterPolicy]
}


# resource "aws_eks_addon" "addons" {
#   for_each      = { for addon in var.addons : addon.name => addon }
#   cluster_name  = aws_eks_cluster.assessment.id
#   addon_name    = each.value.name
#   addon_version = each.value.version
# }
