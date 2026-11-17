module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "3.2"

  repository_name = "${var.project_name}-ecr"

  repository_read_write_access_arns = ["*"]

  repository_force_delete = true

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 10 images",
        selection = {
          tagStatus   = "any",
          countType   = "imageCountMoreThan",
          countNumber = 10
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    project     = var.project_name
    Environment = "prod"
  }
}
output "ecr_repository_url" {
  value = module.ecr.repository_url
}