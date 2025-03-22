# CodeBuild.tf
resource "aws_codebuild_project" "temp-api-codebuild" {
  name          = "temp-api"
  build_timeout = "5"                         # Timeout 5 minutes for this build
  service_role  = aws_iam_role.build-role.arn # Our role we specified above

  # Specifying where our artifacts should reside
  artifacts {
    type           = "S3"
    location       = aws_s3_bucket.codepipeline_bucket.bucket
    name           = "temp-api-build-artifacts"
    namespace_type = "BUILD_ID"
  }

  # Enviroments specifying the codebuild image and some enviromental variables, privileged mode enables us to access higher privilages when in build mode. It's very important to for example start the docker service and it won't work unless specified true.
  environment {
    privileged_mode             = true
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = "prod-temp-api" # My github repository name
    }
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "us-east-1" # My AZ
    }
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = "418272781513"
    }

  }
  # Here i specify where to find the source code for building. in our case buildspec.yaml which resides in our repo. You can omit using a buildspec file and just specify the steps here. Refer to terraform documentation for this.
  source {
    type            = "GITHUB"
    location        = "https://github.com/marcosX43/DevOps_Assesment.git"
    git_clone_depth = 1
    buildspec       = "buildspec.yaml"
  }
}
