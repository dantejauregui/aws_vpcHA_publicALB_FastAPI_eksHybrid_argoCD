# =========================
# EKS CLUSTER ROLE
# Used by EKS Control Plane
# =========================

data "aws_iam_policy_document" "eks_cluster_trust_policy" {

  statement {

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

  }

}

resource "aws_iam_role" "eks_cluster_role" {

  name = "${var.project_name}-${var.environment}-eks-cluster-role"

  assume_role_policy = data.aws_iam_policy_document.eks_cluster_trust_policy.json

}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {

  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

}


# =========================
# EKS NODE GROUP ROLE
# Used by EC2 Worker Nodes
# =========================

data "aws_iam_policy_document" "eks_node_trust_policy" {

  statement {

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

  }

}

resource "aws_iam_role" "eks_node_role" {

  name = "${var.project_name}-${var.environment}-eks-node-role"

  assume_role_policy = data.aws_iam_policy_document.eks_node_trust_policy.json

}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {

  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

}

resource "aws_iam_role_policy_attachment" "eks_ecr_readonly_policy" {

  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {

  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

}


# =========================
# FARGATE POD EXECUTION ROLE
# Used by EKS Fargate Infrastructure
# =========================

data "aws_iam_policy_document" "fargate_execution_trust_policy" {

  statement {

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

  }

}

resource "aws_iam_role" "fargate_execution_role" {

  name = "${var.project_name}-${var.environment}-fargate-execution-role"

  assume_role_policy = data.aws_iam_policy_document.fargate_execution_trust_policy.json

}

resource "aws_iam_role_policy_attachment" "fargate_execution_policy" {

  role       = aws_iam_role.fargate_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"

}
