resource "aws_launch_template" "bastion" {
  image_id               = data.aws_ami.ec2_latest.id
  name                   = "${local.prefix}-bastion"
  update_default_version = true
  instance_type          = "t2.small"
  key_name               = aws_key_pair.deployer.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.gh_vpn.id]

  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${local.prefix}-bastion"
    }
  }
}

resource "aws_autoscaling_group" "bastion_asg" {
  name = "${local.prefix}-bastion"

  launch_template {
    id      = aws_launch_template.bastion.id
    version = "$Latest"
  }

  # Auto scaling group
  vpc_zone_identifier       = data.aws_subnet_ids.public.ids
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "kubernetes.io/cluster/${var.cluster_name}"
      value               = "owned"
      propagate_at_launch = true
    }
  ]
}