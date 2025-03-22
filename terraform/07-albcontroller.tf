module "alb_controller" {
  source                           = "./modules/albcontroller"
  cluster_name                     = "assessment"
  cluster_identity_oidc_issuer     = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer
  cluster_identity_oidc_issuer_arn = data.aws_iam_openid_connect_provider.oidc_provider.arn
  aws_region                       = "us-east-1"
  vpc_id                           = module.vpc.vpc_id
}
