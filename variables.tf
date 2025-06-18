variable "aws_region" {
  description = "Default AWS region."
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name for storing TF state and pipeline artifacts"
  type        = string
}

variable "buildspec_path" {
  description = "S3 location path for the CodeBuild project buildspec file."
  type        = string
}

variable "dockerfile_path" {
  description = "S3 location path for the CodeBuild project Dockerfile"
  type        = string
}

variable "ecr_name" {
  description = "Elastic Container Registry name."
  type        = string
}

variable "codebuild_proj_name" {
  description = "AWS CodeBuild project name."
  type        = string
}

variable "codebuild_role_name" {
  description = "IAM Role name for CodeBuild role."
  type        = string
}

variable "codebuild_policy_name" {
  description = "IAM Policy name for CodeBuild policy."
  type        = string
}

variable "create_new_repo" {
  type = bool
}

variable "s3_codebuild_source" {
  description = "Directory name used in the CodeBuild project for the S3 source."
  type        = string
}