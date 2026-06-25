resource "kubernetes_service_account_v1" "alb_controller" {

  metadata {

    name = "aws-load-balancer-controller"

    namespace = "kube-system"

    annotations = {

      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller_role.arn

    }
  }
}

resource "helm_release" "aws_load_balancer_controller" {

  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"

  chart = "aws-load-balancer-controller"

  namespace = "kube-system"

  timeout = 900

  wait = true

  set = [
    {
      name  = "clusterName"
      value = var.cluster_name
    },

    {
      name  = "vpcId"
      value = var.vpc_id
    },

    {
      name  = "region"
      value = var.aws_region
    },

    {
      name  = "serviceAccount.create"
      value = "false"
    },

    {
      name  = "serviceAccount.name"
      value = kubernetes_service_account_v1.alb_controller.metadata[0].name
    }
  ]

  depends_on = [
    aws_iam_role_policy_attachment.alb_controller_policy_attachment
  ]
}
