resource "aws_codebuild_project" "docker_scan" {
  name          = var.codebuild_proj_name
  service_role  = var.codebuild_role
  build_timeout = 5
  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "TRIVY_VERSION"
      value = "latest"
    }
    environment_variable {
      name  = "AWS_REGION"
      value = var.region
    }
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.account_id
    }
    environment_variable {
      name  = "REPOSITORY_URI"
      value = var.ecr_uri
    }
    environment_variable {
      name  = "REPOSITORY_NAME"
      value = var.image_repo_name
    }
  }
  source {
    type     = "S3"
    location = ("${var.bucket_name}/${var.s3_codebuild_source}/")
  }
}