variable "bucket_arn" {
  type = string
}

variable "account_id" {
  type = string
}

variable "region" {
  type = string
}

variable "codebuild_role_name" {
  description = "IAM Role name for CodeBuild role."
  type        = string
}

variable "codebuild_policy_name" {
  description = "IAM Policy name for CodeBuild policy."
  type        = string
}