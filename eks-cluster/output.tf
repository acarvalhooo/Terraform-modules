output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = aws_eks_cluster.cluster.arn
}

output "cluster_oidc_url" {
  description = "EKS cluster OIDC URL"
  value       = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.cluster.name
}

output "api_server_endpoint" {
  description = "EKS cluster API server endpoint"
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_ca_certificate" {
  description = "EKS cluster CA certificate"
  value       = aws_eks_cluster.cluster.certificate_authority.0.data
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN used for EKS cluster"
  value       = aws_iam_openid_connect_provider.oidc_provider.arn
}

output "node_group_role_arn" {
  description = "Node group ARN used for node groups"
  value       = aws_iam_role.node_group_role.arn
}