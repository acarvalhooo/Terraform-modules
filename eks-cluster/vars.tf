variable "tags" {
  description = "Resource tags"
  default     = {}
  type        = map(any)
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "EKS cluster version"
  default     = "1.29"
  type        = string
}

variable "enabled_cluster_log_types" {
  description = "Control plane logs to enable. Possible values are: api, audit, authenticator, controllerManager e scheduler"
  default     = []
  type        = list(string)
}

variable "subnet_ids" {
  description = "Subnet IDs that the cluster and node groups must be created"
  type        = list(string)
}

variable "spot_node_group" {
  description = "Quantity of node groups that use spot instances"
  default     = 1
  type        = number
}

variable "spot_min_size" {
  description = "Min quantity of spot instances in the node group"
  default     = 0
  type        = number
}

variable "spot_desired_size" {
  description = "Desired quantity of spot instances in the node group"
  default     = 1
  type        = number
}

variable "spot_max_size" {
  description = "Max quantity of spot instances in the node group"
  default     = 2
  type        = number
}

variable "ami_type" {
  description = "Nodes AMI type"
  default     = "AL2_x86_64"
  type        = string
}

variable "disk_size" {
  description = "Nodes disk size"
  default     = 50
  type        = number
}

variable "instance_types" {
  description = "Nodes instance types"
  default     = ["m5a.2xlarge", "m6a.2xlarge"]
  type        = list(string)
}

variable "on_demand_node_group" {
  description = "Quantity of node groups that use on-demand instances"
  default     = 1
  type        = number
}

variable "on_demand_min_size" {
  description = "Min quantity of on-demand instances in the node group"
  default     = 0
  type        = number
}

variable "on_demand_desired_size" {
  description = "Desired quantity of on-demand instances in the node group"
  default     = 1
  type        = number
}

variable "on_demand_max_size" {
  description = "Max quantity of on-demand instances in the node group"
  default     = 2
  type        = number
}

variable "coredns_version" {
  description = "CoreDNS add-on version"
  default     = "v1.11.1-eksbuild.9"
  type        = string
}

variable "kube_proxy_version" {
  description = "Kube-Proxy add-on version"
  default     = "v1.29.3-eksbuild.2"
  type        = string
}

variable "vpc_cni_version" {
  description = "VPC-CNI add-on version"
  default     = "v1.18.1-eksbuild.3"
  type        = string
}