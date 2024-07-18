# Creating role to be used for EKS cluster
resource "aws_iam_role" "cluster_role" {
  name = local.cluster_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  tags = merge(var.tags, { Name = local.cluster_role_name })
}

# Attaching policys to the role used by EKS cluster
resource "aws_iam_role_policy_attachment" "cluster_attachment" {
  for_each = {
    "attachment-01" = { policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" }
    "attachment-02" = { policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy" }
  }

  role       = aws_iam_role.cluster_role.name
  policy_arn = each.value.policy_arn
}

# Getting account ID to configure as KMS key administrator
data "aws_caller_identity" "current" {}

# Creating KMS key to encrypt EKS secrets
resource "aws_kms_key" "kms_key" {
  description             = "Key used for EKS cluster ${var.cluster_name} to encrypt secrets"
  deletion_window_in_days = 30
  enable_key_rotation     = var.enable_key_rotation
  rotation_period_in_days = var.enable_key_rotation == true ? var.rotation_period_in_days : null

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "KeyAdministration"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "kms:Update*",
          "kms:UntagResource",
          "kms:TagResource",
          "kms:ScheduleKeyDeletion",
          "kms:Revoke*",
          "kms:Put*",
          "kms:List*",
          "kms:Get*",
          "kms:Enable*",
          "kms:Disable*",
          "kms:Describe*",
          "kms:Delete*",
          "kms:Create*",
          "kms:CancelKeyDeletion"
        ]
        Resource = "*"
      },
      {
        Sid    = "KeyUsage"
        Effect = "Allow"
        Principal = {
          AWS = "${aws_iam_role.cluster_role.arn}"
        }
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:GenerateDataKey*",
          "kms:ReEncrypt*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(var.tags, { Name = local.key_name })
}

# Creating KMS key alias
resource "aws_kms_alias" "kms_alias" {
  name          = local.key_name
  target_key_id = aws_kms_key.kms_key.key_id
}

# Creating EKS cluster
resource "aws_eks_cluster" "cluster" {
  name                      = var.cluster_name
  role_arn                  = aws_iam_role.cluster_role.arn
  version                   = var.cluster_version
  enabled_cluster_log_types = var.enabled_cluster_log_types

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.kms_key.arn
    }
  }

  access_config {
    authentication_mode                         = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  }

  tags = merge(var.tags, { Name = var.cluster_name })
}

# Creating identity provider
data "tls_certificate" "oidc_certificate" {
  url = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc_certificate.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

# Creating role to be used for node groups
resource "aws_iam_role" "node_group_role" {
  name = local.node_group_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = merge(var.tags, { Name = local.node_group_role_name })
}

# Attaching policys to the role used by node groups
resource "aws_iam_role_policy_attachment" "node_group_attachment" {
  for_each = {
    "attachment-01" = { policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" }
    "attachment-02" = { policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy" }
    "attachment-03" = { policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" }
  }

  role       = aws_iam_role.node_group_role.name
  policy_arn = each.value.policy_arn
}

# Creating managed node group of spot instances
resource "aws_eks_node_group" "spot_node_group" {
  count           = var.spot_node_group
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${local.spot_node_group_name}-${count.index}"
  node_role_arn   = aws_iam_role.node_group_role.arn

  scaling_config {
    min_size     = var.spot_min_size
    desired_size = var.spot_desired_size
    max_size     = var.spot_max_size
  }

  ami_type       = var.ami_type
  capacity_type  = "SPOT"
  disk_size      = var.disk_size
  instance_types = var.instance_types
  subnet_ids     = var.subnet_ids

  tags = merge(var.tags, { Name = local.spot_node_group_name })
}

# Creating managed node group of on-demand instances
resource "aws_eks_node_group" "on_demand_node_group" {
  count           = var.on_demand_node_group
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${local.on_demand_node_group_name}-${count.index}"
  node_role_arn   = aws_iam_role.node_group_role.arn

  scaling_config {
    min_size     = var.on_demand_min_size
    desired_size = var.on_demand_desired_size
    max_size     = var.on_demand_max_size
  }

  ami_type       = var.ami_type
  capacity_type  = "ON_DEMAND"
  disk_size      = var.disk_size
  instance_types = var.instance_types
  subnet_ids     = var.subnet_ids

  tags = merge(var.tags, { Name = local.on_demand_node_group_name })
}

# Installing add-ons
resource "aws_eks_addon" "add_ons" {
  for_each = {
    "coredns"    = { addon_name = "coredns", addon_version = var.coredns_version }
    "kube-proxy" = { addon_name = "kube-proxy", addon_version = var.kube_proxy_version }
    "vpc-cni"    = { addon_name = "vpc-cni", addon_version = var.vpc_cni_version }
  }

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = each.value.addon_name
  addon_version               = each.value.addon_version

  depends_on = [aws_eks_node_group.spot_node_group, aws_eks_node_group.on_demand_node_group]
}