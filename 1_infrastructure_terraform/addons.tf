# =========================
# EBS CSI DRIVER ADDON
# =========================

resource "aws_eks_addon" "ebs_csi_driver" {

  cluster_name = aws_eks_cluster.fastApi_eks.name

  addon_name = "aws-ebs-csi-driver"

  service_account_role_arn = aws_iam_role.ebs_csi_irsa_role.arn

  depends_on = [
    aws_iam_role_policy_attachment.ebs_csi_policy
  ]

}


# =========================
# VPC CNI ADDON
# =========================

resource "aws_eks_addon" "vpc_cni" {

  cluster_name = aws_eks_cluster.fastApi_eks.name

  addon_name = "vpc-cni"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

}


# =========================
# COREDNS ADDON
# =========================

resource "aws_eks_addon" "coredns" {

  cluster_name = aws_eks_cluster.fastApi_eks.name

  addon_name = "coredns"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

}


# =========================
# KUBE PROXY ADDON
# =========================

resource "aws_eks_addon" "kube_proxy" {

  cluster_name = aws_eks_cluster.fastApi_eks.name

  addon_name = "kube-proxy"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

}


# =========================
# EKS POD IDENTITY AGENT ADDON
# =========================

resource "aws_eks_addon" "pod_identity_agent" {

  cluster_name = aws_eks_cluster.fastApi_eks.name

  addon_name = "eks-pod-identity-agent"

}
