terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "Dev"
      Project     = "Testing"
    }
  }
}

terraform {
  backend "s3" {
    region = "us-east-1"
    bucket = "dpres-testing"
    key    = "terraform/tf_state"
  }
}