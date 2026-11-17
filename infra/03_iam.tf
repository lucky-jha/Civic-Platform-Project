# 1. The Role that EKS will use to manage AWS resources
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.project_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  tags = {
    Project     = var.project_name
    Environment = "prod"
  }
}

# 2. Attach the basic policy so EKS can actually work
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Output the role ARN (Amazon Resource Name) so we can use it in the next step
output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}