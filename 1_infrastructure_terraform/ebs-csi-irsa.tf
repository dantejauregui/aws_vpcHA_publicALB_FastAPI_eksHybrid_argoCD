# =========================
# EBS CSI DRIVER IRSA ROLE
# =========================

data "aws_iam_policy_document" "ebs_csi_assume_role_policy" {

  statement {

    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {

      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.eks.arn
      ]

    }

    condition {

      test = "StringEquals"

      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"

      values = [
        "system:serviceaccount:kube-system:ebs-csi-controller-sa"
      ]

    }

    condition {

      test = "StringEquals"

      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:aud"

      values = [
        "sts.amazonaws.com"
      ]

    }

  }

}


resource "aws_iam_role" "ebs_csi_irsa_role" {

  name = "${var.project_name}-${var.environment}-ebs-csi-role"

  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role_policy.json

}


resource "aws_iam_role_policy_attachment" "ebs_csi_policy" {

  role = aws_iam_role.ebs_csi_irsa_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"

}
