resource "aws_key_pair" "deployer" {
  key_name   = local.prefix
  public_key = jsondecode(data.aws_secretsmanager_secret_version.ec2_bastion_ssh_public_key_current.secret_string)["bastion-public-key"]
}