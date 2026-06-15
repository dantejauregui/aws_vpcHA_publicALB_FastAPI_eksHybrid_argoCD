# =========================
# FARGATE PROFILE
# Application Workloads
# =========================

resource "aws_eks_fargate_profile" "applications" {

  cluster_name         = aws_eks_cluster.fastApi_eks.name
  fargate_profile_name = "applications"

  pod_execution_role_arn = aws_iam_role.fargate_execution_role.arn

  subnet_ids = [
    aws_subnet.fastApi_snet_private_1.id,
    aws_subnet.fastApi_snet_private_2.id
  ]

  selector {

    namespace = "fargate-apps"

  }

  selector {

    namespace = "fargate-apps-dev"

  }

  selector {

    namespace = "fargate-apps-prod"

  }

  depends_on = [
    aws_eks_cluster.fastApi_eks,
    aws_iam_role_policy_attachment.fargate_execution_policy
  ]
}
