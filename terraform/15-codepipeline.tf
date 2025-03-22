resource "aws_codepipeline" "codepipeline" {
  name     = "temp-api-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn
  # Specifying the artifact store
  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }


  stage {
    name = "Source"
    # Telling codepipeline to pull from third party (github) 
    action {
      name             = "GitHub_Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      # the output of the source(which is the source code) gets added in a directory called source_output in our s3 bucket
      configuration = {
        ConnectionArn    = var.connection_arn
        FullRepositoryId = "DevOps_Assesment"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"
    # Build stage takes in input from source_output dir (source code) & we provide it only with the codebuild id we created from the first step.
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.temp-api-codebuild.name
      }
    }
  }
}
