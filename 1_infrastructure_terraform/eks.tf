# =========================
# EKS CLUSTER
# Control Plane
# =========================

resource "aws_eks_cluster" "fastApi_eks" {

  name     = "${var.project_name}-${var.environment}-eks"
  role_arn = aws_iam_role.eks_cluster_role.arn

  version = var.eks_version

  access_config {
    authentication_mode = "API"
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  vpc_config {

    subnet_ids = [
      aws_subnet.fastApi_snet_private_1.id,
      aws_subnet.fastApi_snet_private_2.id
    ]

    endpoint_private_access = true
    endpoint_public_access  = true

  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}


# =========================
# EKS MANAGED NODE GROUP
# Platform Components - This is where the platform workloads will run
# =========================

resource "aws_eks_node_group" "platform" {

  cluster_name    = aws_eks_cluster.fastApi_eks.name
  node_group_name = "platform"

  node_role_arn = aws_iam_role.eks_node_role.arn

  subnet_ids = [
    aws_subnet.fastApi_snet_private_1.id,
    aws_subnet.fastApi_snet_private_2.id
  ]

  capacity_type = "ON_DEMAND"

  instance_types = [
    "t3.small"
  ]

  scaling_config {

    desired_size = 2
    min_size     = 2
    max_size     = 3

  }

  update_config {

    max_unavailable = 1

  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_ecr_readonly_policy,
    aws_iam_role_policy_attachment.eks_cni_policy
  ]
}
