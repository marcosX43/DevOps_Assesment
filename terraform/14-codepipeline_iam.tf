# Codepipeline.tf
# Our trust relationship
data "aws_iam_policy_document" "pipeline_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
# Our pipeline role
resource "aws_iam_role" "codepipeline_role" {
  name               = "pipeline-role"
  assume_role_policy = data.aws_iam_policy_document.pipeline_assume_role.json
}

# Our policies, allows S3 access for artifacts and codebuild access to start builds.
data "aws_iam_policy_document" "codepipeline_policy" {
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

  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "codestar-connections:GetConnection",
      "codestar-connections:UseConnection",
      "codestar-connections:ListConnections"
    ]

    resources = ["*"]
  }
}
# Binding the policy document to our role.
resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}

resource "aws_iam_policy_attachment" "eks_access" {
  name       = "CodePipelineEKSAccess"
  roles      = [aws_iam_role.codepipeline_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


resource "aws_iam_policy" "codepipeline_eks_access" {
  name        = "CodePipelineEKSAccess"
  description = "Allow CodePipeline to describe EKS clusters"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "eks:DescribeCluster"
        Resource = "arn:aws:eks:us-east-1:418272781513:cluster/assessment"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_eks_attach" {
  role       = aws_iam_role.codepipeline_role.id
  policy_arn = aws_iam_policy.codepipeline_eks_access.arn
}

data "aws_iam_policy_document" "codepipelinelogs_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "codepipeline_logs_policy" {
  name        = "CodePipelineCloudWatchLogsPolicy"
  description = "Allows CodePipeline to write logs to CloudWatch"
  policy      = data.aws_iam_policy_document.codepipelinelogs_policy.json
}

resource "aws_iam_role_policy_attachment" "codepipeline_logs_attachment" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_logs_policy.arn
}


resource "kubernetes_config_map_v1_data" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  force = true

  data = {
    mapRoles = <<YAML
    - rolearn: ${aws_iam_role.codepipeline_role.arn}
      username: build-role
      groups:
        - system:masters
    YAML
  }
}
