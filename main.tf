provider "aws" {
  region = var.region
}

module "gh-eks-cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.1.0"

  cluster_version = var.kubernetes_version

  cluster_name = var.cluster_name
  vpc_id       = var.vpc_id
  subnets      = concat(aws_subnet.public.*.id, aws_subnet.private.*.id)

  manage_aws_auth = false

  cluster_enabled_log_types = var.cluster_enabled_log_types

  enable_irsa = true
  write_kubeconfig = false

  tags = {
    environment = var.environment
  }
}