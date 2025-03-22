# resource "aws_iam_role" "aws_node" {
#   name               = "aws-node-role"
#   assume_role_policy = templatefile("oidc_assume_role_policy.json", { OIDC_ARN = aws_iam_openid_connect_provider.eks.arn, OIDC_URL = replace(aws_iam_openid_connect_provider.eks.url, "https://", ""), NAMESPACE = "kube-system", SA_NAME = "aws-node" })
#   depends_on         = [aws_iam_openid_connect_provider.eks]
# }
# resource "aws_iam_role_policy_attachment" "aws_node" {
#   role       = aws_iam_role.aws_node.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   depends_on = [aws_iam_role.aws_node]
# }

resource "aws_iam_role" "ebs_csi_driver" {
  name               = "ebs-csi-driver"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_driver_assume_role.json
}

data "aws_iam_policy_document" "ebs_csi_driver_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.eks.url}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.eks.url}:sub"
      values = [
        "system:serviceaccount:kube-system:ebs-csi-controller-sa",
        "system:serviceaccount:kube-system:ebs-csi-node-sa"
      ]
    }

  }
}

resource "aws_iam_role_policy_attachment" "AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_driver.name
}

#### AWS Node SA Role ####

resource "aws_iam_role" "aws-node" {
  name               = "aws-node"
  assume_role_policy = data.aws_iam_policy_document.aws_cni_assume_role.json
}


data "aws_iam_policy_document" "aws_cni_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.eks.url}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.eks.url}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.aws-node.name
}
