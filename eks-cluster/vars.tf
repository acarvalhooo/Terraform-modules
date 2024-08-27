variable "tags" {
  default     = {}
  description = "Resource tags"
  type        = map(any)
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  default     = "1.30"
  description = "EKS version"
  type        = string
}

variable "enabled_cluster_log_types" {
  default     = []
  description = "Control plane log types to enable. Allowed values are: api, audit, authenticator, controllerManager, and scheduler"
  type        = list(string)
}

variable "subnet_ids" {
  description = "IDs of the subnets where the cluster and node groups should be created"
  type        = list(string)
}

variable "spot_node_group" {
  default     = 1
  description = "Number of spot instance node groups"
  type        = number
}

variable "spot_min_size" {
  default     = 0
  description = "Minimum number of instances in the spot instance node groups"
  type        = number
}

variable "spot_desired_size" {
  default     = 1
  description = "Desired number of instances in the spot instance node groups"
  type        = number
}

variable "spot_max_size" {
  default     = 2
  description = "Maximum number of instances in the spot instance node groups"
  type        = number
}

variable "ami_type" {
  default     = "AL2_x86_64"
  description = "AMI type used in the node groups"
  type        = string
}

variable "disk_size" {
  default     = 100
  description = "Disk size used in the node groups"
  type        = number
}

variable "instance_types" {
  default     = ["m5a.2xlarge", "m6a.2xlarge"]
  description = "Instance types used in the node groups"
  type        = list(string)
}

variable "on_demand_node_group" {
  default     = 1
  description = "Number of on-demand instance node groups"
  type        = number
}

variable "on_demand_min_size" {
  default     = 0
  description = "Minimum number of instances in the on-demand instance node groups"
  type        = number
}

variable "on_demand_desired_size" {
  default     = 1
  description = "Desired number of instances in the on-demand instance node groups"
  type        = number
}

variable "on_demand_max_size" {
  default     = 2
  description = "Maximum number of instances in the on-demand instance node groups"
  type        = number
}

variable "coredns_version" {
  default     = "v1.11.1-eksbuild.11"
  description = "CoreDNS add-on version"
  type        = string
}

variable "kube_proxy_version" {
  default     = "v1.29.3-eksbuild.5"
  description = "Kube-Proxy add-on version"
  type        = string
}

variable "vpc_cni_version" {
  default     = "v1.18.3-eksbuild.1"
  description = "VPC-CNI add-on version"
  type        = string
}