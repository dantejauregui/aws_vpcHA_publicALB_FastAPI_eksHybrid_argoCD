data "aws_caller_identity" "current" {}

resource "aws_eks_access_entry" "cluster_admin" {

  cluster_name = aws_eks_cluster.fastApi_eks.name

  principal_arn = "arn:aws:iam::725423737651:role/aws-reserved/sso.amazonaws.com/eu-central-1/AWSReservedSSO_AdministratorAccess_056143265a2340d2"

  type = "STANDARD"
}

resource "aws_eks_access_policy_association" "cluster_admin" {

  cluster_name = aws_eks_cluster.fastApi_eks.name

  principal_arn = aws_eks_access_entry.cluster_admin.principal_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}
