data "aws_iam_openid_connect_provider" "eks" {

  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer

}

data "aws_iam_policy_document" "alb_controller_assume_role_policy" {

  statement {

    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {

      type = "Federated"

      identifiers = [
        data.aws_iam_openid_connect_provider.eks.arn
      ]
    }

    condition {

      test = "StringEquals"

      variable = "${replace(data.aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"

      values = [
        "system:serviceaccount:kube-system:aws-load-balancer-controller"
      ]
    }
  }
}

resource "aws_iam_role" "alb_controller_role" {

  name = "${var.project_name}-${var.environment}-alb-controller-role"

  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role_policy.json

}

resource "aws_iam_policy" "alb_controller_policy" {

  name = "${var.project_name}-${var.environment}-alb-controller-policy"

  policy = file("${path.module}/aws-load-balancer-controller-policy.json")

}

resource "aws_iam_role_policy_attachment" "alb_controller_policy_attachment" {

  role = aws_iam_role.alb_controller_role.name

  policy_arn = aws_iam_policy.alb_controller_policy.arn

}
