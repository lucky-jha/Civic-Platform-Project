#in this project we gonna use vpc module by terraform it saves time and the size of code will be reduse its a compnay standard and if u want to see the vpc configuration manul one u can check the repo name cloud-deployment-project in my repo in that


#featching the availabilty zone for subnets
# 1. First, ask AWS: "What zones do you have?"
data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  #use first two availablity zone found 
  azs             = slice(data.aws_availability_zones.available.names, 0, 2) # its like bash scripting from index 0 pick 2 azs
  private_subnets = var.private_subnet
  public_subnets  = var.public_subnet

  #enable dns hosting
  enable_dns_hostnames = true
  enable_dns_support   = true

  # NAT Gateway allows private subnets (EKS nodes) to reach the internet securely
  enable_nat_gateway = true
  single_nat_gateway = true

  # Tags required for Kubernetes to discover the networ
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = {
    project    = var.project_name
    Enviroment = "prod"
  }
}
output "vpc_id" {
  value = module.vpc.vpc_id
}