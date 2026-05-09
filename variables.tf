variable "aws_region" {
  description = "AWS region where the EKS cluster exists"
  type        = string
  default     = "us-east-1"
}

variable "eks_cluster_name" {
  description = "Name of the existing EKS cluster"
  type        = string
  default     = "student1-cluster"
}
