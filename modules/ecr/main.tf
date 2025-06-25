# Check if an ECR exists
data "aws_ecr_repository" "existing" {
  count = var.repo_exists ? 0 : 1
  name  = var.ecr_name
}

# Create new ECR for Docker image if it doesn't.
resource "aws_ecr_repository" "ecr_repo" {
  count = var.repo_exists ? 1 : 0
  name  = var.ecr_name

  image_tag_mutability = "MUTABLE"
}

#
locals {
  ecr_repo_url = var.repo_exists ? aws_ecr_repository.ecr_repo[0].repository_url : data.aws_ecr_repository.existing[0].repository_url
  ecr_repo_arn = var.repo_exists ? aws_ecr_repository.ecr_repo[0].arn : data.aws_ecr_repository.existing[0].arn
}