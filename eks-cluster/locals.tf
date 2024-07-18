locals {
  cluster_role_name         = "EKSClusterRole-${var.cluster_name}"
  key_name                  = "alias/${var.cluster_name}-kms-key"
  node_group_role_name      = "EKSNodeGroupRole-${var.cluster_name}"
  spot_node_group_name      = "${var.cluster_name}-node-group-spot"
  on_demand_node_group_name = "${var.cluster_name}-node-group-on-demand"
}