vpc_id = "vpc-06f50169539b321a2"

cluster_name = "dev"
environment = "dev"

private_subnet_cidr = ["172.16.17.0/24", "172.16.18.0/24", "172.16.19.0/24"]
public_subnet_cidr = ["172.16.20.0/24", "172.16.21.0/24", "172.16.22.0/24"]

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
]

# node group scale
desired_size = 1
max_size     = 1
min_size     = 1
