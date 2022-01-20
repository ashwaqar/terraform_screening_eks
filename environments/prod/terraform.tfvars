vpc_id = "vpc-019b33de635498d06"

cluster_name = "prod"
environment = "prod"

private_subnet_cidr = ["10.231.17.0/24", "10.231.18.0/24", "10.231.19.0/24"]
public_subnet_cidr = ["10.231.20.0/24", "10.231.21.0/24", "10.231.22.0/24"]

additional_private_routes = [
  {
    // Virtual gateway (direct connect)
    cidr_block = "10.4.0.0/16"
    gateway_id = "vgw-099fd2aaf7d1795a9"
  },
  {
    cidr_block = "10.216.0.0/22"
    gateway_id = "vgw-099fd2aaf7d1795a9"
  },
  {
    cidr_block = "10.112.0.0/21",
    gateway_id = "vgw-099fd2aaf7d1795a9"
  },
  {
    cidr_block = "10.13.0.0/16",
    gateway_id = "vgw-099fd2aaf7d1795a9"
  },
  {
  cidr_block = "10.12.0.0/16",
  gateway_id = "vgw-099fd2aaf7d1795a9"
  },
]
additional_public_routes  = [
  {
    // Virtual gateway (direct connect)
    cidr_block = "10.4.0.0/16"
    gateway_id = "vgw-099fd2aaf7d1795a9"
  },
  {
    cidr_block = "10.215.0.0/22"
    gateway_id = "vgw-099fd2aaf7d1795a9"
  },
  {
    cidr_block = "10.112.0.0/21",
    gateway_id = "vgw-099fd2aaf7d1795a9"
  },
  {
    cidr_block = "10.13.0.0/16",
    gateway_id = "vgw-099fd2aaf7d1795a9"
  },
  {
    cidr_block = "10.12.0.0/16",
    gateway_id = "vgw-099fd2aaf7d1795a9"
  },
]

# node group scale
desired_size = 1
max_size     = 6
min_size     = 1
