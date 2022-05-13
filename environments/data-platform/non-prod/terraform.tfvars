vpc_id = "vpc-00117289a4618b308"

cluster_name = "non-prod"
environment = "non-prod"

private_subnet_cidr = ["10.232.4.0/24", "10.232.5.0/24", "10.232.6.0/24"]
public_subnet_cidr = ["10.232.7.0/24", "10.232.8.0/24", "10.232.9.0/24"]

additional_private_routes = [
  {
    // Virtual gateway (direct connect)
    cidr_block = "10.4.0.0/16"
    gateway_id = "vgw-0d35a64de42d2f12e"
  },
  {
    cidr_block = "10.215.0.0/22"
    gateway_id = "vgw-0d35a64de42d2f12e"
  },
  {
    cidr_block = "10.112.0.0/21",
    gateway_id = "vgw-0d35a64de42d2f12e"
  },
  {
    cidr_block = "10.13.0.0/16",
    gateway_id = "vgw-0d35a64de42d2f12e"
  },
  {
    cidr_block = "10.67.0.0/16",
    gateway_id = "pcx-0ad2a0c7bcfe2ef8b"
  },
  {
  cidr_block = "10.12.0.0/16",
  gateway_id = "vgw-0d35a64de42d2f12e"
  },
]
additional_public_routes  = [
  {
    // Virtual gateway (direct connect)
    cidr_block = "10.4.0.0/16"
    gateway_id = "vgw-0d35a64de42d2f12e"
  },
  {
    cidr_block = "10.215.0.0/22"
    gateway_id = "vgw-0d35a64de42d2f12e"
  },
  {
    cidr_block = "10.112.0.0/21",
    gateway_id = "vgw-0d35a64de42d2f12e"
  },
  {
    cidr_block = "10.13.0.0/16",
    gateway_id = "vgw-0d35a64de42d2f12e"
  },
  {
    cidr_block = "10.67.0.0/16",
    gateway_id = "pcx-0ad2a0c7bcfe2ef8b"
  },
  {
    cidr_block = "10.12.0.0/16",
    gateway_id = "vgw-0d35a64de42d2f12e"
  },
]

# node group scale
desired_size = 1
max_size     = 1
min_size     = 1
