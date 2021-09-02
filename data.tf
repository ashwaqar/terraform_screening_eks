data "aws_vpc" "eks" {
  id = var.vpc_id
}

data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.eks.id]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.eks.id

  tags = {
    Name = "*${local.prefix}-private*"
  }

  depends_on = [
    aws_subnet.private
  ]
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.eks.id

  tags = {
    Name = "*${local.prefix}-public*"
  }

  depends_on = [
    aws_subnet.public
  ]
}

data "aws_ami" "ec2_latest" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"

    values = [
      "amazon-eks-node-1.19-v20210628",
    ]
  }
}

data "aws_launch_template" "bastion" {
  name = "${local.prefix}-bastion"
}

data "template_file" "userdata" {
  template = file("${path.module}/templates/userdata.tpl")

  vars = {
    cluster_name         = var.cluster_name
    bootstrap_extra_args = var.bootstrap_extra_args
  }
}

data "aws_eks_cluster" "eks" {
  name = var.cluster_name
}

data "tls_certificate" "eks" {
  url = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
}