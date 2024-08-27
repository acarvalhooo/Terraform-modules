# Configuring provider
terraform {
  required_version = ">= 1.5"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20"
    }
  }
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = var.api_server_endpoint
  cluster_ca_certificate = base64decode(var.certificate_authority)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}