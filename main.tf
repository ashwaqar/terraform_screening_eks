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

  tags = {
    environment = var.environment
  }
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
}