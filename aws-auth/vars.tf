variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "api_server_endpoint" {
  description = "API server endpoint of the cluster"
  type        = string
}

variable "certificate_authority" {
  description = "Certificate authority of the cluster"
  type        = string
}

variable "create_aws_auth_configmap" {
  default     = false
  description = "Determines the creation of the aws-auth ConfigMap"
  type        = bool
}

variable "manage_aws_auth_configmap" {
  default     = true
  description = "Determines the management of the aws-auth ConfigMap"
  type        = bool
}

variable "aws_auth_roles" {
  default     = []
  description = "IAM roles to add to the aws-auth ConfigMap"
  type        = list(any)
}

variable "aws_auth_users" {
  default     = []
  description = "IAM users to add to the aws-auth ConfigMap"
  type        = list(any)
}

variable "aws_auth_accounts" {
  default     = []
  description = "AWS accounts to add to the aws-auth ConfigMap"
  type        = list(any)
}