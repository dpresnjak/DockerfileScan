# Global
aws_region  = "us-east-1"
bucket_name = "dpres-testing"

# ECR
ecr_name    = "trivy-ecr-scanned"
repo_exists = true

# CodeBuild
buildspec_path      = "docker-source/buildspec.yml"
dockerfile_path     = "docker-source/Dockerfile"
codebuild_proj_name = "TrivyScan"
s3_codebuild_source = "docker-source"

# IAM
codebuild_role_name   = "DockerScanCodeBuildRole"
codebuild_policy_name = "DockerScanCodeBuildPolicy"