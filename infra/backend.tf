terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28.0"
    }
  }

  # Here is where we tell Terraform to store the state in S3!
  backend "s3" {
    bucket       = "civic-platform-tfstate-lucky" # Use the output from the bootstrap step
    key          = "prod/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = var.aws_region
}