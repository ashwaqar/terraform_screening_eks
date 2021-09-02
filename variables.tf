variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "kubernetes_version" {
  type    = string
  default = "1.20"
}

variable "cluster_name" {
  type = string
}

variable "map_roles" {
  type        = list(string)
  default     = []
  description = "Additional IAM roles to add to the aws-auth configmap."
}

variable "gh_vpn_whitelist" {
  type = list(string)
  default = [
    "10.4.0.0/16",
    "50.233.156.0/29",
    "12.226.152.72/29",
    "10.112.0.0/21",
    "10.12.0.0/16",
    "10.8.0.0/16",
    "10.117.0.0/16"
  ]
  description = "whitelist for GH network"
}

variable "private_subnet_cidr" {
  default     = []
  type        = list(any)
  description = "Private Subnet CIDR"
}

variable "public_subnet_cidr" {
  default     = []
  type        = list(any)
  description = "Public Subnet CIDR"
}

variable "additional_private_routes" {
  type    = list(map(string))
  default = []
}

variable "additional_public_routes" {
  type    = list(map(string))
  default = []
}

variable "cluster_enabled_log_types" {
  type    = list(string)
  default = []
}

variable "cluster_endpoint_private_access_cidrs" {
  type    = list(string)
  default = []
}

variable "cluster_endpoint_private_access_sg" {
  type    = list(string)
  default = []
}

variable "desired_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "bootstrap_extra_args" {
  type        = string
  default     = "--enable-docker-bridge true"
  description = "Extra arguments to the `bootstrap.sh` script to enable `--enable-docker-bridge` or `--use-max-pods`"
}

variable "write_kubeconfig" {
  type    = bool
  default = false
}
