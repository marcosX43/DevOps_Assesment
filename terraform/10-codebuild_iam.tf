data "aws_iam_policy_document" "build_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
# We create the role and bind the trust relationship with it
resource "aws_iam_role" "build-role" {
  name               = "codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.build_assume_role.json
}


# First access to ECR for pulling and pushing images to it
resource "aws_iam_policy" "build-ecr" {
  name = "ECRPOLICY"
  policy = jsonencode({
    "Statement" : [
      {
        "Action" : [
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetAuthorizationToken",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
    ],
    "Version" : "2012-10-17"
  })
}


resource "aws_iam_role_policy_attachment" "attachmentsss" {
  role       = aws_iam_role.build-role.name
  policy_arn = aws_iam_policy.build-ecr.arn
}

data "aws_iam_policy_document" "build-policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
    ]

    resources = ["*"]
  }
  statement {
    effect = "Allow"

    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters",
      "eks:DescribeNodegroup",
      "eks:ListNodegroups",
      "eks:AccessKubernetesApi"
    ]

    resources = ["arn:aws:eks:us-east-1:418272781513:cluster/assessment"]
  }


  statement {
    effect    = "Allow"
    actions   = ["ec2:CreateNetworkInterfacePermission"]
    resources = ["*"]


    condition {
      test     = "StringEquals"
      variable = "ec2:AuthorizedService"
      values   = ["codebuild.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]
    resources = [
      aws_s3_bucket.codepipeline_bucket.arn,
      "${aws_s3_bucket.codepipeline_bucket.arn}/*"
    ]
  }
}

# Attaching the previous policy
resource "aws_iam_role_policy" "s3_access" {
  role   = aws_iam_role.build-role.name
  policy = data.aws_iam_policy_document.build-policy.json
}
