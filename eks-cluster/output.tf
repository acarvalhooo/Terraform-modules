output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = aws_eks_cluster.cluster.arn
}

output "cluster_oidc_url" {
  description = "OIDC URL of the EKS cluster"
  value       = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.cluster.name
}

output "api_server_endpoint" {
  description = "API server endpoint of the EKS cluster"
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_ca_certificate" {
  description = "CA certificate of the EKS cluster"
  value       = aws_eks_cluster.cluster.certificate_authority.0.data
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC used by the EKS cluster"
  value       = aws_iam_openid_connect_provider.oidc_provider.arn
}

output "node_group_role_arn" {
  description = "ARN of the role used by the node groups"
  value       = aws_iam_role.node_group_role.arn
}