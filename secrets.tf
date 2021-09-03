data "aws_secretsmanager_secret" "ec2_bastion_ssh_public_key" {
  name = "terraform-aws-gh-screening-eks/${var.environment}"
}

data "aws_secretsmanager_secret_version" "ec2_bastion_ssh_public_key_current" {
  secret_id = data.aws_secretsmanager_secret.ec2_bastion_ssh_public_key.id
}