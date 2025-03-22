variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))

  default = [
    {
      name    = "kube-proxy"
      version = "v1.32.0-eksbuild.2"
    },
    {
      name    = "vpc-cni"
      version = "v1.19.2-eksbuild.1"
    },
    {
      name    = "coredns"
      version = "v1.11.4-eksbuild.2"
    },
    {
      name    = "aws-ebs-csi-driver"
      version = "v1.41.0-eksbuild.1"
    }
  ]
}

variable "connection_arn" {
  default = "arn:aws:codeconnections:us-east-1:418272781513:connection/50f70548-824d-4ddc-808c-ab070443081f"
}
