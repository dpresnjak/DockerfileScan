output "ecr_uri" {
  value = local.ecr_repo_url
}

output "ecr_arn" {
  value = local.ecr_repo_arn
}

output "repository_name" {
  value = var.ecr_name
}

output "s3_arn" {
  value = data.aws_s3_bucket.bucket.arn
}

output "s3" {
  value = data.aws_s3_bucket.bucket.id
}