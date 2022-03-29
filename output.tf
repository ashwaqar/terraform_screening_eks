output "cluster_name" {
  value = var.cluster_name
}

/*

output "worker_role_arn" {
  value = module.gh-eks-cluster.worker_iam_role_arn
}

output "worker_node_groups" {
  value = module.gh-eks-cluster.node_groups
}

*/

output "cluster_platform_version" {
  value = module.gh-eks-cluster.cluster_platform_version
}