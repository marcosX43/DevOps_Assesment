resource "aws_eks_addon" "addons" {
  for_each                 = { for addon in var.addons : addon.name => addon }
  cluster_name             = aws_eks_cluster.assessment.id
  addon_name               = each.value.name
  addon_version            = each.value.version
  service_account_role_arn = each.value.name == "vpc-cni" ? aws_iam_role.aws-node.arn : aws_iam_role.ebs_csi_driver.arn
}
