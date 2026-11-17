module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name               = "${var.project_name}-cluster"
  cluster_version            = "1.30"

  # Give the cluster the IAM role we just created
  # Fix : v20+ manages its own role by default. If using a pre-created role, 
  # you must explicitly disable creation and use the correct attribute name.
  create_iam_role = false   
  iam_role_arn    = aws_iam_role.eks_cluster_role.arn

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # allow your computer to talk with to the cluster
  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    main = {
        min_size = 1
        max_size = 3
        desire_size = 2

        instance_type = ["t3.medium"]

        #this permission allow all node to pull image from Docker image from ecr
        iam_role_additional_policies = {
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        }
    }
  }
  tags = {
    project = var.project_name
    enviroment   = "prod"
  }
}

output "eks_cluster_name" {
    value = module.eks.cluster_name
}
output "oidc_provider_arn" {
    value = module.eks.oidc_provider_arn
}
