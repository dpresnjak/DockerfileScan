################
#### Global ####
################
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

############
#### S3 ####
############
data "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_object" "build_spec" {
  bucket = data.aws_s3_bucket.bucket.id
  key    = var.buildspec_path
  source = "${path.module}/build_source/buildspec.yml"
  etag   = filemd5("${path.module}/build_source/buildspec.yml")
}

resource "aws_s3_object" "dockerfile" {
  bucket = data.aws_s3_bucket.bucket.id
  key    = var.dockerfile_path
  source = "${path.module}/build_source/Dockerfile"
  etag   = filemd5("${path.module}/build_source/Dockerfile")
}

#############
#### ECR ####
#############

# Check if an ECR exists
data "aws_ecr_repository" "existing" {
  count = var.create_new_repo ? 0 : 1
  name  = var.ecr_name
}

# Create new ECR for Docker image if it doesn't.
resource "aws_ecr_repository" "ecr_repo" {
  count = var.create_new_repo ? 1 : 0
  name  = var.ecr_name

  image_tag_mutability = "MUTABLE"
}

#
locals {
  ecr_repo_url = var.create_new_repo ? aws_ecr_repository.ecr_repo[0].repository_url : data.aws_ecr_repository.existing[0].repository_url
  ecr_repo_arn = var.create_new_repo ? aws_ecr_repository.ecr_repo[0].arn : data.aws_ecr_repository.existing[0].arn
}


#############
#### IAM ####
#############
module "iam" {
  source                = "./modules/iam"
  bucket_arn            = data.aws_s3_bucket.bucket.arn
  account_id            = data.aws_caller_identity.current.account_id
  region                = data.aws_region.current.name
  codebuild_role_name   = var.codebuild_role_name
  codebuild_policy_name = var.codebuild_policy_name
  ecr_repo_arn          = local.ecr_repo_arn
}

###############
#### Build ####
###############
module "build" {
  source              = "./modules/codebuild"
  region              = data.aws_region.current.name
  account_id          = data.aws_caller_identity.current.account_id
  bucket_name         = var.bucket_name
  ecr_uri             = local.ecr_repo_url
  codebuild_role      = module.iam.codebuild_role
  image_repo_name     = var.ecr_name
  codebuild_proj_name = var.codebuild_proj_name
  s3_codebuild_source = var.s3_codebuild_source
}