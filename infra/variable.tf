variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "name of the project , used to tag all the resouces"
  type        = string
  default     = "civic-platform"
}

variable "vpc_cidr" {
  description = "CIDR block for vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet" {
  description = "CIDR BLOCK FOR PUBLIC SUBNET"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"] #here we r using list for 2 subnet we can access using index value
}

variable "private_subnet" {
  description = "CIDR BLOCK FOR PRIVATE SUBNET"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}
