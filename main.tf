provider "aws" {
  region = var.region
}

module "gh-eks-cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.4.0"

  cluster_version = var.kubernetes_version

  cluster_name = var.cluster_name
  vpc_id       = var.vpc_id
  subnet_ids   = concat(aws_subnet.public.*.id, aws_subnet.private.*.id)

  cluster_enabled_log_types = var.cluster_enabled_log_types

  enable_irsa = true

  tags = {
    environment = var.environment
  }
}